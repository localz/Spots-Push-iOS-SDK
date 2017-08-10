//
//  NotificationService.m
//  SampleNotificationServiceExtension
//
//  Created by Daniel Sykes-Turner on 10/5/17.
//  Copyright © 2017 Localz Pty Ltd. All rights reserved.
//

#import "NotificationService.h"
// Remember to set the project's (Pods) target's (SpotzPushSDK), build setting (Require Only App-Extension-Safe API) to NO
#import <SpotzPushSDK/SpotzPushNotificationExtension.h>

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
   
    // Forward the notification request to SpotzPush
    [[SpotzPushNotificationExtension shared] didReceiveNotificationRequest:request withContentHandler:contentHandler];
}

- (void)serviceExtensionTimeWillExpire {
    
    // Forward the expiry message to SpotzPush
    [[SpotzPushNotificationExtension shared] serviceExtensionTimeWillExpire];
}

@end

