Spotz Push SDK
==========

## Requirements

- iOS 8 or newer to use SpotzPushSDK
- iOS 10 or newer to use rich notifications such as titles, images, and other interactive content (optional)

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
**Note: Swift files importing Objective-C files require a bridging header:**
1. Create a new header file
2. Under the project's Build Settings, add the header file location to Objective-C Bridging Header
3. Add the SpotzPushSDK to the bridging header as shown below:
```
#import <SpotzPushSDK/SpotzPush.h>
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

**5. Add Rich Notification Image Handler Target _(optional)_**

Only add this if you want to modify the notification before it reaches the user.
If you want to add an image, you should use this method to download and attach an image from a URL.

1. Add a new target from the Xcode menu: File > New > Target
2. Select 'Notification Service Extension' and give it an appropriate name
3. Choose 'Activate' from activate scheme popup. 
This will add a new folder to the project with this name
4. Add to NotificationService inside the folder:

__Objective-C__
```
- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Check for the attachment
    NSDictionary *userInfo = request.content.userInfo;
    if (userInfo == nil) {
        [self contentComplete];
        return;
    }
    
    NSString *attachmentURL = userInfo[@"attachment"];
    if (attachmentURL == nil) {
        [self contentComplete];
        return;
    }
    
    // Detect the attachment type to load
    NSArray *urlComponents = [attachmentURL componentsSeparatedByString:@"."];
    NSString *type = [@"." stringByAppendingString:[urlComponents lastObject]];
    
    // Load the attachment
    [self loadAttachmentForUrlString:attachmentURL withType:type completionHandler:^(UNNotificationAttachment *attachment) {
        // Add the attachment to our best attempt content
        if (attachment) {
            self.bestAttemptContent.attachments = [NSArray arrayWithObject:attachment];
        }
        [self contentComplete];
    }];
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // This will be used to deliver a "best attempt" at the modified content (otherwise the original push payload will be used)
    [self contentComplete];
}

- (void)contentComplete {
    // Confirm the content to be delivered to the user
    self.contentHandler(self.bestAttemptContent);
}

- (void)loadAttachmentForUrlString:(NSString *)urlString withType:(NSString *)type completionHandler:(void(^)(UNNotificationAttachment *))completionHandler  {
    __block UNNotificationAttachment *attachment = nil;
    NSURL *attachmentURL = [NSURL URLWithString:urlString];
    
    // Download the attachment
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session downloadTaskWithURL:attachmentURL completionHandler:^(NSURL *temporaryFileLocation, NSURLResponse *response, NSError *error) {
        
        if (error != nil) NSLog(@"%@", error.localizedDescription);
        else {
            // Store the attachment in a temporary location
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSURL *localURL = [NSURL fileURLWithPath:[temporaryFileLocation.path stringByAppendingString:type]];
            [fileManager moveItemAtURL:temporaryFileLocation toURL:localURL error:&error];
            
            // Link the attachment to our UNNotificationAttachment
            NSError *attachmentError = nil;
            attachment = [UNNotificationAttachment attachmentWithIdentifier:@"" URL:localURL options:nil error:&attachmentError];
            if (attachmentError) NSLog(@"%@", attachmentError.localizedDescription);
        }
        completionHandler(attachment);
    }] resume];
}
```

__Swift__
```
override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
    self.contentHandler = contentHandler
    self.bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
    
    // Check to see if there's an attachment
    guard let attachmentUrl = request.content.userInfo["attachment"] as? String else {
        self.contentComplete()
        return
    }
    
    let urlComponents = attachmentUrl.components(separatedBy: ".")
    guard let fileType = urlComponents.last else {
        self.contentComplete()
        return
    }
    
    self.loadAttachmentForURLString(attachmentUrl, type: "."+fileType, completionHandler: { (attachment:UNNotificationAttachment?) in
        if let attachment = attachment {
            self.bestAttemptContent?.attachments = [attachment]
        }
        self.contentComplete()
    })
}

override func serviceExtensionTimeWillExpire() {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentComplete()
}

func contentComplete() {
    // Confirm the content to be delivered to the user
    self.contentHandler!(self.bestAttemptContent!)
}

