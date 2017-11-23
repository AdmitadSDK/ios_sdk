//
//  AdmitadReachability.swift
//  AdmitadSDK
//
//  Created by Dmitry Cherednikov on 04.10.17.
//  Copyright © 2017 tachos. All rights reserved.
//

import Foundation

internal enum AdmitadReachability {
    case reachable
    case notReachable
}

internal enum AdmitadConnectionType: String {
    case undefined = "undefined"
    case ethernetOrWiFi = "wifi"
    case wwan = "wwan"
}
