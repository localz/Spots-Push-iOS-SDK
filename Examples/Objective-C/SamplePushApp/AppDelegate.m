//
//  AppDelegate.m
//  SamplePushApp
//
//  Created by Melvin Artemas on 16/04/2015.
//  Copyright (c) 2015 Localz Pty Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import <SpotzPushSDK/SpotzPush.h>

@interface AppDelegate() <SpotzPushDelegate, UNUserNotificationCenterDelegate>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    // Initialize Spotz Push. We prompt the permission dialog when user tap on the Enable Push Notification button which calls  startSpotzPush, therefore set start = false
    [SpotzPush shared].delegate = self; // Delegate must be set first to be used in init
    [SpotzPush initWithAppId:@"Enter_Spotz_App_ID_Here" appKey:@"Enter_Spotz_App_Key_Here" start:false config:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Required SpotzPush code in AppDelegate
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[SpotzPush shared] appRegisteredForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [[SpotzPush shared] appRegisteredUserNotificationSettings:notificationSettings];
    [[SpotzPush shared] enableLocationServices];
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

#pragma mark - UNUserNotificationCenterDelegate
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    [[SpotzPush shared] userNotificationCenter:center willPresentNotification:notification withCompletionHandler:completionHandler];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    [[SpotzPush shared] userNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
}

@end
