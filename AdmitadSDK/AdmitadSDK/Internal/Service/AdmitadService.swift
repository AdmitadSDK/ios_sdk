//
//  AdmitadService.swift
//  AdmitadSDK
//
//  Created by Dmitry Cherednikov on 28.09.17.
//  Copyright © 2017 tachos. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - class declaration
internal class AdmitadService: AdmitadReachabilityManagerListener {
    private let storage: AdmitadRequestStorage
    private let reachabilityManager: AdmitadReachabilityManager

    init() {
        storage = AdmitadRequestStorage.sharedInstance

        reachabilityManager = AdmitadReachabilityManager.sharedInstance
        reachabilityManager.listener = self
        reachabilityManager.startListening()
    }
}

// MARK: - AdmitadReachabilityManagerListener protocol
internal extension AdmitadService {
    func reachabilityChanged(_ reachability: AdmitadReachability) {
        if reachability == .reachable {
            resendFailedRequestsIfNeeded()
        }
    }
}

// MARK: - sending requests
internal extension AdmitadService {
    func sendRequest(request: AdmitadRequest,
                              completion: AdmitadCompletion? = nil) {
        storage.updateRequestStatus(request, status: .pending)
		AdmitadLogger.logRequestSent(request)
		
		// TODO: remove test implementation
		//            sendRequestTestImplementation(request: admitadRequest,
		//                                          completion: completion)
		sendRequestAlamofireImplementation(request: request,
										   completion: completion)
		//            sendRequestURLSessionImplementation(request: request,
		//                                                completion: completion)
    }
}

// MARK: resending requests
private extension AdmitadService {
    func resendFailedRequestsIfNeeded() {
        storage.getFailedRequests { (failedRequests) in
            for request in failedRequests {
                // NOTE: we send request without completion
                self.sendRequest(request: request)
            }
        }
    }
}

// MARK: success or failure handling
private extension AdmitadService {
    func onRequestSucceeded(_ request: AdmitadRequest,
                                    completion: AdmitadCompletion? = nil) {
        AdmitadLogger.logRequestSucceeded(request)

        storage.updateRequestStatus(request, status: .succeeded)
        completion?(nil)
    AdmitadTracker.sharedInstance.delegate?.finishedTrackingAdmitadEvent(request.event, error: nil)
    }

    func onRequestFailed(_ request: AdmitadRequest,
                                 completion: AdmitadCompletion? = nil,
                                 error: AdmitadError) {
        AdmitadLogger.logRequestFailed(request, error: error)

        switch error.type {
        case .requestNotAccepted:
            storage.updateRequestStatus(request, status: .notAccepted)

        case .serverIsNotReachable:
            storage.updateRequestStatus(request, status: . failed)

        case .unknown:
            storage.updateRequestStatus(request, status: .failed)

        case .noUid, .noPostbackKey, .sdkInternal:
            break
        }

        completion?(error)
    AdmitadTracker.sharedInstance.delegate?.finishedTrackingAdmitadEvent(request.event, error: error)
    }
}

// MARK: - actual sending (including test implementations)
private extension AdmitadService {
    func sendRequestTestImplementation(request admitadRequest: AdmitadRequest,
                                               completion: AdmitadCompletion?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let errorType = AdmitadErrorType.serverIsNotReachable
            self.onRequestFailed(admitadRequest,
                                 completion: completion,
                                 error: AdmitadError(type: errorType))
            // self.onRequestSucceeded(admitadRequest, completion: completion)
        })
    }

    // TODO: test actual implementation, move to sendRequest  
    func sendRequestAlamofireImplementation(request admitadRequest: AdmitadRequest,
                                                    completion: AdmitadCompletion?) {
        request(admitadRequest.url).response {[weak self] (response) in
            guard let strongSelf = self else {
                return
            }

            let statusCode = response.response?.statusCode
            if statusCode == nil || response.error != nil {
                // no response or unknown error
                let error = AdmitadError(type: .unknown,
                                         requestError: response.error)
                strongSelf.onRequestFailed(admitadRequest,
                                           completion: completion,
                                           error: error)
            } else if statusCode == 200 {
                // request succeeded
                strongSelf.onRequestSucceeded(admitadRequest,
                                              completion: completion)
            } else {
                // request not accepted
                let error = AdmitadError(type: .requestNotAccepted,
                                         serverResponse: response.response)
                strongSelf.onRequestFailed(admitadRequest,
                                           completion: completion,
                                           error: error)
            }
        }
    }

    func sendRequestURLSessionImplementation(request admitadRequest: AdmitadRequest,
                                                     completion: AdmitadCompletion?) {
                let config = URLSessionConfiguration.default
                let session = URLSession(configuration: config)

                let urlRequest = URLRequest(url: admitadRequest.url)
                let task = session.dataTask(with: urlRequest) { (_, _, _) in

                }
                task.resume()
    }
}
