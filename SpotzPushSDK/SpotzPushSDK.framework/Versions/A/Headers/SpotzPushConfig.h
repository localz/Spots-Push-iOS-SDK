//
//  SpotzPushConfig.h
//  SpotzPushSDK
//
//  Created by Melvin Artemas on 31/03/2015.
//  Copyright (c) 2015 Localz Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SpotzPushDCRegionAU = 6000,
    SpotzPushDCRegionEU = 3000
} SpotzPushDCRegion;

FOUNDATION_EXPORT NSString * const SPOTZPUSH_SDK_VERSION;

FOUNDATION_EXPORT NSString * const SPOTZPUSH_API_AU_PROD_HOST;
FOUNDATION_EXPORT NSString * const SPOTZPUSH_API_EU_PROD_HOST;

FOUNDATION_EXPORT NSString * const SPOTZPUSH_API_DEV_HOST;

FOUNDATION_EXPORT NSString * const SPOTZPUSH_ENV_ID;
FOUNDATION_EXPORT NSString * const SPOTZPUSH_ENV_HOST;
FOUNDATION_EXPORT NSString * const SPOTZPUSH_ENV_URL;

FOUNDATION_EXPORT NSString * const SPOTZPUSH_PROJECT_ID;
FOUNDATION_EXPORT NSString * const SPOTZPUSH_PROJECT_KEY;
FOUNDATION_EXPORT NSString * const SPOTZPUSH_APPID_AU_REGION;
FOUNDATION_EXPORT NSString * const SPOTZPUSH_APPID_EU_REGION;

@interface SpotzPushConfig : NSObject

@property (nonatomic) BOOL isDebug;
@property (nonatomic,strong) NSString *version;
@property (nonatomic,strong) NSDictionary *env;
@property (nonatomic,strong) NSString *host;
@property (nonatomic) BOOL isDevEnv;
@property (nonatomic) NSString *regionCode;

/**
 *  Retrieve SDK Version
 *
 *  @return sdk version
 */
- (NSString *) sdkVersion;

+ (SpotzPushConfig *)shared;

/**
 *  Returns projectId
 */
- (NSString *) projectId;

/**
 *  Returns projectKey
 */
- (NSString *) projectKey;

/**
 *  Retrieve device ID from user defaults
 */
- (NSString *) deviceId;

/**
 *  Retrieve device ID from user defaults
 */
- (NSString *) spotzDeviceId;

/**
 *  Set Device ID
 *
 *  @param deviceId device ID
 */
- (void) setDeviceId:(NSString *)deviceId;

/**
 *  Set application Id and client Key
 *
 *  @param projectId projectID
 *  @param projectKey projectKey
 */
- (void) setProjectId:(NSString *)pId projectKey:(NSString *)key;

/**
 * Additional params to configure SpotzPush
 * @param config Configuration dictionary
 */
- (void) configure:(NSDictionary *)config;
- (void) configureForEnv:(NSString *)env;
- (BOOL) pLog;
- (SpotzPushDCRegion) dcRegion;

/**
 *  Returns the value stored in the configuration file based on SpotzEnvironments.plist
 *  If there is an override value for the key given, it will return the override value
 *  If the value exists for the target build, it will return the target build value
 *  Otherwise it will return the default value set. If not found it will return null
 *
 *  @param key the key name to retrieve
 *
 *  @return returns the value for the given key
 */
- (id) getValue:(NSString *)key;

/**
 *  Override value of the SDK config
 *
 *  @param key    the key name to override
 *  @param object the object to override with
 */
- (void) overrideKey:(NSString *)key withObject:(id)object;
@end
