//
//  AdmitadEvent+Factory.swift
//  AdmitadSDK
//
//  Created by Dmitry Cherednikov on 06.10.17.
//  Copyright © 2017 tachos. All rights reserved.
//

import Foundation
import AdSupport

// MARK: - factory
internal extension AdmitadEvent {
    static func confirmedPurchaseEvent(order: AdmitadOrder) throws -> AdmitadEvent {
        var params = try idParameters()

        params[.tracking] = AdmitadTrackingType.confirmedPurchase.rawValue
        params[.oid] = order.id
        params[.price] = order.totalPrice
        params[.currencyCode] = order.currencyCode
        params[.device] = getIDFA()
        params[.json] = order.json
        params[.tarifcode] = order.tarifCode ?? "";
        params[.promocode] = order.promocode ?? "";
        
        let url = try AdmitadURL.requestURL(params: params)
        
        return AdmitadEvent(url: url)
    }

    static func paidOrderEvent(order: AdmitadOrder) throws -> AdmitadEvent {
        var params = try idParameters()

        params[.tracking] = AdmitadTrackingType.paidOrder.rawValue
        params[.oid] = order.id
        params[.price] = order.totalPrice
        params[.currencyCode] = order.currencyCode
        params[.device] = getIDFA()
        params[.json] = order.json
        params[.tarifcode] = order.tarifCode ?? "";
        params[.promocode] = order.promocode ?? "";

        let url = try AdmitadURL.requestURL(params: params)

        return AdmitadEvent(url: url)
    }

    static func registerEvent(userId: String) throws -> AdmitadEvent {
        var params = try idParameters()

        params[.tracking] = AdmitadTrackingType.registration.rawValue
        params[.oid] = userId
        params[.device] = getIDFA()

        let url = try AdmitadURL.requestURL(params: params)

        return AdmitadEvent(url: url)
    }

    static func loyaltyEvent(userId: String,
                             loyalty: Int) throws -> AdmitadEvent {
        var params = try idParameters()

        params[.tracking] = AdmitadTrackingType.loyalty.rawValue
        params[.oid] = userId
        params[.loyalty] = String(loyalty)
        params[.device] = getIDFA()

        let url = try AdmitadURL.requestURL(params: params)

        return AdmitadEvent(url: url)
    }

    static func returnedEvent(userId: String,
                              day: Int) throws -> AdmitadEvent {
        var params = try idParameters()

        params[.tracking] = AdmitadTrackingType.returned.rawValue
        params[.oid] = userId
        params[.day] = String(day)
        params[.device] = getIDFA()

        let url = try AdmitadURL.requestURL(params: params)

        return AdmitadEvent(url: url)
    }

    static func installedEvent(fingerprint: AdmitadFingerprint) throws -> AdmitadEvent {
        guard let postbackKey = AdmitadTracker.sharedInstance.postbackKey else {
            AdmitadLogger.logNoPostbackKey()
            throw AdmitadError(type: .noPostbackKey)
        }
        
        var params = AdmitadParamValuePairs()
        params[.postbackKey] = postbackKey
        params[.fingerprint] = fingerprint.json
        params[.device] = getIDFA()

        let url = try AdmitadURL.requestURL(params: params, apiUrl: AdmitadURL.installationTracking)

        return AdmitadEvent(url: url)
    }
}

// MARK: - id parameters
private extension AdmitadEvent {
    static func idParameters() throws -> AdmitadParamValuePairs {
        guard let postbackKey = AdmitadTracker.sharedInstance.postbackKey else {
            AdmitadLogger.logNoPostbackKey()
            throw AdmitadError(type: .noPostbackKey)
        }
        guard let uid = AdmitadTracker.sharedInstance.uid else {
            AdmitadLogger.logNoUid()
            throw AdmitadError(type: .noUid)
        }
        var params = AdmitadParamValuePairs()
        params[.postbackKey] = postbackKey
        params[.admitadUid] = uid
        return params
    }
}

// MARK: IDFA
private extension AdmitadEvent {
    static func getIDFA() -> String {
        let identifierManager = ASIdentifierManager.shared()
        if identifierManager.isAdvertisingTrackingEnabled {
            return identifierManager.advertisingIdentifier.uuidString
        }
        return ""
    }
}
