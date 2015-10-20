//
//  ViewController.m
//  SpotzPushTest
//
//  Created by George Yamana on 27/01/2015.
//  Copyright (c) 2015 Localz Pty Ltd. All rights reserved.
//
@import CoreLocation;
#import "ViewController.h"
#import <SpotzPushSDK/SpotzPush.h>
@interface ViewController()
@end
@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startPush:(id)sender {
    
    // Prompt user to enable push notification, defaults with the following notification types: UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge
    [[SpotzPush shared] startSpotzPush];
    
    // Or alternatively setup type of notifications, with the following:
    
    //[[SpotzPush shared] startSpotzPushWithUserTypes: UIUserNotificationTypeSound|UIUserNotificationTypeAlert|UIUserNotificationTypeBadge categories:nil ];
}
- (IBAction)startLocation:(id)sender {
    // Prompt user to share location services
    [[SpotzPush shared] enableLocationServices];
}
@end