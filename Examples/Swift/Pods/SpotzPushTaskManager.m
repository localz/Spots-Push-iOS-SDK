//
//  SpotzTaskManager.m
//  SpotzSDK
//
//  Created by Melvin Artemas on 15/08/2015.
//  Copyright © 2015 Localz Pty Ltd. All rights reserved.
//
@import UIKit;
#import "SpotzPushTaskManager.h"
#import "SpotzPushAppState.h"

@interface SpotzPushTaskManager()

@end
@implementation SpotzPushTaskManager
{
    UIBackgroundTaskIdentifier backgroundTaskId;
}

- (instancetype) initWithName:(NSString *)taskName
{
    self = [super init];
    if(self)
    {
        self.name = taskName;
        backgroundTaskId = UIBackgroundTaskInvalid;
    }
    
    return self;
}

- (void) runIfInBackground {
    
    BOOL applicationStateBackground = false;
    
#if IS_SPOTZPUSHSDK_APP_EXTENSION == 0
    applicationStateBackground = [UIApplication sharedApplication].applicationState == UIApplicationStateBackground;
#endif

    [SpotzPushTaskManager runSafeOnMainThread:^{
        if([SpotzPushAppState state] == UIApplicationStateBackground)
        {
            [self backgroundTaskHandler];
        }
    }];
}

- (BOOL) isRunning
{
    return (backgroundTaskId != UIBackgroundTaskInvalid);
}

- (void) backgroundTaskHandler {
#if IS_SPOTZPUSHSDK_APP_EXTENSION == 0
    if (backgroundTaskId != UIBackgroundTaskInvalid) {
        // if we are in here, that means the background task is already running.
        // don't restart it.
        return;
    }
    PLog(@"BG: Starting background task %@",self.name);
    
    __block BOOL terminate = YES;
    
    backgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithName:self.name expirationHandler:^{
        
        PLog(@"BG: %@ expired",self.name);
        
        if (terminate) {
            
            PLog(@"BG: Terminating background task %@",self.name);
            
            [[UIApplication sharedApplication] endBackgroundTask:backgroundTaskId];
            backgroundTaskId = UIBackgroundTaskInvalid;
            terminate = false;
        }
    }];

#ifdef DEBUG
    // this may still spit out even after bg is completed
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PLog(@"BG: %@ started",self.name);
        
        while (UIBackgroundTaskInvalid != backgroundTaskId) {
            PLog(@"BG remaining: %8.2f", [UIApplication sharedApplication].backgroundTimeRemaining);
            [NSThread sleepForTimeInterval:1];
        }
    });
#endif
#endif
}

- (void) stopBackgroundTask {
#if IS_SPOTZPUSHSDK_APP_EXTENSION == 0
    if (backgroundTaskId != UIBackgroundTaskInvalid) {
        PLog(@"BG: Terminating background task %@",self.name);
        [SpotzPushTaskManager runSafeOnMainThread:^{
            [[UIApplication sharedApplication] endBackgroundTask:backgroundTaskId];
            backgroundTaskId = UIBackgroundTaskInvalid;
        }];
    }
#endif
}

+ (void) runSafeOnMainThread:(void (^)(void))block
{
    if ([NSThread isMainThread])
    {
        block();
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

@end
