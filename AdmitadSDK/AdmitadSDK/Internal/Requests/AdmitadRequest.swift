//
//  AdmitadRequest.swift
//  AdmitadSDK
//
//  Created by Dmitry Cherednikov on 28.09.17.
//  Copyright © 2017 tachos. All rights reserved.
//

import Foundation

// MARK: - archiving constants
private struct PropertyKey {
    static let url = "url"
}

// MARK: - class definition
internal class AdmitadRequest: NSObject, NSCoding {
    internal var url: URL {
        return event.url
    }
    internal let event: AdmitadEvent
    internal var status = AdmitadRequestStatus.undefined

    // MARK: - initializers
    internal init(event: AdmitadEvent,
                  status: AdmitadRequestStatus = .undefined) {
        self.event = event
        self.status = status
    }

    // MARK: - NSCoding protocol
    internal func encode(with aCoder: NSCoder) {
        aCoder.encode(url, forKey: PropertyKey.url)
    }

    // NOTE: We decode AmitadRequest with 'failed' status
    // as there is no point in restoring them as 'pending' after the app's launch
    // and setting the status for all requests in the restored array
    internal required convenience init?(coder aDecoder: NSCoder) {
        guard let url = aDecoder.decodeObject(forKey: PropertyKey.url) as? URL else {
            return nil
        }
        let event = AdmitadEvent(url: url)
        self.init(event: event,
                  status: .failed)
    }
}
