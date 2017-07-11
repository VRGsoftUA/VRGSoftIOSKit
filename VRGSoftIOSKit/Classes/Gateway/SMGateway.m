//
//  SMGateway.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 12.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMGateway.h"
#import "SMKitDefines.h"
#import <AFNetworking/AFHTTPSessionManager.h>

typedef void (^SMGatewayMultipartFormCallback) (id<AFMultipartFormData> aFormData);

@implementation SMGateway

@synthesize httpClient;


#pragma mark - Init/Dealloc

- (void)dealloc
{
    SMDeallocLog;
}

#pragma mark - Internet reachability

- (BOOL)isInternetReachable
{
    return [[SMGatewayConfigurator sharedInstance] isInternetReachable];
}

#pragma mark - Configuration

- (void)configureWithBaseURL:(NSURL*)aBaseURL
{
    NSParameterAssert(aBaseURL);
    Class httpClientClass = [self defaultHTTPClientClass];
    httpClient = [[httpClientClass alloc] initWithBaseURL:aBaseURL];
    defaultParameters = [NSMutableDictionary new];
    requests = [NSMutableArray new];
}

#pragma mark - Request generation

- (SMGatewayRequest*)requestForClass:(Class)aRequestClass
                            withType:(NSString*)aType
                                path:(NSString*)aPath
                          parameters:(NSDictionary*)aParameters
{
    SMGatewayRequest* request = [[aRequestClass alloc] initWithGateway:self];
    request.type = aType;
    request.path = aPath;
    
    if(defaultParameters.count)
    {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithDictionary:defaultParameters];
        [aParameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
         {
             [parameters setObject:obj forKey:key];
         }];
        request.parameters = parameters;
    }
    else
    {
        request.parameters = aParameters;
    }
    
    return request;
}

- (SMGatewayRequest*)requestWithType:(NSString*)aType
                                path:(NSString*)aPath
                          parameters:(NSDictionary*)aParameters
{
    return [self requestForClass:[self defaultRequestClass] withType:aType path:aPath parameters:aParameters];
}

- (SMGatewayRequest*)requestWithType:(NSString*)aType
                                path:(NSString*)aPath
                          parameters:(NSDictionary*)aParameters
                        successBlock:(SMGatewayRequestSuccessBlock)aSuccessBlock
                       dispatchQueue:(dispatch_queue_t)aDispatchQueue
{
    SMGatewayRequest* request = [self requestWithType:aType path:aPath parameters:aParameters];
    SMGatewayRequestFailureBlock failureBlock = [self defaultFailureBlockForRequest:request];
    [request setupSuccessBlock:aSuccessBlock failureBlock:failureBlock dispatchQueue:aDispatchQueue];
    return request;
}

- (SMGatewayRequest*)requestWithURLRequest:(NSURLRequest*)anURLRequest
                              successBlock:(SMGatewayRequestSuccessBlock)aSuccessBlock
                             dispatchQueue:(dispatch_queue_t)aDispatchQueue
{
    SMGatewayRequest* request = [[[self defaultRequestClass] alloc] initWithGateway:self preparedURLRequest:anURLRequest];
    SMGatewayRequestFailureBlock failureBlock = [self defaultFailureBlockForRequest:request];
    [request setupSuccessBlock:aSuccessBlock failureBlock:failureBlock dispatchQueue:aDispatchQueue];
    return request;
}

- (SMGatewayRequestMultipart*)multipartRequestWithType:(NSString*)aType
                                                  path:(NSString*)aPath
                                            parameters:(NSDictionary*)aParameters
                                          successBlock:(SMGatewayRequestSuccessBlock)aSuccessBlock
                                         dispatchQueue:(dispatch_queue_t)aDispatchQueue;
{
    SMGatewayRequestMultipart* request = (SMGatewayRequestMultipart*)[self requestForClass:[SMGatewayRequestMultipart class]
                                                                                  withType:aType
                                                                                      path:aPath
                                                                                parameters:aParameters];
    SMGatewayRequestFailureBlock failureBlock = [self defaultFailureBlockForRequest:request];
    [request setupSuccessBlock:aSuccessBlock failureBlock:failureBlock dispatchQueue:aDispatchQueue];
    return request;
}


#pragma mark - Operation

- (NSURLSessionTask*)operationFromRequest:(SMGatewayRequest*)aRequest
{
    NSURLSessionTask *dataTask = [aRequest dataTask];
    
    return dataTask;
}


#pragma mark - Execute

- (NSURLSessionTask*)startRequest:(SMGatewayRequest*)aRequest
{
    NSURLSessionTask* operation = [self operationFromRequest:aRequest];
    [operation resume];
    
    [self retainRequest:aRequest];
    return operation;
}

- (void)cancelAllRequests
{
    [httpClient.operationQueue cancelAllOperations];
}


#pragma mark - Defaults

- (Class)defaultHTTPClientClass
{
    return [AFHTTPSessionManager class];
}

- (Class)defaultRequestClass
{
    return [SMGatewayRequest class];
}

- (SMGatewayRequestFailureBlock)defaultFailureBlockForRequest:(SMGatewayRequest*)aRequest
{
    SMGatewayRequestFailureBlock block = ^(NSURLSessionTask *task, NSError *error)
    {
        SMResponse* response = [SMResponse new];
        response.error = error;
        response.code = error.code;
        response.requestCancelled = (task.state == NSURLSessionTaskStateCanceling);
        return response;
    };
    return block;
}

- (void)addDefaultParameterValue:(NSString*)aValue forParameter:(NSString*)aParameter
{
    [defaultParameters setObject:aValue forKey:aParameter];
}

- (void)clearAllDefaultParameters
{
    [defaultParameters removeAllObjects];
}


#pragma mark - Retain-Release Requests

- (void)retainRequest:(SMGatewayRequest *)aRequest
{
    if (aRequest)
    {
        [requests addObject:aRequest];
    }
}

- (void)releaseRequest:(SMGatewayRequest *)aRequest
{
    if (aRequest)
    {
        [requests removeObject:aRequest];
    }
}

@end
