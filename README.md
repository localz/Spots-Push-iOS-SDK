Spotz Push SDK
==========

## Requirements

- iOS 8 or newer to use SpotzPushSDK
- iOS 10 or newer to use SpotzPushSDK rich notifications (attachments, notification recalling, reliable confirmations)

# Getting Started

**1. Enable project notification capabilities**
- In the project's Capabilities tab enable the Push Notifications switch
- In the same tab enable Background Modes and tick Remote Notifications under the Background Modes dropdown

**2. Import SpotzPushSDK into the project**
Create a Podfile with the following format:
```
use_frameworks!  # Swift only!

target "<Enter Your Target Name>" do
  pod 'SpotzPushSDK', :git => 'https://github.com/localz/Spotz-Push-iOS-SDK.git'
end
```

**NOTE: Swift files importing Objective-C files require a bridging header:**
1. Create a new header file
2. Under the project's Build Settings, add the header file location to Objective-C Bridging Header
3. Add the SpotzPushSDK to the bridging header as shown below:
```
#import <SpotzPushSDK/SpotzPush.h>
```

**3. Add initalisation to the App Delegate**
- Import the SpotzPush header into the AppDelegate
- Add the SpotzPushDelegate and UNUserNotificationCenter delegates
- In the didFinishLaunchingWithOptions set the delegate and add the init method

___Objective-C___
```
#import <SpotzPushSDK/SpotzPush.h>

@interface AppDelegate() <SpotzPushDelegate,UNUserNotificationCenterDelegate>
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [SpotzPush shared].delegate = self;
    [SpotzPush initWithAppId:@"<Enter your app ID here>" appKey:@"<Enter your app key here>" start:true config:nil];
    return YES;
}
```
___Swift___
```
class AppDelegate: UIResponder, UIApplicationDelegate, SpotzCNCCustomerSDKManagerDelegate, SpotzPushDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        SpotzPush.shared().delegate = self
        SpotzPush.initWithAppId("<Enter your app ID here>", appKey:"<Enter your app key here>", start:true, config:nil)
        return true
    }
```

**4. Add SpotzPush notification handler methods to App Delegate**

SpotzPushSDK automatically manages registration tokens and notifications by forwarding the calls from App Delegate

___Objective-C___
```
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[SpotzPush shared] appRegisteredForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [[SpotzPush shared] appRegisteredUserNotificationSettings:notificationSettings];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [[SpotzPush shared] appFailedToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    [[SpotzPush shared] appReceivedActionWithIdentifier:identifier notification:userInfo applicationState:application.applicationState completionHandler:completionHandler];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[SpotzPush shared] appReceivedRemoteNotification:userInfo applicationState:application.applicationState];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[SpotzPush shared] appReceivedRemoteNotification:userInfo applicationState:application.applicationState fetchCompletionHandler:completionHandler];
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    [[SpotzPush shared] userNotificationCenter:center willPresentNotification:notification withCompletionHandler:completionHandler];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    [[SpotzPush shared] userNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
}
```

___Swift___
```
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    SpotzPush.shared().appRegisteredForRemoteNotifications(withDeviceToken: deviceToken)
}

func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
    SpotzPush.shared().appRegisteredUserNotificationSettings(notificationSettings)
}

func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    SpotzPush.shared().appFailedToRegisterForRemoteNotificationsWithError(error)
}

func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
    SpotzPush.shared().appReceivedAction(withIdentifier: identifier, notification: userInfo, applicationState: application.applicationState, completionHandler: completionHandler)
}

func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
    SpotzPush.shared().appReceivedRemoteNotification(userInfo, applicationState: application.applicationState)
}

func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    SpotzPush.shared().appReceivedRemoteNotification(userInfo, applicationState: application.applicationState, fetchCompletionHandler: completionHandler)
}


@available(iOS 10.0, *)
func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    SpotzPush.shared().userNotificationCenter(center, willPresent: notification, withCompletionHandler: completionHandler)
}

@available(iOS 10.0, *)
func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    SpotzPush.shared().userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
}
```

**5. Add Rich Notification Handler Target _(iOS 10 or newer)_**

Rich notifications allow requested content to be modified before it is presented to the user, such as taking a https attachment URL and presenting it inside the notification.

**NOTE: If using Swift, another bridging header is required for the app extension:**
1. Create a new header file for the app extension
2. Under the app extension project's Build Settings, add the header file location to Objective-C Bridging Header
3. Add the SpotzPushSDK to the bridging header as shown below:
```
#import <SpotzPushSDK/SpotzPushNotificationExtension.h>
```

