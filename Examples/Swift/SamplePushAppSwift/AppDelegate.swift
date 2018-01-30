//
//  AppDelegate.swift
//  SamplePushAppSwift
//
//  Created by Daniel Sykes-Turner on 17/5/17.
//  Copyright © 2017 Localz Pty Ltd. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SpotzPushDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Initialize Spotz Push. We prompt the permission dialog when user tap on the Enable Push Notification button which calls  startSpotzPush, therefore set start = false
        SpotzPush.shared().delegate = self // Delegate must be set first to be used in init
        SpotzPush.initWithAppId("Enter_Spotz_App_ID_Here", appKey: "Enter_Spotz_App_Key_Here", start: true, config: nil)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Required SpotzPush code in AppDelegate
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
        SpotzPush.shared().appReceivedAction(withIdentifier: identifier!, notification: userInfo, applicationState: application.applicationState, completionHandler: completionHandler)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        SpotzPush.shared().appReceivedRemoteNotification(userInfo, applicationState: application.applicationState)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        SpotzPush.shared().appReceivedRemoteNotification(userInfo, applicationState: application.applicationState, fetchCompletionHandler: completionHandler)
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    @available(iOS 10.0, *)
    private func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void?) {
        SpotzPush.shared().userNotificationCenter(center, willPresent: notification, withCompletionHandler: (completionHandler as! (UNNotificationPresentationOptions) -> Void))
    }
    
    @available(iOS 10.0, *)
    private func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void?) {
        SpotzPush.shared().userNotificationCenter(center, didReceive: response, withCompletionHandler: (completionHandler as! () -> Void))
    }
}

