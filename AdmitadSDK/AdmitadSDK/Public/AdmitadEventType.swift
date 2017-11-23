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
    case installed
    case confirmedPurchase(order: AdmitadOrder)
    case paidOrder(order: AdmitadOrder)
    case registration(userId: String)
    case loyalty(userId: String, loyalty: Int)
    case returned(userId: String, dayReturned: Int)
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
    init(installedUrl: URL) {
        self = .installed
    }

    init?(confirmedPurchaseUrl url: URL) {
        guard let order = AdmitadOrder(url: url) else {
            return nil
        }
        self = .confirmedPurchase(order: order)
    }

    init?(paidOrderUrl url: URL) {
        guard let order = AdmitadOrder(url: url) else {
            return nil
        }
        self = .paidOrder(order: order)
    }

    init?(registrationUrl url: URL) {
        guard let userId = url[AdmitadParameter.oid.rawValue] else {
            return nil
        }
        self = .registration(userId: userId)
    }

    init?(loyaltyUrl url: URL) {
        let userId = url[AdmitadParameter.oid.rawValue] ?? ""
        guard let loyaltyString = url[AdmitadParameter.loyalty.rawValue] else {
            return nil
        }
        guard let loyalty = Int(loyaltyString) else {
            return nil
        }
        self = .loyalty(userId: userId, loyalty: loyalty)
    }

    init?(returnedUrl url: URL) {
        let userId = url[AdmitadParameter.oid.rawValue] ?? ""
        guard let dayString = url[AdmitadParameter.day.rawValue] else {
            return nil
        }
        guard let day = Int(dayString) else {
            return nil
        }
        self = .returned(userId: userId, dayReturned: day)
    }
}
