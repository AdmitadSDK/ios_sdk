//
//  AdmitadError.swift
//  AdmitadSDK
//
//  Created by Dmitry Cherednikov on 02.10.17.
//  Copyright © 2017 tachos. All rights reserved.
//

import Foundation

/**
 Error types representing a general idea as to why AdmitadEvent tracking could fail.
 - *unknown*: it was not possible to determine the exact reason of failure.
 - *requestNotAccepted*: response with not appropriate status code was received from server.
 - *serverIsNotReachable*: failed to send the request due to absense of Internet connection.
 */
public enum AdmitadErrorType: String {
    case unknown = "Unknown error"
    case noPostbackKey = "No Postback Key is provided"
    case noUid = "No Uid is provided"
    case requestNotAccepted = "Request not accepted"
    case serverIsNotReachable = "Server is not reachable"
    case sdkInternal = "Internal error in AdmitadSDK"
}


/**
 A struct representing an error that can occur when trying to send requests to Admitad.
 As it conforms to Error protocol, you can use an instance of this class to throw, catch and propagate errors.
 */
public class AdmitadError: NSObject, Error {
    /**
     Description of the error that can be used for debugging. Contains full response from server if received.
     */
    @objc public var localizedDescription: String {
        var string = "AdmitadError: " + type.rawValue + "."
        if let requestError = requestError {
            string += " \n" + requestError.localizedDescription
        }
        if let serverResponse = serverResponse {
            string += " \nServer response: " + serverResponse.description
        }
        return string
    }
    /**
     Error type representing a general idea
     as to why event tracking could fail.
     Please refer to the type's documentation.
     */
    public let type: AdmitadErrorType

    private let serverResponse: HTTPURLResponse?
    private let requestError: Error?

    init(type: AdmitadErrorType,
         serverResponse: HTTPURLResponse? = nil,
         requestError: Error? = nil) {
        self.type = type
        self.serverResponse = serverResponse
        self.requestError = requestError
    }
}
