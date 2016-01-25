//
//  SpotzPushSDK.h
//  SpotzPushSDK
//
//  Created by Melvin Artemas on 29/03/2015.
//  Copyright (c) 2015 Localz Pty Ltd. All rights reserved.
//
@import UIKit;
@import CoreLocation;
#import <Foundation/Foundation.h>

@class SpotzPush;

@protocol SpotzPushDelegate <NSObject>
@optional
-(void)spotzPush:(SpotzPush *)spotzPush didReceiveRemoteNotification:(NSDictionary *)userInfo;
@end

@interface SpotzPush : NSObject

@property (nonatomic,assign) id<SpotzPushDelegate> delegate;


/**
 * Returns the singleton instance of SpotzPush
 */
+ (SpotzPush *) shared;

/**
 *  Initialise service and register device with the given API Key and client Key. Call this method inside the AppDelegate's didFinishLaunching.
 *  This will setup push with default UIUserNotificationTypes and no categories. Use this init method if you want to have the flexibility to place the iOS Push notification permission popup in your app by calling [[SpotzPush shared] startSpotzPush].
 *
 *  @param appId appId provided by Localz
 *  @param appKey appKey provided by Localz
 *  @param options options for advance settings/debugging
 */
+ (void) initWithProjectId:(NSString *)appId projectKey:(NSString *)appKey config:(NSDictionary *)config;

/**
 *  Initialise service and register device with the given API Key and client Key. Call this method inside the AppDelegate's didFinishLaunching.
 *  This will setup push with default UIUserNotificationTypes and no categories. 
 *
 *  @param appId appId provided by Localz
 *  @param appKey appKey provided by Localz
 *  @param start automatically starts Spotz Push if it is not yet started previously. This may popup the iOS push notification permission dialog.
 *  @param options options for advance settings/debugging
 */
+ (void) initWithAppId:(NSString *)appId appKey:(NSString *)appKey start:(BOOL)start config:(NSDictionary *)config;

/**
 *  Initialise service and register device with the given API Key and client Key. Call this method inside the AppDelegate's didFinishLaunching.
 *  This will setup push with default UIUserNotificationTypes and no categories.
 *
 *  @param appId appId provided by Localz
 *  @param appKey appKey provided by Localz
 *  @param start automatically starts Spotz Push if it is not yet started previously. This may popup the iOS push notification permission dialog.
 *  @param userTypes The notification types that your app supports. For a list of possible values, see the constants for the UIUserNotificationType type.
 *  @param categories A set of UIUserNotificationCategory objects that define the groups of actions a notification may include.
 *  @param options options for advance settings/debugging
 */
+ (void) initWithAppId:(NSString *)appId appKey:(NSString *)appKey start:(BOOL)start userTypes:(UIUserNotificationType)types categories:(NSSet *)categories config:(NSDictionary *)config;

/**
 *  Enables push notification with default alerts with default settings.
 *  Call this method when the time is right to prompt user to accept notifications.
 */
- (void) startSpotzPush;

/**
 *  Enables location services. If user has not yet enabled location services, this will prompt the permission dialog.
 *  This is required to be called prior to locating user via push notification. 
 *  Call this method when the time is right to prompt user to accept location services.
 */
- (void) enableLocationServices;

/**
 *  Register push notification device token for Push Notifications
 *
 *  @param deviceToken deviceToken
 */
- (void) appRegisteredForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

/**
 *  Handles the errors when registering for push notification.
 *
 *  @param error error returned from didFailToRegisterForRemoteNotificationsWithError
 */
- (void) appFailedToRegisterForRemoteNotificationsWithError:(NSError *)error;

/**
 *  Handles the remote notification for SpotzPush purposes
 *
 *  @param userInfo dictionary of the push notification
 *  @param state state of the application. Default is to pass [UIApplication sharedApplication].applicationState.
 *  @return true if it is a spotz push notification, false if not/will not be processed by Spotz Push
 */
- (BOOL) appReceivedRemoteNotification:(NSDictionary *)userInfo applicationState:(UIApplicationState)state;

/**
 *  Handles the remote notification for SpotzPush purposes
 *
 *  @param userInfo dictionary of the push notification
 *  @param state state of the application. Default is to pass [UIApplication sharedApplication].applicationState.
 *  @param completionHandler block after fetch result
 *  @return true if it is a spotz push notification, false if not/will not be processed by Spotz Push
 */
- (BOOL) appReceivedRemoteNotification:(NSDictionary *)userInfo applicationState:(UIApplicationState)state fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

- (void) appReceivedActionWithIdentifier:(NSString *)identifier notification:(NSDictionary *)userInfo applicationState:(UIApplicationState)state completionHandler:(void (^)()) handler;

#pragma mark Push helpers

/**
 * Retrieve current device ID
 */
- (NSString *) getDeviceId;

/**
 *  Returns true if push notification is enabled and UIUserNotificationType is not set to none
 */
+ (BOOL) isPushNotificationEnabled;

/**
 *  Returns true of location services is enabled
 *  on the device. Does not tell whether location has been authorized or not.
 */
+ (BOOL) isLocationServicesEnabledOnDevice;

/**
 *  Returns location services authorization status.
 *  Will return true if authorized for always or inuse only.
 */
+ (BOOL) isLocationServicesAuthorized;

/**
 *  Check if the background refresh is enabled
 *  @return true if enabled, false if not
 */
+ (BOOL) isBackgroundRefreshEnabled;

@end
