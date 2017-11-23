//
//  RegistrationVC.swift
//  DeeplinkSDKTest
//
//  Created by Dmitry Cherednikov on 24/10/2017.
//  Copyright © 2017 tachos. All rights reserved.
//

import Foundation
import UIKit
import AdmitadSDK

class RegistrationVC: UIViewController {
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var goToCartBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var registerButton: UIButton!

    private var admitadTracker = AdmitadTracker.sharedInstance
}

// MARK: - UIViewController lifecycle
extension RegistrationVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Registration"
        userInfoLabel.text = "Register user \(UserInfo.name)\n with id: \(UserInfo.id)"
        goToCartBarButtonItem.isEnabled = false
    }
}

// MARK: - actions
extension RegistrationVC {
    @IBAction func registerButtonPressed() {
        admitadTracker.trackRegisterEvent(userId: UserInfo.id) { [unowned self] (error) in
            if error != nil {
                return
            }
            self.goToCartBarButtonItem.isEnabled = true
            self.registerButton.isEnabled = false
        }
    }
}
