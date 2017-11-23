//
//  AdmitadDelegate.swift
//  AdmitadSDK
//
//  Created by Dmitry Cherednikov on 02.10.17.
//  Copyright © 2017 tachos. All rights reserved.
//

import Foundation

/**
 Describes interface of a class capable of receiving notifications from AdmitadTracker.
 */
public protocol AdmitadDelegate: AnyObject {
    /**
     Your delegate object is notified throughout this method right after AdmitadTracker started tracking an event.
     - parameter event: Tracked event.
     */
    func startedTrackingAdmitadEvent(_ event: AdmitadEvent)
    /**
     Your delegate object is notified throughout this method right after AdmitadTracker finished tracking an event.
     - parameter event: Tracked event.
     - parameter error: Represents an error occured when tracking event. Equals to nil if tracking successful.
     */
    func finishedTrackingAdmitadEvent(_ event: AdmitadEvent?,
                                      error: AdmitadError?)
}
