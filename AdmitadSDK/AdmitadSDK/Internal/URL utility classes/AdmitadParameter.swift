//
//  AdmitadParameters.swift
//  AdmitadSDK
//
//  Created by Dmitry Cherednikov on 28.09.17.
//  Copyright © 2017 tachos. All rights reserved.
//

import Foundation

internal enum AdmitadParameter: String {
    case postbackKey = "pk"
    case admitadUid = "uid"
    case tracking = "tracking"
    case oid = "oid"
    case price = "price"
    case currencyCode = "currency_code"
    case json = "json"
    case loyalty = "loyalty"
    case day = "day"
    case device = "device"
    case fingerprint = "fingerprint"
    case tarifcode = "tc"
    case promocode = "promocode"
    case channel = "channel"
    case sdkVersion = "sdk"
    case deviceType = "adm_device"
    case os = "adm_ostype"
    case method = "adm_method"
}
