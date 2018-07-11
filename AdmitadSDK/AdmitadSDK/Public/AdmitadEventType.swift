//
//  AdmitadTrackingType.swift
//  AdmitadSDK
//
//  Created by Dmitry Cherednikov on 28.09.17.
//  Copyright © 2017 tachos. All rights reserved.
//

import Foundation

/**
 Represents type of an event and also contains additional information depending on the exact type.
 - *installed*: Installed event.
 - *confirmedPurchase*: Confirmed Purchase event type. Parametrized with tracked order.
 - *paidOrder*: Paid Order event type. Pararmetrized with tracked order.
 - *registration*: Registration event type. Parametrized with tracked order.
 - *loyalty*: Loyalty event type. Parametrized with number of app's launches.
 - *returned*: Returned event type. Parametrized with number of days since last launch.
 */
public enum AdmitadEventType {
    case installed(channel: String?)
    case confirmedPurchase(order: AdmitadOrder, channel: String?)
    case paidOrder(order: AdmitadOrder, channel: String?)
    case registration(userId: String, channel: String?)
    case loyalty(userId: String, loyalty: Int, channel: String?)
    case returned(userId: String, dayReturned: Int, channel: String?)
}

// MARK: - utility
internal extension AdmitadEventType {
    internal init?(url: URL) {
        guard let trackingString = url[AdmitadParameter.tracking.rawValue] else {
            return nil
        }
        guard let trackingType = AdmitadTrackingType(rawValue: trackingString) else {
            return nil
        }

        switch trackingType {
        case .installed:
            self.init(installedUrl: url)
        case .confirmedPurchase:
            self.init(confirmedPurchaseUrl: url)
        case .paidOrder:
            self.init(paidOrderUrl: url)
        case .registration:
            self.init(registrationUrl: url)
        case .loyalty:
            self.init(loyaltyUrl: url)
        case .returned:
            self.init(returnedUrl: url)
        }
    }

    internal func toString() -> String {
        switch self {
        case .installed:
            return toString(.installed)
        case .confirmedPurchase:
            return toString(.confirmedPurchase)
        case .paidOrder:
            return toString(.paidOrder)
        case .registration:
            return toString(.registration)
        case .loyalty:
            return toString(.loyalty)
        case .returned:
            return toString(.returned)
        }
    }

    private func toString(_ trackingType: AdmitadTrackingType) -> String {
        return trackingType.rawValue
    }
}

private extension AdmitadEventType {
    init(installedUrl url: URL) {
        let channel = url[AdmitadParameter.channel.rawValue] ?? AdmitadTracker.ADM_MOBILE_CHANNEL
        self = .installed(channel: channel)
    }

    init?(confirmedPurchaseUrl url: URL) {
        guard let order = AdmitadOrder(url: url) else {
            return nil
        }
        let channel = url[AdmitadParameter.channel.rawValue] ?? AdmitadTracker.ADM_MOBILE_CHANNEL
        self = .confirmedPurchase(order: order, channel: channel)
    }

    init?(paidOrderUrl url: URL) {
        guard let order = AdmitadOrder(url: url) else {
            return nil
        }
        let channel = url[AdmitadParameter.channel.rawValue] ?? AdmitadTracker.ADM_MOBILE_CHANNEL
        self = .paidOrder(order: order, channel: channel)
    }

    init?(registrationUrl url: URL) {
        guard let userId = url[AdmitadParameter.oid.rawValue] else {
            return nil
        }
        let channel = url[AdmitadParameter.channel.rawValue] ?? AdmitadTracker.ADM_MOBILE_CHANNEL
        self = .registration(userId: userId, channel: channel)
    }

    init?(loyaltyUrl url: URL) {
        let userId = url[AdmitadParameter.oid.rawValue] ?? ""
        guard let loyaltyString = url[AdmitadParameter.loyalty.rawValue] else {
            return nil
        }
        guard let loyalty = Int(loyaltyString) else {
            return nil
        }
        let channel = url[AdmitadParameter.channel.rawValue] ?? AdmitadTracker.ADM_MOBILE_CHANNEL
        self = .loyalty(userId: userId, loyalty: loyalty, channel: channel)
    }

    init?(returnedUrl url: URL) {
        let userId = url[AdmitadParameter.oid.rawValue] ?? ""
        guard let dayString = url[AdmitadParameter.day.rawValue] else {
            return nil
        }
        guard let day = Int(dayString) else {
            return nil
        }
        let channel = url[AdmitadParameter.channel.rawValue] ?? AdmitadTracker.ADM_MOBILE_CHANNEL
        self = .returned(userId: userId, dayReturned: day, channel: channel)
    }
}
