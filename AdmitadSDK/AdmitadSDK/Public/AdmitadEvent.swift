//
//  AdmitadEvent.swift
//  AdmitadSDK
//
//  Created by Dmitry Cherednikov on 02.10.17.
//  Copyright © 2017 tachos. All rights reserved.
//

import Foundation

/**
 Represents an Admitad event. Can't be instantiated directly.
 Can be accessed in AdmitadDelegate methods.
 */
public class AdmitadEvent: NSObject {
    /**
     Event's type. Optional info on the event can be retrieved
     from parametrized AdmitadEventType enum.
     */
    public let type: AdmitadEventType

    internal let url: URL

    init(url: URL) {
        let type = AdmitadEventType.init(url: url)

        self.type = type ?? .installed
        self.url = url
    }
}
