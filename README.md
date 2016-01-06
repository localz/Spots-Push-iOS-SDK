Spotz Push SDK
==========

## Adding the Spotz Push SDK framework to your project

Just add the following line to your Podfile:
```
pod 'SpotzSDK', :git => 'https://github.com/localz/Spotz-Push-iOS-SDK.git'
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

**4. Test Push via the console**

There are 3 types of notifications that you can send via the console - async (standard notification), confirmed (confirm delivery of notification) and location push notifications. Location pushes query whether a given device is in the vicinity of given location. Notifications can include messages, set badge numbers, play sounds, or be a silent/background notification. See the [API documentation](https://au-api-spotzpush.localz.io/documentation/public/spotzpush_docs.html) for more details on how to send the above.

**Other things to remember**

Location Pushes will not be effective until the user does allows location access on device. Ensure to implement reminders in order to use this functionality.
Ensure that the SDK is initialised on app launch, in order to update any potential updates to the device's push token.

Contribution
============
For bugs, feature requests, or other questions, [file an issue](https://github.com/localz/Spotz-Push-iOS-SDK/issues/new).

License
=======
Copyright 2015 Localz Pty Ltd