func loadAttachmentForURLString(_ urlString: String, type: String, completionHandler: @escaping ((_ attachment: UNNotificationAttachment?) -> Void)) {
    var attachment:UNNotificationAttachment?
    let attachmentURL = URL(string: urlString)!
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    (session.downloadTask(with: attachmentURL) { (temporaryURL:URL?, response:URLResponse?, error:Error?) in
        
        if let error = error {
            print(error.localizedDescription)
        } else if let temporaryURL = temporaryURL {
            
            // Store the attachment in a temporary location
            let fileManager = FileManager.default
            let localURL = URL(fileURLWithPath: (temporaryURL.path+type))
            
            // Link the attachment to our UNNotificationAttachment
            do {
                try fileManager.moveItem(at: temporaryURL, to: localURL)
                try attachment = UNNotificationAttachment(identifier: "", url: localURL, options: nil)
            } catch {
                print("Failed to move item to location "+localURL.path+" and create attachment")
            }
        }
        completionHandler(attachment)
    }).resume()
}
```

**6. Add Rich Notification Deletion Capability (optional)**

One of the new features of rich notifications is to edit them after they've been presented to the user. One such use of this would be deleteing a notification to replace it with another another.

This feature assumes you have already added the `Notification Service Extension` as described above in point 5.

Each notification needs to be given a custom ID so it can be identified for deletion later. We are going to use two custom flags in the notifications payload for this.
1. `userInfo["id"]`: the identifier for this notification or notification group
2. `userInfo["reset"]`: a boolean value which if set, clears all previous notifications with the specified id

Method:
1. Add a method to the `Notification Service Extension` to check for a custom id and reset flag
2. Call this check method in `didReceiveNotificationRequest:` before handling the rest of the notification

___Objective-C___
```
- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
        
    // Check for the attachment
    NSDictionary *userInfo = request.content.userInfo;
    [self checkNotificationForRemoval:userInfo];
}

- (void)checkNotificationForRemoval:(NSDictionary *)userInfo {
    
    // Remove any notifications with the same ID if the reset flag is set
    // NOTE: This is a custom flag you need to add in the notification's payload
    BOOL reset = [[userInfo objectForKey:@"reset"] boolValue];
    if (userInfo[@"id"] && reset) {
        NSString *notificationId = userInfo[@"id"];
        
        [[UNUserNotificationCenter currentNotificationCenter] getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
            
            for (UNNotification *n in notifications) {
                NSDictionary *uInfo = n.request.content.userInfo;
                NSString *uId = uInfo[@"id"];
                
                if (uId && [uId isEqualToString:notificationId]) {
                    NSLog(@"Removing notification with id %@ and %@", uId, n.request.identifier);
                    [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[n.request.identifier]];
                }
            }
        }];
    }
}
```

___Swift___
```
override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
    self.contentHandler = contentHandler
    self.bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
    
    self.checkNotificationForRemoval(request.content.userInfo)
}

func checkNotificationForRemoval(_ userInfo: [AnyHashable:Any]) {
        
    // Remove any notifications with the same ID if the reset flag is set
    // NOTE: This is a custom flag you need to add in the notification's payload
    if let notificationId = userInfo["id"] as? String,
        let reset = userInfo["reset"] as? Bool,
        reset {
        
        UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: { (notifications:[UNNotification]) in
            
            for n in notifications {
                let uInfo = n.request.content.userInfo
                if let uId = uInfo["id"] as? String,
                    uId == notificationId {
                    print("Removing notification with id \(uId) and \(n.request.identifier)")
                    UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [n.request.identifier])
                }
            }
        })
    }
}
```

This snippet will now look for an id and reset flag in the notification payloads.
For example:
```
{
    "apn": {
        "aps": {
            "alert": {
                "body": "a body",
                "title": "a title"
            },
            "sound": "default",
            "mutable-content": 1
        },
        "id":"1",
        "reset":1
    }
}
```

**7. Start Location services for location push (optional)**

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

You will only need to call this once (e.g. during app setup/introduction).

**8. Test Push via the console**

Login to the [Spotz Push console](https://console.localz.io/spotz-push) to send test notifications. Alternatively you can access the console via our microlocation proximity platform [Spotz console](https://console.localz.io/spotz).

There are 3 types of notification that you can send via the console
- Standard push notification
- Push notification with delivery confirmation
- Location push notification - queries whether a given device is in the vicinity of given location.

Notifications can do the following: display messages, set icon badge numbers, play a sound, or be a silent/background notification.
Rich Notifications can do the following: same as above, display an image/gif, show bold text (title), or be deleted.

Rich Notifications use a different type of format, to test this out in the Spotz Push Console use the format:
```
{
    "apn": {
        "aps": {
            "alert": {
                "body": "a body",
                "title": "a title"
            },
            "sound": "default",
            "mutable-content": 1
        },
        "attachment": "<https image url>"
    }
}
```

**9. Push via Spotz Push API**

See the [API documentation](https://au-api-spotzpush.localz.io/documentation/public/spotzpush_docs.html) for more details.

## The right way to ask for iOS push notification permissions

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

