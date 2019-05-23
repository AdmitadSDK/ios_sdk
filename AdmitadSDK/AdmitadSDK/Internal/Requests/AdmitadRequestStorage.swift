//
//  AdmitadRequestStorage.swift
//  AdmitadSDK
//
//  Created by Dmitry Cherednikov on 29.09.17.
//  Copyright © 2017 tachos. All rights reserved.
//

import Foundation

private let documentsDirectory = FileManager().urls(for: .libraryDirectory, in: .userDomainMask).first!
private let archiveURL = documentsDirectory.appendingPathComponent("admitad_requests")

// MARK: - class declaration
internal class AdmitadRequestStorage {
    static let sharedInstance = AdmitadRequestStorage()

	private var requests: [AdmitadRequest]

    private init() {
		requests = AdmitadRequestStorage.storedRequests
	}
}

// MARK: - requests access and update
internal extension AdmitadRequestStorage {
    func getFailedRequests(completion: @escaping ([AdmitadRequest]) -> Void) {
        completion(failedRequests())
    }

    func updateRequestStatus(_ request: AdmitadRequest,
                                      status: AdmitadRequestStatus) {
        request.status = status
        switch request.status {
        case .undefined:
            // do nothing
            break

        case .failed:
            // do nothing, request remains in requests array
            break

        case .succeeded:
            removeRequest(request)

        case .pending:
            addRequestIfNeeded(request)

        case .notAccepted:
            removeRequest(request)
            
        }
    }
}

// MARK: - private request access
private extension AdmitadRequestStorage {
    func failedRequests() -> [AdmitadRequest] {
        return requests.filter({ (request) -> Bool in
            if request.status == .failed {
                return true
            }
            return false
        })
    }
}

// MARK: - requests adding and removing
private extension AdmitadRequestStorage {
    func removeRequest(_ request: AdmitadRequest) {
        if let index = requests.firstIndex(of: request) {
            requests.remove(at: index)
            saveRequests()
        }
    }

    func addRequestIfNeeded(_ request: AdmitadRequest) {
        if requests.contains(request) {
            return
        }
        requests.append(request)
        saveRequests()
    }
}

// MARK: - data persistance
private extension AdmitadRequestStorage {
    func saveRequests() {
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            AdmitadRequestStorage.storedRequests = self.requests
        }
    }
	
	static var storedRequests: [AdmitadRequest] {
		get {
			if let restoredRequests = NSKeyedUnarchiver.unarchiveObject(withFile: archiveURL.path) as? [AdmitadRequest] {
				return restoredRequests
			} else {
				return [AdmitadRequest]()
			}
		}
		set {
			let success = NSKeyedArchiver.archiveRootObject(newValue, toFile: archiveURL.path)
			self.logSuccess(success)
		}
	}
	
}

// MARK: - utility
private extension AdmitadRequestStorage {
    static func logSuccess(_ success: Bool) {
        if success {
            AdmitadLogger.logSerializationSucceeded()
        } else {
            AdmitadLogger.logSerializationFailed()
        }
    }
}
