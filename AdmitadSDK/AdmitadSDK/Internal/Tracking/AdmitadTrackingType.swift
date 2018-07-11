//
//  AdmitadTrackingType.swift
//  AdmitadSDK
//
//  Created by Dmitry Cherednikov on 06.10.17.
//  Copyright © 2017 tachos. All rights reserved.
//

import Foundation

internal enum AdmitadTrackingType: String {
    case installed = "install"
    case confirmedPurchase = "confirmed_purchase"
    case paidOrder = "paid_order"
    case registration = "registration"
    case loyalty = "loyalty"
    case returned = "returned"
}
