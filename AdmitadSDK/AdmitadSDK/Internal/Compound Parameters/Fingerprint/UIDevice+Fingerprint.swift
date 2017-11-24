//
//  UIDevice+Fingerprint.swift
//  AdmitadSDK
//
//  Created by Dmitry Cherednikov on 23/10/2017.
//  Copyright © 2017 tachos. All rights reserved.
//

import Foundation
import UIKit

internal extension UIDevice {
    var modelName: String {
        switch modelId {
        // MARK: iPod
        case "iPod5,1":
            return "iPod Touch 5"
        case "iPod7,1":
            return "iPod Touch 6"

        // MARK: iPhone 4
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":
            return "iPhone 4"
        case "iPhone4,1":
            return "iPhone 4s"

        // MARK: iPhone 5
        case "iPhone5,1", "iPhone5,2":
            return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":
            return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":
            return "iPhone 5s"

        // MARK: iPhone 6
        case "iPhone7,2":
            return "iPhone 6"
        case "iPhone7,1":
            return "iPhone 6 Plus"
        case "iPhone8,1":
            return "iPhone 6s"
        case "iPhone8,2":
            return "iPhone 6s Plus"

        // MARK: iPhone 7
        case "iPhone9,1", "iPhone9,3":
            return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":
            return "iPhone 7 Plus"

        // MARK: iPhone 8
        case "iPhone8,4":
            return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":
            return "iPhone 8"

        // MARK: iPhone X
        case "iPhone10,2", "iPhone10,5":
            return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":
            return "iPhone X"

        // MARK: iPad
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
            return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":
            return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":
            return "iPad 4"
        case "iPad6,11", "iPad6,12":
            return "iPad 5"

        // MARK: iPad Air
        case "iPad4,1", "iPad4,2", "iPad4,3":
            return "iPad Air"
        case "iPad5,3", "iPad5,4":
            return "iPad Air 2"

        // MARK: iPad Mini
        case "iPad2,5", "iPad2,6", "iPad2,7":
            return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":
            return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":
            return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":
            return "iPad Mini 4"

        // MARK: iPad Pro
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":
            return "iPad Pro"
        case "iPad7,1", "iPad7,2", "iPad7,3", "iPad7,4":
            return "iPad Pro 2"

        // MARK: AppleTV
        case "AppleTV5,3", "AppleTV6,2":
            return "Apple TV"

        // MARK: Simulator
        case "i386", "x86_64":
            return "Simulator"

        default:
            return modelId
        }
    }

    // The switch-case expression is taken from https://github.com/marchv/UIScreenExtension/blob/master/UIScreenExtension/UIScreenExtension.swift
    var pixelsPerInch: Int {
        switch modelId {
        case "iPhone4,1":
        fallthrough // iPhone 4S
        case "iPhone5,1", "iPhone5,2":
        fallthrough // iPhone 5
        case "iPhone5,3", "iPhone5,4":
        fallthrough // iPhone 5C
        case "iPhone6,1", "iPhone6,2":
        fallthrough // iPhone 5S
        case "iPhone8,4":
        fallthrough // iPhone SE
        case "iPhone7,2":
        fallthrough // iPhone 6
        case "iPhone8,1":
        fallthrough // iPhone 6S
        case "iPhone9,1", "iPhone9,3":
        fallthrough // iPhone 7
        case "iPhone10,1", "iPhone10,4":
        fallthrough // iPhone 8
        case "iPod5,1":
        fallthrough // iPod Touch 5th generation
        case "iPod7,1":
        fallthrough // iPod Touch 6th generation
        case "iPad2,5", "iPad2,6", "iPad2,7":
        fallthrough // iPad Mini
        case "iPad4,4", "iPad4,5", "iPad4,6":
        fallthrough // iPad Mini 2
        case "iPad4,7", "iPad4,8", "iPad4,9":
        fallthrough // iPad Mini 3
        case "iPad5,1", "iPad5,2": // iPad Mini 4
            return 326

        case "iPhone7,1":
        fallthrough // iPhone 6 Plus
        case "iPhone8,2":
        fallthrough // iPhone 6S Plus
        case "iPhone9,2", "iPhone9,4":
        fallthrough // iPhone 7 Plus
        case "iPhone10,2", "iPhone10,5": // iPhone 8 Plus
            return 401

        case "iPhone10,3", "iPhone10,6": // iPhone X
            return 458

        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
        fallthrough // iPad 2
        case "iPad3,1", "iPad3,2", "iPad3,3":
        fallthrough // iPad 3rd generation
        case "iPad3,4", "iPad3,5", "iPad3,6":
        fallthrough // iPad 4th generation
        case "iPad4,1", "iPad4,2", "iPad4,3":
        fallthrough // iPad Air
        case "iPad5,3", "iPad5,4":
        fallthrough // iPad Air 2
        case "iPad6,7", "iPad6,8":
        fallthrough // iPad Pro (12.9 inch)
        case "iPad6,3", "iPad6,4":
        fallthrough // iPad Pro (9.7 inch)
        case "iPad6,11", "iPad6,12":
        fallthrough // iPad 5th generation
        case "iPad7,1", "iPad7,2":
        fallthrough // iPad Pro (12.9 inch, 2nd generation)
        case "iPad7,3", "iPad7,4":
            // iPad Pro (10.5 inch)
            return 264

        default:
            // unknown model identifier
            return 0
        }
    }

    var screenHeight: Int {
        let rect = UIScreen.main.bounds
        return (rect.height > rect.width) ? Int(rect.height) : Int(rect.width)
    }

    var screenWidth: Int {
        let rect = UIScreen.main.bounds
        return (rect.width > rect.height) ? Int(rect.height) : Int(rect.width)
    }
}

private extension UIDevice {
    var modelId: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
