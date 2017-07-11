//
//  SMGatewayConfigurator.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 24.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMGatewayConfigurator.h"
#import "SMGateway.h"
#import <objc/runtime.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

//Huck
@interface AFURLSessionManager ()

- (NSURLSession *)session;

@end

@implementation SMGatewayConfigurator

SM_IMPLEMENT_SINGLETON;

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        
        gateways = [NSMutableArray new];
        reachability = [AFNetworkReachabilityManager sharedManager];
        [reachability startMonitoring];
        
        int classesCount = objc_getClassList(NULL, 0);
        Class* classes;
        
        if(classesCount > 0)
        {
            classes = (__unsafe_unretained Class*)malloc(sizeof(Class) * classesCount);
            objc_getClassList(classes, classesCount);
            
            Class cls;
            Class subCls;
            NSMutableArray* filteredClasses = [NSMutableArray array];
            for(int i = 0; i < classesCount; ++i)
            {
                cls = classes[i];
                subCls = cls;
                do
                {
                    subCls = class_getSuperclass(subCls);
                    if(subCls == [SMGateway class] && class_getClassMethod(cls, @selector(sharedInstance)))
                    {
                        [filteredClasses addObject:NSStringFromClass(cls)];
                        break;
                    }
                } while (subCls);
            }
            free(classes);
            
            SMGateway* gateway;
            for(NSString* className in filteredClasses)
            {
                cls = NSClassFromString(className);
                gateway = (SMGateway*)[cls sharedInstance];
                [self registerGateway:gateway];
            }
        }
        
    }
    return self;
}

#pragma mark - Gateway registration/configuration

- (void)registerGateway:(SMGateway*)aGateway
{
    NSParameterAssert(aGateway);
    if(!aGateway.disableRegisterInGatewayConfigurator)
        [gateways addObject:aGateway];
}

- (void)configureGatewaysWithBaseURL:(NSURL*)aBaseURL
{
    NSParameterAssert(aBaseURL);
    for(SMGateway* gateway in gateways)
        [gateway configureWithBaseURL:aBaseURL];
}


#pragma mark - Internet reachability

- (BOOL)isInternetReachable
{
    return [reachability isReachable];
}


#pragma mark - Http headers

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field
{
    for (SMGateway *g in gateways)
    {
        [g.httpClient.requestSerializer setValue:value forHTTPHeaderField:field];
    }
}

- (void)setAuthorizationHeaderFieldWithUsername:(NSString *)username
                                       password:(NSString *)password
{
    for (SMGateway *g in gateways)
    {
        [g.httpClient.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
    }
}

- (void)clearAuthorizationHeader
{
    for (SMGateway *g in gateways)
    {
        [g.httpClient.requestSerializer clearAuthorizationHeader];
    }
}

- (void)setValue:(NSString *)value forHTTPAdditionalHeader:(NSString *)field
{
    for (SMGateway *g in gateways)
    {
        NSDictionary *oldHeaders = g.httpClient.session.configuration.HTTPAdditionalHeaders;
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:oldHeaders];
        [headers setObject:value forKey:field];
        g.httpClient.session.configuration.HTTPAdditionalHeaders = headers;
    }
}

- (void)removeHTTPAdditionalHeaders:(NSString *)field
{
    for (SMGateway *g in gateways)
    {
        NSDictionary *oldHeaders = g.httpClient.session.configuration.HTTPAdditionalHeaders;
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:oldHeaders];
        [headers removeObjectForKey:field];
        g.httpClient.session.configuration.HTTPAdditionalHeaders = headers;
    }
}

@end
