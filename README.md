Spotz Push SDK
==========

## Adding the Spotz Push SDK framework to your project

Just add the following line to your Podfile:
```
pod 'SpotzPushSDK', :git => 'https://github.com/localz/Spotz-Push-iOS-SDK.git'
```

How to use the SDK
==================

**SDK is developed for iOS 8.0 or later.

There are only 3 actions to implement - **setup, configure, and initialise!**

*Refer to the sample app code for a working implementation of the SDK.*

**1. Setup Spotz Push via the console**

Ensure that Spotz Push application is created via the [console](https://spotz-push.localz.io/), and note the iOS key. Upload the corresponding APNS certificate (Sandbox or Production) to the project.

**2. Set authorization message**

For iOS 8 or later, please add the following key to Info.plist with a message that will be presented to the user when they first start the app.
```
NSLocationAlwaysUsageDescription //Required for Location Push
```

**3. Initialize the Spotz Push SDK**

Import the SpotzPush header into the AppDelegate, then in the didFinishLaunchingWithOptions method add the following:

Objective-C
```
[SpotzPush initWithProjectId:@"<Enter your app ID here>" appKey:@"<Enter your client key here>" config:nil];
```
**5. Add the following code into AppDelegate**

Objective-C
```
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [[SpotzPush shared] appRegisteredForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    NSLog(@"Push setup successfull");
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
**5. Start SpotzPush service**

In order to send a push notification, the user has to accept iOS push notification permission request. You can control when the user is to be prompted by calling this method

```
[[SpotzPush shared] startSpotzPush];
```

This is required before you can start sending push notification to the device. You will only need to call this method once (e.g. during app setup/introduction).

**6. Start Location services for location push (optional)**

Similarly you will need to prompt user to accept location services permission request.

```
[[SpotzPush shared] enableLocationServices];
```

You will only need to call this once (e.g. during app setup/introduction).

**7. Test Push via the console**

Login to the [Spotz Push console](https://console.localz.io/spotz-push) to send test notifications. Alternatively you can access the console via our microlocation proximity platform [Spotz console](https://console.localz.io/spotz).

There are 3 types of notifications that you can send via the console 
- Standard push notification
- Push notification with delivery confirmation
- Location push notification. Location pushes query whether a given device is in the vicinity of given location.

Notifications can include messages, set badge numbers, play sounds, or be a silent/background notification. 

**8. Push via API**

See the [API documentation](https://au-api-spotzpush.localz.io/documentation/public/spotzpush_docs.html) for more details.

**Other things to remember**

Location Pushes will not be effective until the user does allows location access on device. Ensure to implement reminders in order to use this functionality.

Ensure that the SDK is initialised on app launch, in order to update any potential updates to the device's push token.

Contribution
============
For bugs, feature requests, or other questions, [file an issue](https://github.com/localz/Spotz-Push-iOS-SDK/issues/new).

License
=======
Copyright 2015 Localz Pty Ltd
