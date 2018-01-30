//
//  NotificationService.swift
//  SampleNotificationServiceExtension
//
//  Created by Daniel Sykes-Turner on 17/5/17.
//  Copyright © 2017 Localz Pty Ltd. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        
        // Setup the network class so the extension can make its own calls
        SpotzPushNotificationExtension.shared().initWithAppId("Enter_Spotz_App_ID_Here", appKey:"Enter_Spotz_App_Key_Here", options:nil)
        
        // Forward the notification request to SpotzPush
        SpotzPushNotificationExtension.shared().didReceive(request, withContentHandler: contentHandler)
    }
    
    override func serviceExtensionTimeWillExpire() {
        
        // Forward the expiry message to SpotzPush
        SpotzPushNotificationExtension.shared().serviceExtensionTimeWillExpire()
    }
}
