//
//  AppDelegate.swift
//  DeeplinkSDKTest
//
//  Created by Dmitry Cherednikov on 26.09.17.
//  Copyright © 2017 tachos. All rights reserved.
//

import UIKit
import AdmitadSDK

struct UserInfo {
    static let id = "1234567890"
    static let name = "Tony Stark"
}

private let postbackKey = "PASTE_YOUR_KEY_HERE"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AdmitadDelegate {

    var window: UIWindow?

    let admitadTracker = AdmitadTracker.sharedInstance

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // setup AdmitadTracker
        admitadTracker.postbackKey = postbackKey
        admitadTracker.userId = UserInfo.id
        admitadTracker.loggingEnabled = true
        admitadTracker.delegate = self

        // track application launch
        admitadTracker.trackAppLaunch()

        // track 'loyalty' and 'returned' events
        admitadTracker.trackReturnedEvent()
        admitadTracker.trackLoyaltyEvent()
        
        print("Current UID: \(admitadTracker.getUid())");
        
        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        admitadTracker.continueUserActivity(userActivity)
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        admitadTracker.openUrl(url)
        return true
    }
}

// MARK: AdmitadDelegate
extension AppDelegate {
    func startedTrackingAdmitadEvent(_ event: AdmitadEvent) {}

    func finishedTrackingAdmitadEvent(_ event: AdmitadEvent?, error: AdmitadError?) {
        if error == nil {
            showAlert("Successfully tracked event: \(event!.type)")
        }
        else if event != nil {
            showAlert("Event tracking failed: \(event!.type)")
        }
        else {
            showAlert("Event tracking failed")
        }
    }
}

// MARK: - alerts
extension AppDelegate {
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: nil,
                                      message: message,
                                      preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK",
                                     style: .cancel,
                                     handler: nil)
        alert.addAction(okAction)

        window?.rootViewController?.present(alert,
                                            animated: true,
                                            completion: nil)
    }
}
