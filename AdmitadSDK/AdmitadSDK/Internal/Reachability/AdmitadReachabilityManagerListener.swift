//
//  AdmitadReachabilityManagerListener.swift
//  AdmitadSDK
//
//  Created by Dmitry Cherednikov on 04.10.17.
//  Copyright © 2017 tachos. All rights reserved.
//

import Foundation

internal protocol AdmitadReachabilityManagerListener: AnyObject {
    func reachabilityChanged(_ reachability: AdmitadReachability)
}
