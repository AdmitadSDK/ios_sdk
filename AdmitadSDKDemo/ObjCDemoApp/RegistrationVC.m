//
//  RegistrationVC.m
//  fff
//
//  Created by Dmitry Cherednikov on 08/11/2017.
//  Copyright © 2017 Tachos. All rights reserved.
//

#import "RegistrationVC.h"
#import "AppDelegate.h"
#import "UserInfo.h"

@import AdmitadSDK;

@interface RegistrationVC () {

    IBOutlet __weak UILabel *userInfoLabel;
    IBOutlet __weak UIBarButtonItem *goToCartBarButtonItem;
    IBOutlet __weak UIButton *registerButton;

    AdmitadTracker *admitadTracker;
}

@end

@implementation RegistrationVC

- (void)viewDidLoad {

    [super viewDidLoad];

    admitadTracker = [AdmitadTracker sharedInstance];

    self.title = @"Registration";
    userInfoLabel.text = [NSString stringWithFormat:@"Register user %@\n with id: %@", [UserInfo userName], [UserInfo userId]];

    goToCartBarButtonItem.enabled = NO;
}

- (IBAction)registerButtonPressed {

    [admitadTracker trackRegisterEventWithUserId:[UserInfo userId] completion:^(AdmitadError *error) {

        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

        if (!error) {

            goToCartBarButtonItem.enabled = YES;
            registerButton.enabled = NO;
            [appDelegate showAlertWithMessage: @"Register event is successfully tracked"];
        }
        else {

            [appDelegate showAlertWithMessage: @"Error tracking Register event"];
        }
    }];
}

@end
