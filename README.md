# Admitad SDK for iOS
iOS integration SDK of https://www.admitad.com/

Admitad help center: https://help.admitad.com/en/advertiser/topic/195-mobile-sdk/

## Table of contents


* [Setting your project](#setting-your-project)
* [Manual Installation](#manual-installation)
* [Installation via CocoaPods](#installation-via-cocoapods)
* [Alamofire version](#alamofire-version)
* [Objective-C interoperability](#objective-c-interoperability)
* [Setting AppDelegate](#setting-appdelegate)
* [Event Tracking](#event-tracking)
    * [User Id](#user-id)
    * [Register](#register)
    * [Returned](#returned)
    * [Loyalty](#loyalty)
    * [Order](#order)
      * [Additional parameters](#additional-parameters)
      * [Confirmed Purchase](#confirmed-purchase)
      * [Paid Order](#paid-order)
* [Delegation and Callbacks](#delegation-and-callbacks)
* [License](#license)


## <a id="setting_your_project"></a>Setting your project

Make sure that your project's deployment target is iOS 9.0 or higher.

Your project should be set up to make interaction with URL Schemes and Universal Links possible.
**Note**: you also should test on a real device because deeplinking doesn't work on simulator and therefore most of *AdmitadSDK* functionality won't be available.

To add *AdmitadSDK* to your project you have two options:
1. Manual Installation
2. Installation via CocoaPods

### <a id="manual-installation"></a>Manual Installation

*AdmitadSDK* makes use of *Alamofire* framework. In order to use AdmitadSDK please add Alamofire to your project.
The link below contains fully descriptive manual on Alamofire installation process:
[Alamofire GitHub Page](https://github.com/Alamofire/Alamofire)

To add *AdmitadSDK* itself please follow these steps:
1. Clone this repository or download zip-file.
2. Locate *RepoName/AdmitadSDK/AdmitadSDK* folder. This folder should contain two subfolders:  *Internal* and *Public*.
![Locating AdmitadSDK Directory](https://raw.githubusercontent.com/AdmitadSDK/ios_sdk/master/images/Directory.png)
3. Copy and paste the *AdmitadSDK* folder to some directory inside your project's directory.
4. Drag and drop the *AdmitadSDK* folder to Project Navigator in Xcode. Make sure that your target is checked in prompt.
![Drag and Drop](https://raw.githubusercontent.com/AdmitadSDK/ios_sdk/master/images/Drag.png)
![Checking Target](https://raw.githubusercontent.com/AdmitadSDK/ios_sdk/master/images/Target.png)
5. Build the project.

### <a id="installation-via-cocoapods"></a>Installation via CocoaPods

If you have CocoaPods installed (installation process is described [here](https://guides.cocoapods.org/using/getting-started.html)) do the following:

1. `cd` to the directory where your project is located.
2. run `pod init` in Terminal. A *Podfile* will be created.
3. Modify the *Podfile* to look like this:  
    ```ruby
    platform :ios, '9.0'
    use_frameworks!

    target '<Your Target>' do
    pod 'AdmitadSDK'
    end
    ```
4. Run `pod install`. A *.xcworkspace* will be created.
5. Close your project (if opened) and open the *.xcworkspace*.
6. If you've run into some issues installing *AdmitadSDK* via CocoaPods, try running `pod update` in Terminal.

## <a id="alamofire-version"></a>Alamofire version

*AdmitadSDK* uses version 4.x of *Alamofire* as a dependency. So if you use *Alamofire* in your project, it's major release number should be 4. You're free to specify any minor release number for your needs.

## <a id="objective-c-interoperability"></a>Objective-C interoperability

Just add `@import AdmitadSDK;` import statement to the source files that make use of *AdmitadSDK*.

## <a id="setting-appdelegate"></a>Setting AppDelegate
1. Get a Singleton AdmitadTracker Instance.  
All sdk methods require an instance of the main AdmitadTracker object. Here's how you can get one. It's stored statically and is accessible from any class.

    Swift:
    ```Swift
    let admitadTracker = AdmitadTracker.sharedInstance
    ```
    Objective-C:
    ```Objective-C
    AdmitadTracker *admitadTracker;
    ```


2. In `application(_:didFinishLaunchingWithOptions:)` method assign *AdmitadTracker* singleton's `postbackKey` property to your Admitad Postback Key.
3. In the same method call *AdmitadTracker*'s `trackAppLaunch()`, `trackReturnedEvent()` и `trackLoyaltyEvent()`.

    Swift:
    ```Swift
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    admitadTracker.postbackKey = "postbackKey"

    admitadTracker.trackAppLaunch()
    admitadTracker.trackReturnedEvent()
    admitadTracker.trackLoyaltyEvent()

    return true
    }
    ```
    Objective-C:
    ```Objective-C
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    admitadTracker = [AdmitadTracker sharedInstance];

    admitadTracker.postbackKey = @"postbackKey";

    [admitadTracker trackAppLaunch];
    [admitadTracker trackReturnedEventWithUserId:nil completion:nil];
    [admitadTracker trackLoyaltyEventWithUserId:nil completion:nil];

    return YES;
    }

    ```
4. To track Universal Links usage, in `application(_:continue:restorationHandler:)` call corresondingly named `continueUserActivity` method and pass `userActivity` to it as parameter.

    Swift:
    ```Swift
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
    admitadTracker.continueUserActivity(userActivity)
    return true
    }
    ```
    Objective-C:
    ```Objective-C
    - (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {

    [admitadTracker continueUserActivity:userActivity];
    return YES;
    }
    ```    
5. To track URL Schemes usage, in `application(_:open:options:)` call `openUrl` method and pass `url` to it as parameter.

    Swift:
    ```Swift
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    admitadTracker.openUrl(url)
    return true
    }
    ```
    Objective-C:
    ```Objective-C
    - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {

    [tracker openUrl:url];
    return YES;
    }
    ```

## <a id="event-tracking"></a>Event Tracking

If you have setup your *AppDelegate* right, *Installed* event is triggered automatically, 

Methods `trackRegisterEvent()`, `trackReturnedEvent()` and `trackLoyaltyEvent()` can take user ID as parameter. Optionally you can setup *AdmitadTracker* singleton's `userId` property. If you prefer not to provide user ID in any of these ways, user ID will be generated automatically.

#### <a id="user-id"></a>User Id
Swift:
```Swift
// somewhere in your code
admitadTracker.userId = userId
```

Objective-C:
```Objective-C
// somewhere in your code
admitadTracker.userId = userId
```
#### <a id="register"></a>Register
 *Register* event are triggered when:

Swift:
```Swift
admitadTracker.trackRegisterEvent()
```
or
```Swift
admitadTracker.trackRegisterEvent(userId: userId)
```
Objective-C:
```Objective-C
[admitadTracker trackRegisterEventWithUserId:nil completion:nil];
```
or
```Objective-C
[admitadTracker trackRegisterEventWithUserId: userId completion:nil];
```
#### <a id="returned"></a>Returned
 *Returned* event are triggered when:

Swift:
```Swift
admitadTracker.trackReturnedEvent()
```
or
```Swift
admitadTracker.trackReturnedEvent(userId: userId)
```
Objective-C:
```Objective-C
[admitadTracker trackReturnedEventWithUserId:nil completion:nil];
```
or
```Objective-C
[admitadTracker trackReturnedEventWithUserId: userId completion:nil];
```
#### <a id="loyalty"></a>Loyalty
 *Loyalty* event are triggered when: 

Swift:
```Swift
admitadTracker.trackLoyaltyEvent()
```
or
```Swift
admitadTracker.trackLoyaltyEvent(userId: userId)
```
Objective-C:
```Objective-C
[admitadTracker trackLoyaltyEventWithUserId:nil completion:nil];
```
or
```Objective-C
[admitadTracker trackLoyaltyEventWithUserId: userId completion:nil];
```
#### <a id="order"></a>Order
To track *Confirmed Purchase* and *Paid Order* an *AdmitadOrder* object must be instantiated and passed as parameter to `trackConfirmedPurchaseEvent` or `trackPaidOrderEvent` respectively. 

Swift:
```Swift
let items = [AdmitadOrderItem(name: "Phone"), AdmitadOrderItem(name: "Phone Charger", quantity: 3)]

let order = AdmitadOrder(id: id, totalPrice: price, currencyCode: currencyCode, items: items, userInfo: userInfo)
```
Objective-C:
```Objective-C
AdmitadOrderItem *item1 = [[AdmitadOrderItem alloc] initWithName:@"Phone"
quantity:1];
AdmitadOrderItem *item2 = [[AdmitadOrderItem alloc] initWithName:@"Phone Charger"
quantity:3];

NSArray<AdmitadOrderItem *> *items = @[item1, item2];

AdmitadOrder *order = [[AdmitadOrder alloc] initWithId:id totalPrice:price currencyCode:currencyCode items:items userInfo:userInfo];
```

##### <a id="additional-parameters"></a>Additional parameters

  * You can customize your order using any combination of additional parameters.  
  
###### _<a id="tarifcode"></a>tarifCode_
You can initialize *AdmitadOrder* with extra parameter *tarifCode*. Then Admitad can apply this tariff to the order as defined in your agreement.
To get tariff codes ask your Admitad account manager.

Swift:
```Swift
let orderWithTarif = AdmitadOrder(id: id, totalPrice: price, currencyCode: currencyCode, items: items, userInfo: userInfo, tarifCode: "itemCategory1")
```
Objective-C:
```Objective-C
AdmitadOrder *orderWithTarif = [[AdmitadOrder alloc] initWithId:id totalPrice:price currencyCode:currencyCode items:items userInfo:userInfo tarifCode:tarifCode];
```

###### _<a id="promocode"></a>promocode_
You can initialize *AdmitadOrder* with extra parameter *promocode*. Then Admitad will show promocode for this order in statistics report of your campaign.

Swift:
```Swift
let orderWithPromocode = AdmitadOrder(id: id, totalPrice: price, currencyCode: currencyCode, items: items, userInfo: userInfo, promocode: "SUPER_PROMO")
```
Objective-C:
```Objective-C
AdmitadOrder *orderWithPromocode = [[AdmitadOrder alloc] initWithId:id totalPrice:price currencyCode:currencyCode items:items userInfo:userInfo promocode:promocode];
```

###### _<a id="channel"></a>channel_
  You can initialize AdmitadOrder with extra parameter *channel*. It is used for order deduplication.  
  If you intend to attribute this order to Admitad then set channel to `AdmitadOrder.ADM_MOBILE_CHANNEL`.  
  If you intend to attribute this order to other affiliate network then set channel value to its name.  
  If you intend to attribute this order to any network then set channel to `AdmitadOrder.UNKNOWN_CHANNEL`.  

Swift:
```Swift
let orderWithPromocode = AdmitadOrder(id: id, totalPrice: price, currencyCode: currencyCode, items: items, userInfo: userInfo, channel: AdmitadOrder.ADM_MOBILE_CHANNEL)
```
Objective-C:
```Objective-C
AdmitadOrder *orderWithPromocode = [[AdmitadOrder alloc] initWithId:id totalPrice:price currencyCode:currencyCode items:items userInfo:userInfo channel:channel];
```

#### <a id="confirmed-purchase"></a>Confirmed Purchase
Swift:
```Swift
admitadTracker.trackConfirmedPurchaseEvent(order: order)
```
Objective-C:
```Objective-C
[admitadTracker trackConfirmedPurchaseEventWithOrder:order completion:nil];
```
#### <a id="paid-order"></a>Paid Order
Swift:
```Swift
admitadTracker.trackPaidOrderEvent(order: order)
```
Objective-C:
```Objective-C
[admitadTracker trackPaidOrderEventWithOrder:order completion:nil];
```

## <a id="delegation-and-callbacks"></a>Delegation and Callbacks

When working with *AdmitadSDK* from Swift environment you are provided with two mechanisms of notification on event tracking success or failure. Every event triggering method takes a completion callback. In the callback you can check if an error has occurred. *AdmitadTracker* instance also notifies its *delegate* object conforming to *AdmitadDelegate* protocol. Both ways of notification are independent from each other and can be used simultaneously and interchangeably. In Objective-C environment only the former mechanism is available.

Swift:
```Swift
class YourClass: AdmitadDelegate {
    func someFunc() {
        AdmitadTracker.sharedInstance.delegate = self
    }

    func startedTrackingAdmitadEvent(_ event: AdmitadEvent) {
        // code on start tracking
    }

    func finishedTrackingAdmitadEvent(_ event: AdmitadEvent?, error: AdmitadError?) {
        // code on finished tracking
        // you can check if error is nil here
    }
}
```
or
```Swift
trackRegisterEvent() { error in
    // code on finished tracking
    // you can check if error is nil here
}
```
Objective-C:
```
[admitadTracker trackRegisterEventWithUserId:nil completion:^(AdmitadError *error) {
    // code on finished tracking
    // you can check if error is nil here
}];
```

## <a id="license"></a>License

The admitad SDK is licensed under the MIT License.

Copyright (c) 2017 Admitad GmbH

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
