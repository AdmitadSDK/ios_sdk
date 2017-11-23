//
//  AdmitadFootprint.swift
//  AdmitadSDK
//
//  Created by Dmitry Cherednikov on 02.10.17.
//  Copyright © 2017 tachos. All rights reserved.
//

import Foundation
import CoreTelephony
import CoreLocation

internal struct AdmitadFingerprint: Codable {
    let hardwareId: String
    let brand: String
    let model: String
    let screenDPI: Int
    let screenHeigth: Int
    let screenWidth: Int
    let network: String
    let os: String
    let osVersion: String
    let sdkVersion: String
    let firstLaunchDate: String
    let lastLaunchDate: String
    let carrier: String
    let languageCode: String
}

internal extension AdmitadFingerprint {
    init() {
        hardwareId = AdmitadFingerprint.getIdForVendor()
        brand = AdmitadFingerprint.getBrand()
        model = AdmitadFingerprint.getModel()
        screenDPI = AdmitadFingerprint.getScreenDPI()
        screenHeigth = AdmitadFingerprint.getScreenHeight()
        screenWidth = AdmitadFingerprint.getScreenHeight()
        network = AdmitadFingerprint.getNetworkConnectionState()
        os = AdmitadFingerprint.getOs()
        osVersion = AdmitadFingerprint.getOsVersion()
        sdkVersion = AdmitadFingerprint.getSdkVersion()
        firstLaunchDate = AdmitadFingerprint.getFirstLaunchDate()
        lastLaunchDate = AdmitadFingerprint.getLastLaunchDate()
        carrier = AdmitadFingerprint.getCarrier()
        languageCode = AdmitadFingerprint.getLanguageCode()
    }
}

// MARK: - JSON
internal extension AdmitadFingerprint {
    enum CodingKeys: String, CodingKey {
        case hardwareId = "hardware_id"
        case brand = "brand"
        case model = "model"
        case screenDPI = "screen_dpi"
        case screenHeigth = "screen_height"
        case screenWidth = "screen_width"
        case network = "network"
        case os = "os"
        case osVersion = "os_version"
        case sdkVersion = "sdk"
        case firstLaunchDate = "first_lunch_date"
        case lastLaunchDate = "last_launch_date"
        case carrier = "carrier"
        case languageCode = "lang_code"
    }

    var json: String {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(self)
            return String(data: jsonData, encoding: .utf8) ?? ""
        }
        catch {
            return ""
        }
    }
}

// MARK: - utilities
private extension AdmitadFingerprint {
    static func getIdForVendor() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }

    static func getBrand() -> String {
        return "Apple"
    }

    static func getModel() -> String {
        return UIDevice.current.modelName
    }

    static func getScreenDPI() -> Int {
        return UIDevice.current.pixelsPerInch
    }

    static func getScreenHeight() -> Int {
        return UIDevice.current.screenHeight
    }

    static func getScreenWidth() -> Int {
        return UIDevice.current.screenWidth
    }

    static func getNetworkConnectionState() -> String {
        let reachabilityManager = AdmitadReachabilityManager.sharedInstance
        return reachabilityManager.connectionType.rawValue
    }

    static func getOs() -> String {
        return UIDevice.current.systemName
    }

    static func getOsVersion() -> String {
        return UIDevice.current.systemVersion
    }

    static func getSdkVersion() -> String {
        return AdmitadFingerprint.getOs() + " " + String(AdmitadTracker.versionNumber)
    }

    static func getFirstLaunchDate() -> String {
        let defaults = UserDefaults.standard
        let date = defaults.object(forKey: AdmitadUserDefaultsKeys.firstLaunchDate) as? Date ?? Date()
        return String(describing: date)
    }

    static func getLastLaunchDate() -> String {
        let defaults = UserDefaults.standard
        let date = defaults.object(forKey: AdmitadUserDefaultsKeys.lastLaunchDate) as? Date ?? Date()
        return String(describing: date)
    }

    static func getCarrier() -> String {
        let networkInfo = CTTelephonyNetworkInfo()
        return networkInfo.subscriberCellularProvider?.carrierName ?? ""
    }

    static func getLanguageCode() -> String {
        return Locale.current.languageCode ?? ""
    }
}