1. Add a new target from the Xcode menu: File > New > Target
2. Select 'Notification Service Extension' and give it an appropriate name
3. Choose 'Activate' from activate scheme popup. 
This will add a new folder to the project with this name
4. Setup your Podfile to to look like the following:
```
source 'https://github.com/localz/Spotz-iOS-Specs.git'
source 'https://github.com/CocoaPods/Specs.git'

project '<ProjectNameHere>'
target '<ProjectTargetNameHere>' do
    pod 'SpotzPushSDK'
end
target '<ProjectExtensionTargetNameHere>' do
    pod 'SpotzPushSDK/Extension'
end
```
5. Add to NotificationService main file inside the folder:

__Objective-C__
```
- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    [[SpotzPushNotificationExtension shared] initWithAppId:@"Enter_Spotz_App_ID_Here" appKey:@"Enter_Spotz_App_Key_Here" options:nil];
    [[SpotzPushNotificationExtension shared] didReceiveNotificationRequest:request withContentHandler:contentHandler];
}

- (void)serviceExtensionTimeWillExpire {
    [[SpotzPushNotificationExtension shared] serviceExtensionTimeWillExpire];
}
```

__Swift__
```
override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
    SpotzPushNotificationExtension.shared().initWithAppId("Enter_Spotz_App_ID_Here", appKey:"Enter_Spotz_App_Key_Here", options:nil)
    SpotzPushNotificationExtension.shared().didReceive(request, withContentHandler: contentHandler)
}

override func serviceExtensionTimeWillExpire() {
    SpotzPushNotificationExtension.shared().serviceExtensionTimeWillExpire()
}
```

**6. Start Location services for location push (optional)**

Use this to enable requests for the device's coordinates via a push notifications.
You will need to prompt user to accept location services permission request.

___Objective-C___
```
[[SpotzPush shared] enableLocationServices];
```

___Swift___
```
SpotzPush.shared().enableLocationServices()
```

You will only need to call this once (during app setup/introduction).

**7. Test Push via the console**

Login to the [Spotz Push console](https://console.localz.io/spotz-push) to send test notifications. Alternatively you can access the console via our microlocation proximity platform [Spotz console](https://console.localz.io/spotz).

There are 3 types of notification that you can send via the console
- Standard push notification
- Push notification with delivery confirmation
- Location push notification - queries whether a given device is in the vicinity of given location.

Notifications can do the following: display messages, set icon badge numbers, play a sound, or be a silent/background notification.
Rich Notifications can do the following: same as above, display an image/gif/video, be recalled, or have delivery even when the app is not running in the background.

**7. Push via Spotz Push API**

See the [API documentation](https://au-api-spotzpush.localz.io/documentation/public/spotzpush_docs.html) for more details.

## The _right way_ to ask for iOS push notification permissions

When a user opens the app for the first time, iOS will prompt the user to accept push notifications. This, however, may not be the desired user experience. The right way for asking for permission is explained in this [website](http://techcrunch.com/2014/04/04/the-right-way-to-ask-users-for-ios-permissions/). In order to time the prompt at the right moment, you will need to do a couple of things:

**1. Stop _init_ method from starting the service**

In the _init_ method, set _start = false_. This will stop the _init_ method from starting the service straight after initialisation is completed.

___Objective-C___
```
[SpotzPush initWithAppId:@"<Enter your app ID here>" appKey:@"<Enter your app key here>" start:false config:nil];
```

___Swift___
```
SpotzPush.initWithAppId("<Enter your app ID here>", appKey:"<Enter your client key here>", start:false, config:nil)
```

**2. Start SpotzPush service**

To pop up the push notification permission dialog (it will only appear if the user has not excepted the permission previously), call the following method when the user is ready to be prompted. You will only need to call this method once during the lifetime of the app.

___Objective-C___
```
[[SpotzPush shared] startSpotzPush];
```

___Swift___
```
SpotzPush.shared().startSpotzPush()
```

## Other things to remember
- Location Pushes will not be effective until the user does allows location access on device. Ensure to implement reminders in order to use this functionality.
- Ensure that the SDK is initialised on app launch, in order to update any potential updates to the device's push token.
- Don't forget to include bridging header when writing the app in Swift.
- You can check whether a user has accepted and enabled push notification by calling the following method:

___Objective-C___
```
[[SpotzPush shared] isPushNotificationEnabled];
```

___Swift___
```
SpotzPush.shared().isPushNotificationEnabled()
```

- If you are implementing SpotzPushDelegate to receive the raw push payload, don't forget to set the delegate after you call the init SDK method:

___Objective-C___
```
[SpotzPush shared].delegate = self;
```

___Swift___
```
SpotzPush.shared().delegate = self
```



Contribution
============
For bugs, feature requests, or other questions, [file an issue](https://github.com/localz/Spotz-Push-iOS-SDK/issues/new).

License
=======
Copyright 2017 Localz Pty Ltd

