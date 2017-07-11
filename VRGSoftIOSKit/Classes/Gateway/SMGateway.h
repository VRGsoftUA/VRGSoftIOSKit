//
//  SMGateway.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 12.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMGatewayRequest.h"
#import "SMGatewayRequestMultipart.h"
#import "SMGatewayConfigurator.h"
#import "SMResponse.h"

@class AFHTTPSessionManager;

@interface AFHTTPSessionManager()
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;
@end


@interface SMGateway : NSObject
{
    AFHTTPSessionManager* httpClient;
    NSMutableDictionary* defaultParameters;
    NSMutableArray <SMGatewayRequest *> *requests;
}

@property (nonatomic, readonly) AFHTTPSessionManager* httpClient;
@property (nonatomic, assign) BOOL disableRegisterInGatewayConfigurator;

#pragma mark - Internet reachability
- (BOOL)isInternetReachable;

#pragma mark - Configuration
- (void)configureWithBaseURL:(NSURL*)aBaseURL;

#pragma mark - Request generation
- (SMGatewayRequest*)requestForClass:(Class)aRequestClass
                            withType:(NSString*)aType
                                path:(NSString*)aPath
                          parameters:(NSDictionary*)aParameters;

- (SMGatewayRequest*)requestWithType:(NSString*)aType
                                path:(NSString*)aPath
                          parameters:(NSDictionary*)aParameters;

- (SMGatewayRequest*)requestWithType:(NSString*)aType
                                path:(NSString*)aPath
                          parameters:(NSDictionary*)aParameters
                        successBlock:(SMGatewayRequestSuccessBlock)aSuccessBlock
                       dispatchQueue:(dispatch_queue_t)aDispatchQueue;

- (SMGatewayRequest*)requestWithURLRequest:(NSURLRequest*)anURLRequest
                              successBlock:(SMGatewayRequestSuccessBlock)aSuccessBlock
                             dispatchQueue:(dispatch_queue_t)aDispatchQueue;

- (SMGatewayRequestMultipart*)multipartRequestWithType:(NSString*)aType
                                                  path:(NSString*)aPath
                                            parameters:(NSDictionary*)aParameters
                                          successBlock:(SMGatewayRequestSuccessBlock)aSuccessBlock
                                         dispatchQueue:(dispatch_queue_t)aDispatchQueue;


- (NSURLSessionTask*)operationFromRequest:(SMGatewayRequest*)aRequest;

#pragma mark - Execute
- (NSURLSessionTask*)startRequest:(SMGatewayRequest*)aRequest;
- (void)cancelAllRequests;

#pragma mark - Defaults
- (Class)defaultHTTPClientClass;
- (Class)defaultRequestClass;
- (SMGatewayRequestFailureBlock)defaultFailureBlockForRequest:(SMGatewayRequest*)aRequest;
- (void)addDefaultParameterValue:(NSString*)aValue forParameter:(NSString*)aParameter;
- (void)clearAllDefaultParameters;

#pragma mark - Retain-Release Requests
- (void)retainRequest:(SMGatewayRequest *)aRequest;
- (void)releaseRequest:(SMGatewayRequest *)aRequest;

@end
