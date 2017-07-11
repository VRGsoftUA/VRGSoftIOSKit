//
//  SMGatewayConfigurator.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 24.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMSingleton.h"

@class SMGateway;
@class AFNetworkReachabilityManager;

@interface SMGatewayConfigurator : NSObject
{
    NSMutableArray* gateways;
    AFNetworkReachabilityManager* reachability;
}

SM_DECLARE_SINGLETON;

#pragma mark - Gateway registration/configuration
- (void)registerGateway:(SMGateway*)aGateway;
- (void)configureGatewaysWithBaseURL:(NSURL*)aBaseURL;

#pragma mark - Internet reachability
- (BOOL)isInternetReachable;

#pragma mark - Http headers
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;
- (void)setAuthorizationHeaderFieldWithUsername:(NSString *)username
                                       password:(NSString *)password;
- (void)clearAuthorizationHeader;

- (void)setValue:(NSString *)value forHTTPAdditionalHeader:(NSString *)field;
- (void)removeHTTPAdditionalHeaders:(NSString *)field;

@end
