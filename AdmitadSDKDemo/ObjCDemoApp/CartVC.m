//
//  ViewController.m
//  fff
//
//  Created by Dmitry Cherednikov on 08/11/2017.
//  Copyright © 2017 Tachos. All rights reserved.
//

#import "CartVC.h"
#import "AppDelegate.h"

@import AdmitadSDK;


typedef NS_ENUM(NSInteger, CartActionType) {
    CartActionTypeConfirm,
    CartActionTypePay,
    CartActionTypeNone
};

@interface CartVC () <UITableViewDataSource> {

    IBOutlet __weak UIBarButtonItem *rightNavigationBarItem;
    IBOutlet __weak UITableView *tableView;
    IBOutlet __weak UIActivityIndicatorView *spinner;

    CartActionType currentAction;
    NSString *currencyCode;

    AdmitadTracker *admitadTracker;

    NSArray<AdmitadOrderItem *> *items;
    NSArray<NSNumber *> *prices;
}

@end

@implementation CartVC

// MARK:- UIViewController Life Cycle 
- (void)viewDidLoad {

    [super viewDidLoad];

    currentAction = CartActionTypeConfirm;
    currencyCode = @"RUB";
    admitadTracker = [AdmitadTracker sharedInstance];

    tableView.dataSource = self;
    self.title = @"Cart";

    [self initItemsAndPrices];
}

- (void)initItemsAndPrices {

    AdmitadOrderItem *item1 = [[AdmitadOrderItem alloc] initWithName:@"Phone"
                                                            quantity:1];
    AdmitadOrderItem *item2 = [[AdmitadOrderItem alloc] initWithName:@"Phone Charger"
                                                            quantity:3];
    AdmitadOrderItem *item3 = [[AdmitadOrderItem alloc] initWithName:@"TV"
                                                            quantity:2];
    AdmitadOrderItem *item4 = [[AdmitadOrderItem alloc] initWithName:@"USB Flash Drive"
                                                            quantity:2];

    items = @[item1, item2, item3, item4];
    prices = @[@3000, @200, @45000, @800];
}

// MARK:- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString * reuseId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:reuseId];
    }

    AdmitadOrderItem *item = items[indexPath.row];

    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = [self detailTextForRow: indexPath.row];

    return cell;
}

// MARK:- Action
- (IBAction)rightNavigationBarItemPressed {

    switch (currentAction) {
        case CartActionTypeConfirm:
            [self trackConfirmedPurchaseEvent];
            break;
        case CartActionTypePay:
            [self trackPaidOrderEvent];
            break;
        case CartActionTypeNone:
            break;
    }
}

// MARK:- Events Tracking
- (void)trackConfirmedPurchaseEvent {

    [spinner startAnimating];

    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [admitadTracker trackConfirmedPurchaseEventWithOrder:[self buildOrder] channel:nil completion:^(AdmitadError *error) {

        [spinner stopAnimating];
        if (!error) {

            currentAction = CartActionTypePay;
            rightNavigationBarItem.title = @"Pay";
            [appDelegate showAlertWithMessage:@"Confirmed Purchase event is successfully tracked"];
        }
        else {

            [appDelegate showAlertWithMessage:@"Error tracking Confirmed Purchase event"];
        }
    }];
}

- (void)trackPaidOrderEvent {

    [spinner startAnimating];

    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [admitadTracker trackPaidOrderEventWithOrder:[self buildOrder] channel:nil completion:^(AdmitadError *error) {

        [spinner stopAnimating];
        if (!error) {

            currentAction = CartActionTypeNone;
            rightNavigationBarItem.enabled = NO;
            [appDelegate showAlertWithMessage:@"Paid Order event is successfully tracked"];
        }
        else {

            [appDelegate showAlertWithMessage:@"Error tracking Paid Order event"];
        }
    }];
}

// MARK:- Utils
- (NSString *)detailTextForRow: (NSInteger)row {

    AdmitadOrderItem *item = items[row];
    NSString *priceString = [NSString stringWithFormat:@"%.0f", prices[row].floatValue];

    return [NSString stringWithFormat:@"%d x %@ %@",
            (int)item.quantity, priceString,
            currencyCode];
}

- (AdmitadOrder *)buildOrder {

    NSDictionary<NSString *, NSString *> *userInfo = @{@"country": @"Russia",
                                                       @"payment_method": @"PayPal"};

    return [[AdmitadOrder alloc] initWithId:@"123456789"
                                 totalPrice:[self orderPrice]
                                 currencyCode:currencyCode
                                 items:items
                                 userInfo:userInfo
                                 tarifCode:@"1"
                                 promocode:@""
                                ];
}

- (NSString *)orderPrice {
    CGFloat sum = 0.f;
    for (NSInteger i = 0; i < 4; ++i) {

        sum += items[i].quantity * prices[i].floatValue;
    }

    return [NSString stringWithFormat: @"%f", sum];
}

@end
