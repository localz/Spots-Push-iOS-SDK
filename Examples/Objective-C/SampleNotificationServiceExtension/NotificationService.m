//
//  NotificationService.m
//  SampleNotificationServiceExtension
//
//  Created by Daniel Sykes-Turner on 10/5/17.
//  Copyright © 2017 Localz Pty Ltd. All rights reserved.
//

#import "NotificationService.h"
#import <SpotzPushSDK/SpotzPushNotificationExtension.h>

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
   
    // Setup the network class so the extension can make its own calls
    [[SpotzPushNotificationExtension shared] initWithAppId:@"Enter_Spotz_App_ID_Here" appKey:@"Enter_Spotz_App_Key_Here" options:nil];

    // Forward the notification request to SpotzPush
    [[SpotzPushNotificationExtension shared] didReceiveNotificationRequest:request withContentHandler:contentHandler];
}

- (void)serviceExtensionTimeWillExpire {
    
    // Forward the expiry message to SpotzPush
    [[SpotzPushNotificationExtension shared] serviceExtensionTimeWillExpire];
}

@end
