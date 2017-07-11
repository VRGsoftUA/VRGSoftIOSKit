//
//  SMGatewayRequest.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 12.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMRequest.h"
#import <AFNetworking/AFNetworking.h>

@class SMGatewayRequest;
@class SMGateway;

typedef SMResponse* (^SMGatewayRequestSuccessBlock) (NSURLSessionTask *task, id responseObject);
typedef SMResponse* (^SMGatewayRequestFailureBlock) (NSURLSessionTask *task, NSError *error);

typedef void (^SMGatewayRequestProgressBlock) (SMGatewayRequest* request, NSProgress *progress);


@interface SMGatewayRequest : SMRequest
{
    __weak SMGateway* gateway;
    __weak NSURLSessionTask* operation;
    
    NSMutableArray* uploadProgressBlocks;
    NSMutableArray* downloadProgressBlocks;
    
    NSMutableDictionary* headers;
    
    NSURLRequest *preparedURLRequest;
}

@property (nonatomic, strong) NSString* path;
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSDictionary* parameters;

@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, strong) NSOutputStream *outputStream;

@property (nonatomic, readonly) SMGatewayRequestSuccessBlock successBlock;
@property (nonatomic, readonly) SMGatewayRequestFailureBlock failureBlock;

#if SM_NEEDS_DISPATCH_RETAIN_RELEASE
@property (nonatomic, assign) dispatch_queue_t successFailureDispatchQueue;
#else
@property (nonatomic, strong) dispatch_queue_t successFailureDispatchQueue;
#endif

#pragma mark - Init/Dealloc (for Gateway)
- (instancetype)initWithGateway:(SMGateway*)aGateway;
- (instancetype)initWithGateway:(SMGateway*)aGateway preparedURLRequest:(NSURLRequest*)anURLRequest;

#pragma mark - Internet reachability
- (BOOL)isInternetReachable;

#pragma mark - Headers
- (void)addValue:(NSString*)aHeaderValue forHeaderField:(NSString*)aHeaderField;
- (void)clearHeaders;

#pragma mark - Prepare request
- (NSMutableURLRequest*)urlRequest;

#pragma mark - Prepare dataTask
- (NSURLSessionTask *)dataTask;

#pragma mark - Configure request callbacks (for Gateway)
- (void)setupSuccessBlock:(SMGatewayRequestSuccessBlock)aSuccessBlock
             failureBlock:(SMGatewayRequestFailureBlock)aFailureBlock
            dispatchQueue:(dispatch_queue_t)aDispatchQueue;

- (void)addUploadProgressBlock:(SMGatewayRequestProgressBlock)anProgressBlock
                 dispatchQueue:(dispatch_queue_t)aDispatchQueue;

- (void)addDownloadProgressBlock:(SMGatewayRequestProgressBlock)anProgressBlock
                   dispatchQueue:(dispatch_queue_t)aDispatchQueue;


#pragma mark - Execute request callbacks (for Gateway)
- (void)executeSuccessBlockWithOperation:(NSURLSessionTask*)anOperation responseObject:(id)aResponseObject;
- (void)executeFailureBlockWithOperation:(NSURLSessionTask*)anOperation error:(NSError*)anError;

- (void)executeAllUploadProgressBlocksWith:(NSProgress *)aProgress;
- (void)executeAllDownloadProgressBlocksWith:(NSProgress *)aProgress;

@end
