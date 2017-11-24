# ios_sdk
iOS integration SDK of https://www.admitad.com/

## Setting your project

Make sure that your project's deployment target is iOS 9.0 or higher.

Your project should be set up to make interaction with URL Schemes and Universal Links possible.
**Note**: you also should test on a real device because deeplinking doesn't work on simulator and therefore most of *AdmitadSDK* functionality won't be available.

To add *AdmitadSDK* to your project you have two options:
1. Manual Installation
2. Installation via CocoaPods

### Manual Installation

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

### Installation via CocoaPods

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

## Alamofire version

*AdmitadSDK* uses version 4.x of *Alamofire* as a dependency. So if you use *Alamofire* in your project, it's major release number should be 4. You're free to specify any minor release number for your needs.

## Objective-C interoperability

Just add `@import AdmitadSDK;` import statement to the source files that make use of *AdmitadSDK*.

## Setting AppDelegate

1. In `application(_:didFinishLaunchingWithOptions:)` method assign *AdmitadTracker* singleton's `postbackKey` property to your Admitad Postback Key.
2. In the same method call *AdmitadTracker*'s `trackAppLaunch()`, `trackReturnedEvent()` и `trackLoyaltyEvent()`.
Swift:
```Swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

admitadTracker.postbackKey = postbackKey

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

admitadTracker.postbackKey = postbackKey;

[admitadTracker trackAppLaunch];
[admitadTracker trackReturnedEventWithUserId:nil completion:nil];
[admitadTracker trackLoyaltyEventWithUserId:nil completion:nil];

return YES;
}

```

3. To track Universal Links usage, in `application(_:continue:restorationHandler:)` call corresondingly named `continueUserActivity` method and pass `userActivity` to it as parameter.
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
4. To track URL Schemes usage, in `application(_:open:options:)` call `openUrl` method and pass `url` to it as parameter.
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

## Event Tracking

If you have setup your *AppDelegate* right, *Installed* event is triggered automatically, *Returned* and *Loyalty* event are triggered when `trackReturnedEvent()` and `trackLoyaltyEvent()` respectively are called. To track *Confirmed Purchase* and *Paid Order* an *AdmitadOrder* object must be instantiated and passed as parameter to `trackConfirmedPurchaseEvent` or `trackPaidOrderEvent` respectively.
Swift:
```Swift
let items = [AdmitadOrderItem(name: "Phone"), AdmitadOrderItem(name: "Phone Charger", quantity: 3)]

let order = AdmitadOrder(id: id, totalPrice: price, currencyCode: currencyCode, items: items, userInfo: userInfo)

admitadTracker.trackConfirmedPurchaseEvent(order: order)
// or
admitadTracker.trackPaidOrderEvent(order: order)
```
Objective-C:
```Objective-C
AdmitadOrderItem *item1 = [[AdmitadOrderItem alloc] initWithName:@"Phone"
quantity:1];
AdmitadOrderItem *item2 = [[AdmitadOrderItem alloc] initWithName:@"Phone Charger"
quantity:3];

NSArray<AdmitadOrderItem *> *items = @[item1, item2];

AdmitadOrder *order = [[AdmitadOrder alloc] initWithId:id totalPrice:price currencyCode:currencyCode items:items userInfo:userInfo];

[admitadTracker trackConfirmedPurchaseEventWithOrder:order completion:nil];
// or
[admitadTracker trackPaidOrderEventWithOrder:order completion:nil];
```

Methods `trackRegisterEvent()`, `trackReturnedEvent()` and `trackLoyaltyEvent()` can take user ID as parameter. Optionally you can setup *AdmitadTracker* singleton's `userId` property. If you prefer not to provide user ID in any of these ways, user ID will be generated automatically.
Swift:
```Swift
// somewhere in your code
admitadTracker.userId = userId

// then
admitadTracker.trackRegisterEvent()
```
or
```Swift
admitadTracker.trackRegisterEvent(userId: userId)
```
Objective-C:
```Objective-C
// somewhere in your code
admitadTracker.userId = userId

// then
[admitadTracker trackRegisterEventWithUserId:nil completion:nil];
```
or
```Objective-C
[admitadTracker tratrackRegisterEventWithUserId: userId completion:nil];
```

## Delegation and Callbacks

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
