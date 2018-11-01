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
    static func confirmedPurchaseEvent(order: AdmitadOrder, channel: String? = nil) throws -> AdmitadEvent {
        var params = try idParameters()

        params[.tracking] = AdmitadTrackingType.confirmedPurchase.rawValue
        params[.oid] = order.id
        params[.price] = order.totalPrice
        params[.currencyCode] = order.currencyCode
        params[.json] = order.json
        params[.channel] = channel ?? AdmitadTracker.ADM_MOBILE_CHANNEL

        if let tarifcode = order.tarifCode {
            params[.tarifcode] = tarifcode;
        }

        if let promocode = order.promocode {
            params[.promocode] = promocode;
        }

        let url = try AdmitadURL.requestURL(params: params)
        
        return AdmitadEvent(url: url)
    }

    static func paidOrderEvent(order: AdmitadOrder, channel: String? = nil) throws -> AdmitadEvent {
        var params = try idParameters()

        params[.tracking] = AdmitadTrackingType.paidOrder.rawValue
        params[.oid] = order.id
        params[.price] = order.totalPrice
        params[.currencyCode] = order.currencyCode
        params[.json] = order.json
        params[.channel] = channel ?? AdmitadTracker.ADM_MOBILE_CHANNEL
        
        if let tarifcode = order.tarifCode {
            params[.tarifcode] = tarifcode;
        }

        if let promocode = order.promocode {
            params[.promocode] = promocode;
        }

        let url = try AdmitadURL.requestURL(params: params)

        return AdmitadEvent(url: url)
    }

    static func registerEvent(userId: String, channel: String? = nil) throws -> AdmitadEvent {
        var params = try idParameters()

        params[.tracking] = AdmitadTrackingType.registration.rawValue
        params[.oid] = userId
        params[.channel] = channel ?? AdmitadTracker.ADM_MOBILE_CHANNEL
        
        let url = try AdmitadURL.requestURL(params: params)

        return AdmitadEvent(url: url)
    }

    static func loyaltyEvent(userId: String,
                             loyalty: Int,
                             channel: String? = nil) throws -> AdmitadEvent {
        var params = try idParameters()

        params[.tracking] = AdmitadTrackingType.loyalty.rawValue
        params[.oid] = userId
        params[.loyalty] = String(loyalty)
        params[.channel] = channel ?? AdmitadTracker.ADM_MOBILE_CHANNEL
        
        let url = try AdmitadURL.requestURL(params: params)

        return AdmitadEvent(url: url)
    }

    static func returnedEvent(userId: String,
                              day: Int,
                              channel: String? = nil) throws -> AdmitadEvent {
        var params = try idParameters()

        params[.tracking] = AdmitadTrackingType.returned.rawValue
        params[.oid] = userId
        params[.day] = String(day)
        params[.channel] = channel ?? AdmitadTracker.ADM_MOBILE_CHANNEL

        let url = try AdmitadURL.requestURL(params: params)

        return AdmitadEvent(url: url)
    }

    static func installedEvent(channel: String? = nil) throws -> AdmitadEvent {
        var params = try idParameters()
        params[.tracking] = AdmitadTrackingType.installed.rawValue
        params[.channel] = channel ?? AdmitadTracker.ADM_MOBILE_CHANNEL

        let url = try AdmitadURL.requestURL(params: params)
        
        return AdmitadEvent(url: url)
    }
    
    static func deviceinfoEvent(fingerprint: AdmitadFingerprint) throws -> AdmitadEvent {
        var params = try idParameters()
        params[.tracking] = AdmitadTrackingType.deviceinfo.rawValue
        params[.fingerprint] = fingerprint.json
        
        let url = try AdmitadURL.requestURL(params: params, apiUrl: AdmitadURL.deviceinfoTracking)
        
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
        
        let uid = AdmitadTracker.sharedInstance.uid ?? ""
        var params = AdmitadParamValuePairs()
        params[.postbackKey] = postbackKey
        params[.admitadUid] = uid
        params[.device] = getIDFA()
        params[.sdkVersion] = AdmitadTracker.sharedInstance.getSdkVersion()
        
        params[.deviceType] = AdmitadTracker.deviceType
        params[.os] = AdmitadTracker.osType
        params[.method] = AdmitadTracker.methodType
        
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
