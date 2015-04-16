//
//  SpotzPushConfig.h
//  SpotzPushSDK
//
//  Created by Melvin Artemas on 31/03/2015.
//  Copyright (c) 2015 Localz Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpotzPushConfig : NSObject
@property (nonatomic) BOOL isDebug;

+ (SpotzPushConfig *)shared;

/**
 * Additional params to configure SpotzPush
 * @param config Configuration dictionary
 */
- (void) configure:(NSDictionary *)config;
- (BOOL) pLog;
@end
