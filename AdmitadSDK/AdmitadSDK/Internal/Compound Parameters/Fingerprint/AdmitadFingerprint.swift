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
import UIKit

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
    let batteryLevel: Float
    let batteryState: String
}

internal extension AdmitadFingerprint {
    init() {
        hardwareId = AdmitadFingerprint.getIdForVendor()
        brand = AdmitadFingerprint.getBrand()
        model = AdmitadFingerprint.getModel()
        screenDPI = AdmitadFingerprint.getScreenDPI()
        screenHeigth = AdmitadFingerprint.getScreenHeight()
        screenWidth = AdmitadFingerprint.getScreenWidth()
        network = AdmitadFingerprint.getNetworkConnectionState()
        os = AdmitadFingerprint.getOs()
        osVersion = AdmitadFingerprint.getOsVersion()
        sdkVersion = AdmitadFingerprint.getSdkVersion()
        firstLaunchDate = AdmitadFingerprint.getFirstLaunchDate()
        lastLaunchDate = AdmitadFingerprint.getLastLaunchDate()
        carrier = AdmitadFingerprint.getCarrier()
        languageCode = AdmitadFingerprint.getLanguageCode()
        batteryLevel = AdmitadFingerprint.getBatteryLevel()
        batteryState = AdmitadFingerprint.getBatteryState()
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
        case batteryLevel = "battery_level"
        case batteryState = "battery_state"
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
        return AdmitadTracker.sharedInstance.getSdkVersion()
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
    
    static func getBatteryLevel() -> Float {
        let batteryMonitoringEnabled = UIDevice.current.isBatteryMonitoringEnabled;
        if (!batteryMonitoringEnabled) {
            UIDevice.current.isBatteryMonitoringEnabled = true
        }
        // return monitoring to previous state when finished
        defer {
            if (!batteryMonitoringEnabled) {
                UIDevice.current.isBatteryMonitoringEnabled = false
            }
        }
        
        return UIDevice.current.batteryLevel
    }
    
    static func getBatteryState() -> String {
        let batteryMonitoringEnabled = UIDevice.current.isBatteryMonitoringEnabled;
        if (!batteryMonitoringEnabled) {
            UIDevice.current.isBatteryMonitoringEnabled = true
        }
        // return monitoring to previous state when finished
        defer {
            if (!batteryMonitoringEnabled) {
                UIDevice.current.isBatteryMonitoringEnabled = false
            }
        }
        
        switch UIDevice.current.batteryState {
        case .unknown:
            return "unknown"
        case .unplugged:
            return "unplugged"
        case .charging:
            return "charging"
        case .full:
            return "full"
        }
    }
}
