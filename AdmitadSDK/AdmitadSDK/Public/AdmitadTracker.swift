//
//  AdmitadTracker.swift
//  AdmitadSDK
//
//  Created by Dmitry Cherednikov on 28.09.17.
//  Copyright © 2017 tachos. All rights reserved.
//

import Foundation


/**
 A completion that can be passed to one of AdmitadTracker's events related methods to check if tracking is successful.
 */
public typealias AdmitadCompletion = (AdmitadError?) -> Void


/**
 A class that incapsulates all interaction with Admitad server.
 Designed to be used as singleton object.
 To make interaction possible,
 please provide Admitad's *Postback Key* via setting *postbackKey* property.
 The most of the events are only tracked when *Admitad Uid* is provided.
 AdmitadTracker retrieves *Admitad Uid* from
 [NSUserActivity](https://developer.apple.com/documentation/foundation/nsuseractivity) object
 passed as parameter in
 continueUseActivity(_:) method.
 If you use Custom URL Schemes call openUrl(_:) method.
 To track an event just call a correspondingly named method.
 To track if the event sending was successful,
 pass a completion as a parameter,
 or set up a delegete object conforming to AdmitadDelegate protocol.
 You're free to combine both approaches.
 */
public class AdmitadTracker: NSObject {
    /**
     AdmitadSDK's version number.
     */
    @objc public static let versionNumber = 1.0
    /**
     Property through which the singleton instance is accessed.
     */
    @objc public static let sharedInstance = AdmitadTracker()
    /**
     Admitad's postback_key.
     */
    @objc public var postbackKey: String?
    /**
     Bool property defining if the Tracker logs debugging info into console.
     */
    @objc public var loggingEnabled: Bool = false
    /**
     Parameter used for Returned and Loyalty events.
     When not provided, SDK generates userId automatically.
     */
    @objc public var userId: String?
    /**
     Optional delegate object that is notified on tracking events.
     */
    public weak var delegate: AdmitadDelegate?
    
    // order attributed to admitad sdk
    @objc public static let ADM_MOBILE_CHANNEL = "adm_mobile";
    // order with unknown attribution
    @objc public static let UNKNOWN_CHANNEL = "na";

    // MARK: - internal
    internal private(set) var uid: String?

    // MARK: - private
    private var service = AdmitadService()
    private var dayReturned = 0
    private var loyalty = 0

    private override init() {}
}

// MARK: - launching and deep-linking
public extension AdmitadTracker {
    /**
     Should be called in AppDelegate's
     application(_:didFinishLaunchingWithOptions:) method.
     - parameter channel: Deduplication parameter for attribution of the install event
     */
    @objc public func trackAppLaunch(channel: String? = nil) {
        if isFirstLaunch() {
            saveFirstLaunchDate()
            trackInstallationEvent(channel: channel)
        }
        dayReturned = updateAndGetDayReturned()
        loyalty = updateAndGetLaunchCount()

        uid = restoredUid()
    }

    /**
     Should be called in [application(_ :continue:restorationHandler:)](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623072-application?language=swift) method.
     */
    @objc public func continueUserActivity(_ userActivity: NSUserActivity) {
        uid = userActivity.webpageURL?[AdmitadParameter.admitadUid.rawValue]
        guard let uid = uid else {
            return
        }
        saveUid(uid)
    }

    /**
     Should be called in [application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623112-application) method
     */
    @objc public func openUrl(_ url: URL) {
        uid = url[AdmitadParameter.admitadUid.rawValue]
        guard let uid = uid else {
            return
        }
        saveUid(uid)
    }
}

// MARK: - public events
public extension AdmitadTracker {
    /**
     Tracks *Confirmed Purchase* event.
     - parameter order: Tracked order.
     - parameter channel: Deduplication parameter for attribution
     - parameter completion: Completion to define if event tracking was successfull.
     */
    @objc public func trackConfirmedPurchaseEvent(order: AdmitadOrder,
                                                  channel: String? = nil,
                                                  completion: AdmitadCompletion? = nil) {
        do {
            let event = try AdmitadEvent.confirmedPurchaseEvent(order: order, channel: channel)
            handleToService(event: event, completion: completion)
        }
        catch {
            delegate?.finishedTrackingAdmitadEvent(nil,
                                                   error: error as? AdmitadError)
            completion?(error as? AdmitadError)
        }
    }

    /**
     Tracks *Paid Order* event.
     - parameter order: Tracked order.
     - parameter channel: Deduplication parameter for attribution
     - parameter completion: Completion to define if event tracking was successfull
     */
    @objc public func trackPaidOrderEvent(order: AdmitadOrder,
                                          channel: String? = nil,
                                          completion: AdmitadCompletion? = nil) {
        do {
            let event = try AdmitadEvent.paidOrderEvent(order: order, channel: channel)
            handleToService(event: event, completion: completion)
        }
        catch {
            delegate?.finishedTrackingAdmitadEvent(nil,
                                                   error: error as? AdmitadError)
            completion?(error as? AdmitadError)
        }
    }

    /**
     Track *Register* event.
     - parameter userId: Id of user in your system
     - parameter channel: Deduplication parameter for attribution
     - parameter completion: Completion to define if event tracking was successfull
     */
    @objc public func trackRegisterEvent(userId passedUserId: String? = nil,
                                         channel: String? = nil,
                                         completion: AdmitadCompletion? = nil) {
        let userIdValue = passedUserId ?? getUserIdOrGenerate()
        do {
            let event = try AdmitadEvent.registerEvent(userId: userIdValue, channel: channel)
            handleToService(event: event, completion: completion)
        }
        catch {
            delegate?.finishedTrackingAdmitadEvent(nil,
                                                   error: error as? AdmitadError)
            completion?(error as? AdmitadError)
        }
    }

