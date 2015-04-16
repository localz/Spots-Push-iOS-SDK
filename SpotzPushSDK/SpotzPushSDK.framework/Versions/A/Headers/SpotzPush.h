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
#import "SpotzPushConfig.h"

@interface SpotzPush : NSObject

@property (nonatomic) UIUserNotificationType userNotificationTypes;

/**
 * Returns the singleton instance of SpotzPush
 */
+ (SpotzPush *) shared;

/**
 *  Initialise service and register device with the given API Key and client Key. This will not start push notification.
 *
 *  @param appId appId provided by Localz
 *  @param appKey appKey provided by Localz
 *  @param options options for advance settings/debugging
 */
+ (void) initWithProjectId:(NSString *)projectId projectKey:(NSString *)projectKey config:(SpotzPushConfig *)config;

/**
 *  Enables push notification. If user has not yet enabled push notification, this will prompt the user to allow notifications.
 *  Call this method when the time is right to prompt user to accept notifications.
 */
- (void) userPushNotificationsEnabled:(BOOL)enable;

/**
 *  Enables location services. If user has not yet enabled location services, this will prompt the permission dialog.
 *  This is required to be called prior to locating user via push notification. 
 *  Call this method when the time is right to prompt user to accept location services.
 */
- (void) locationServicesEnabled:(BOOL)enable;

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
 */
- (void) appReceivedRemoteNotification:(NSDictionary *)userInfo applicationState:(UIApplicationState)state;

/**
 *  Handles the remote notification for SpotzPush purposes
 *
 *  @param userInfo dictionary of the push notification
 *  @param state state of the application. Default is to pass [UIApplication sharedApplication].applicationState.
 *  @param completionHandler block after fetch result
 */
- (void) appReceivedRemoteNotification:(NSDictionary *)userInfo applicationState:(UIApplicationState)state fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

- (void) appReceivedActionWithIdentifier:(NSString *)identifier notification:(NSDictionary *)userInfo applicationState:(UIApplicationState)state completionHandler:(void (^)()) handler;

- (void) appRegisteredUserNotificationSettings;

#pragma mark Push helpers

/**
 * Retrieve current device ID
 */
- (NSString *) getDeviceId;

/**
 *  Returns true if push notification is enabled
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

+ (BOOL) isBackgroundRefreshEnabled;

@end
