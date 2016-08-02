Spotz Push SDK
==========

## How to add the Spotz Push SDK framework to your project

Just add the following line to your Podfile:
```
pod 'SpotzPushSDK', :git => 'https://github.com/localz/Spotz-Push-iOS-SDK.git'
```

## How to use the SDK


**SDK is developed for iOS 8.0 or newer.

*Refer to the [sample app code](https://github.com/localz/Spotz-Push-iOS-SDK/tree/master/Examples/Objective-C/SamplePushApp) for a working implementation of the SDK.*

**1. Setup Spotz Push via the console**
1. Sign up for a Spotz Push account at [console.localz.io/spotz-push](console.localz.io/spotz-push)
2. Create the Spotz Push Application (Project) within Spotz Push and uploaded the corresponding APNS certificate (Sandbox or Production) to this Application.


**2. Set authorization message**

For iOS 8 or later, please add the following key to Info.plist with a message that will be presented to the user when they first start the app.
```
NSLocationAlwaysUsageDescription //Required for Location Push
```

**3. Initialize the Spotz Push SDK**

Import the SpotzPush header into the AppDelegate, then in the didFinishLaunchingWithOptions method add the following:

___Objective-C___
```
[SpotzPush initWithAppId:@"<Enter your app ID here>" appKey:@"<Enter your app key here>" start:true config:nil];
```

___Swift___
```
SpotzPush.initWithAppId("<Enter your app ID here>", appKey:"<Enter your client key here>", start:true, config:nil)
```
Note: You'll have to add the import into your ProjectName-Swift-Bridging-Header.h file
```
#import <SpotzPushSDK/SpotzPush.h>
```

**5. Add the following code into AppDelegate**

___Objective-C___
```
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    [[SpotzPush shared] appRegisteredForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    NSLog(@"Push setup successful");
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[SpotzPush shared] appFailedToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    [[SpotzPush shared] appReceivedActionWithIdentifier:identifier notification:userInfo
                                       applicationState:application.applicationState completionHandler:completionHandler];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[SpotzPush shared] appReceivedRemoteNotification:userInfo applicationState:application.applicationState];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [[SpotzPush shared] appReceivedRemoteNotification:userInfo applicationState:application.applicationState fetchCompletionHandler:completionHandler];
}
```

___Swift___
```
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        SpotzPush.shared().appRegisteredForRemoteNotificationsWithDeviceToken(deviceToken)
    }

    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        print("Push setup successful")
    }

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        SpotzPush.shared().appFailedToRegisterForRemoteNotificationsWithError(error)
    }

    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        SpotzPush.shared().appReceivedActionWithIdentifier(identifier, notification: userInfo, applicationState: application.applicationState, completionHandler: completionHandler)
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        SpotzPush.shared().appReceivedRemoteNotification(userInfo, applicationState: application.applicationState)
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        SpotzPush.shared().appReceivedRemoteNotification(userInfo, applicationState: application.applicationState, fetchCompletionHandler: completionHandler)
    }
```

**5. Start Location services for location push (optional)**

You will need to prompt user to accept location services permission request.

___Objective-C___
```
[[SpotzPush shared] enableLocationServices];
```
___Swift___
```
SpotzPush.shared().enableLocationServices()
```

You will only need to call this once (e.g. during app setup/introduction).

**6. Test Push via the console**

Login to the [Spotz Push console](https://console.localz.io/spotz-push) to send test notifications. Alternatively you can access the console via our microlocation proximity platform [Spotz console](https://console.localz.io/spotz).

There are 3 types of notification that you can send via the console
- Standard push notification
- Push notification with delivery confirmation
- Location push notification - queries whether a given device is in the vicinity of given location.

Notifications can do the follow: display messages, set icon badge numbers, play a sound, or be a silent/background notification.

**7. Push via Spotz Push API**

See the [API documentation](https://au-api-spotzpush.localz.io/documentation/public/spotzpush_docs.html) for more details.

## The right way to ask for iOS push notification permission

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
Copyright 2016 Localz Pty Ltd