    /**
     Tracks *Loyalty* event.
     - parameter userId: Id of user in your system
     - parameter channel: Deduplication parameter for attribution
     - parameter completion: Completion to define if event tracking was successfull
     */
    @objc public func trackLoyaltyEvent(userId passedUserId: String? = nil,
                                        channel: String? = nil,
                                        completion: AdmitadCompletion? = nil) {
        let userIdValue = passedUserId ?? getUserIdOrGenerate()
        do {
            let event = try AdmitadEvent.loyaltyEvent(userId: userIdValue,
                                                      loyalty: loyalty,
                                                      channel: channel)
            handleToService(event: event, completion: completion)
        }
        catch {
            delegate?.finishedTrackingAdmitadEvent(nil,
                                                   error: error as? AdmitadError)
            completion?(error as? AdmitadError)
        }
    }

    /**
     Tracks *Returned* event.
     - parameter userId: Id of user in your system
     - parameter channel: Deduplication parameter for attribution
     - parameter completion: Completion to define if event tracking was successfull
     */
    @objc public func trackReturnedEvent(userId passedUserId: String? = nil,
                                         channel: String? = nil,
                                         completion: AdmitadCompletion? = nil) {
        let userIdValue = passedUserId ?? getUserIdOrGenerate()
        do {
            let event = try AdmitadEvent.returnedEvent(userId: userIdValue,
                                                   day: dayReturned,
                                                   channel: channel)
            handleToService(event: event, completion: completion)
        }
        catch {
            delegate?.finishedTrackingAdmitadEvent(nil,
                                                   error: error as? AdmitadError)
            completion?(error as? AdmitadError)
        }
    }
    
    /**
     Return currently stored Admitad uid.
     - returns: String with uid
     */
    @objc public func getUid() -> String {
        return uid ?? "";
    }
}

// MARK: - private events
private extension AdmitadTracker {
    func trackInstallationEvent(channel: String? = nil) {
        let fingerprint = AdmitadFingerprint()
        do {
            let event = try AdmitadEvent.installedEvent(fingerprint: fingerprint, channel: channel)
            handleToService(event: event)
        }
        catch {
            // do nothing
        }

        saveFirstLaunch()
    }

    func handleToService(event: AdmitadEvent,
                         completion: AdmitadCompletion? = nil) {
        service.sendRequest(request: AdmitadRequest(event: event),
                            completion: completion)
    }
}

// MARK: - UserDefaults
private extension AdmitadTracker {
    func isFirstLaunch() -> Bool {
        let defaults = UserDefaults.standard
        return !defaults.bool(forKey: AdmitadUserDefaultsKeys.hasTrackedLaunch)
    }

    func saveFirstLaunch() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: AdmitadUserDefaultsKeys.hasTrackedLaunch)
    }

    func restoredUid() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: AdmitadUserDefaultsKeys.admitadUid)
    }

    func saveUid(_ uidToSave: String) {
        let defaults = UserDefaults.standard
        defaults.set(uidToSave, forKey: AdmitadUserDefaultsKeys.admitadUid)
    }

    func saveFirstLaunchDate() {
        let defaults = UserDefaults.standard
        defaults.set(Date(), forKey: AdmitadUserDefaultsKeys.firstLaunchDate)
    }

    func saveLastLaunchDate() {
        let defaults = UserDefaults.standard
        defaults.set(Date(), forKey: AdmitadUserDefaultsKeys.lastLaunchDate)
    }

    func saveLaunchCount(count: Int) {
        let defaults = UserDefaults.standard
        defaults.set(count, forKey: AdmitadUserDefaultsKeys.launchCount)
    }
}

// MARK: utilities
private extension AdmitadTracker {
    func updateAndGetLaunchCount() -> Int {
        let launchCountKey = AdmitadUserDefaultsKeys.launchCount

        var launchCount = UserDefaults.standard.integer(forKey: launchCountKey)

        if launchCount == 0 {
            UserDefaults.standard.set(1, forKey: launchCountKey)
            return 1
        }

        launchCount += 1
        saveLaunchCount(count: launchCount)

        return launchCount
    }

    func updateAndGetDayReturned() -> Int {
        let lastLaunchKey = AdmitadUserDefaultsKeys.lastLaunchDate

        let currentLaunch = Date()

        guard let lastLaunch = UserDefaults.standard.object(forKey: lastLaunchKey) as? Date else {
            UserDefaults.standard.set(currentLaunch,
                                      forKey: lastLaunchKey)
            return 0
        }

        saveLastLaunchDate()

        return dayDifference(lastLaunch: lastLaunch,
                             currentLaunch: currentLaunch)
    }

    func dayDifference(lastLaunch: Date, currentLaunch: Date) -> Int {
        let calendar  = Calendar.current
        let start = calendar.ordinality(of: Calendar.Component.day,
                                        in: .era,
                                        for: lastLaunch) ?? 0
        let end = calendar.ordinality(of: Calendar.Component.day,
                                      in: .era,
                                      for: currentLaunch) ?? 0
        return end - start
    }
}

// MARK: - identifiers
private extension AdmitadTracker {
    func getUUID() -> String {
        return UUID().uuidString
    }

    func getUserIdOrGenerate() -> String {
        return userId ?? getUUID()
    }
}
