//
//  AdmitadRequestStatus.swift
//  AdmitadSDK
//
//  Created by Dmitry Cherednikov on 03.10.17.
//  Copyright © 2017 tachos. All rights reserved.
//

import Foundation

internal enum AdmitadRequestStatus {
    case undefined
    case failed
    case succeeded
    case pending
    case notAccepted
}
