//
//  AdmitadReachabilityManager.swift
//  AdmitadSDK
//
//  Created by Dmitry Cherednikov on 04.10.17.
//  Copyright © 2017 tachos. All rights reserved.
//

import Foundation
import Alamofire

internal class AdmitadReachabilityManager {
    // MARK: - API
    internal private(set) var reachability: AdmitadReachability = .notReachable {
		didSet {
			if reachability != oldValue {
				listener?.reachabilityChanged(reachability)
			}
		}
    }
    internal private(set) var connectionType = AdmitadConnectionType.undefined

    internal weak var listener: AdmitadReachabilityManagerListener?

    // MARK: - private
    private let manager: NetworkReachabilityManager?

    // MARK: - lifecycle
    internal static let sharedInstance = AdmitadReachabilityManager()

    private init() {
        self.manager = NetworkReachabilityManager()
        if self.manager == nil {
            reachability = .reachable
        }
    }

    deinit {
        manager?.stopListening()
    }
}

// MARK: - implementation
internal extension AdmitadReachabilityManager {
    func startListening() {
        manager?.listener = { [weak self] status in
            guard let strongSelf = self else {
                return
            }

            switch status {
            case .reachable(let connection):
                strongSelf.reachability = .reachable
                self?.connectionType = (connection == .ethernetOrWiFi) ? .ethernetOrWiFi : .wwan

            case .unknown:
                strongSelf.reachability = .notReachable
                self?.connectionType = .undefined

            case .notReachable:
                strongSelf.reachability = .notReachable
                self?.connectionType = .undefined
            }
        }
        manager?.startListening()
    }

    func stopListening() {
        manager?.stopListening()
    }
}
