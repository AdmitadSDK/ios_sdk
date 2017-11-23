//
//  AdmitadLogger.swift
//  AdmitadSDK
//
//  Created by Dmitry Cherednikov on 29.09.17.
//  Copyright © 2017 tachos. All rights reserved.
//

import Foundation

internal class AdmitadLogger {}

// MARK: - request building
internal extension AdmitadLogger {
    static func logNoPostbackKey() {
        if !loggingEnabled {
            return
        }
        printLogHeader()
        print("\"postback_key\" is not provided.\n")
    }

    static func logNoUid() {
        if !loggingEnabled {
            return
        }
        printLogHeader()
        print("\"admitad_uid\" is not provided.")
        print("Probably continueUserActivity() was not called, or received wrong webpageURL.\n")
    }
}

// MARK: - request sending
internal extension AdmitadLogger {
    static func logRequestSent(_ request: AdmitadRequest) {
        if !loggingEnabled {
            return
        }
        printLogHeader()
        print("Request sent to Admitad: \(String(describing: request.url)).\n")
    }

    static func logRequestSucceeded(_ request: AdmitadRequest) {
        if !loggingEnabled {
            return
        }
        printLogHeader()
        print("Request to Admitad succeeded: \(String(describing: request.url)).\n")
    }

	static func logRequestFailed(_ request: AdmitadRequest, error: AdmitadError) {
        if !loggingEnabled {
            return
        }
        printLogHeader()
        print("Request to Admitad failed: \(String(describing: request.url)).\n\(error.localizedDescription)\n")
    }
}

// MARK: - serialization
internal extension AdmitadLogger {
    static func logSerializationSucceeded() {
        if !loggingEnabled {
            return
        }
        printLogHeader()
        print("Successfully serialized all requests to disk.\n")
    }

    static func logSerializationFailed() {
        if !loggingEnabled {
            return
        }
        printLogHeader()
        print("Failed to serialize requests to disk.\n")
    }
}

// MARK: - private
private extension AdmitadLogger {
    static var loggingEnabled: Bool {
        return AdmitadTracker.sharedInstance.loggingEnabled
    }

    static func printLogHeader() {
        print("\nAdmitadSDK \(Date())")
    }
}
