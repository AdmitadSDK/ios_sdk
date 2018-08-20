//
//  AppDelegate.m
//  fff
//
//  Created by Dmitry Cherednikov on 08/11/2017.
//  Copyright © 2017 Tachos. All rights reserved.
//

#import "AppDelegate.h"
#import "UserInfo.h"

@import AdmitadSDK;

@interface AppDelegate () {

    AdmitadTracker *tracker;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    tracker = [AdmitadTracker sharedInstance];
    
    tracker.postbackKey = @"123";
    tracker.loggingEnabled = YES;
    tracker.userId = [UserInfo userId];

    [tracker trackAppLaunch];

    [tracker trackReturnedEventWithUserId:nil channel:nil completion:^(AdmitadError *error) {

        if (!error) {

            [self showAlertWithMessage: @"Returned event is successfully tracked"];
        }
        else {

            [self showAlertWithMessage:@"Error tracking Returned event"];
        }
    }];

    [tracker trackLoyaltyEventWithUserId:nil channel:nil completion:^(AdmitadError *error) {

        if (!error) {

            [self showAlertWithMessage: @"Loyalty event is successfully tracked"];
        }
        else {

            [self showAlertWithMessage:@"Error tracking Loyalty event"];
        }
    }];
    
    NSString* uid = [tracker getUid];
    NSLog(@"Current uid: %@", uid);

    return YES;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {

    [tracker openUrl:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {

    [tracker continueUserActivity:userActivity];
    return YES;
}

- (void)showAlertWithMessage: (NSString *)message {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];
    [alert addAction: okAction];
    [_window.rootViewController presentViewController:alert
                                             animated:YES
                                           completion:nil];
}

@end
