//
//  SMGatewayRequest.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 12.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMGatewayRequest.h"
#import "SMGateway.h"
#import "SMQueueNode.h"

@interface SMRequestProgressNode : SMQueueNode

@property (nonatomic, copy) SMGatewayRequestProgressBlock block;

@end


@implementation SMGatewayRequest

@synthesize path, type, parameters;
@synthesize successBlock, failureBlock;


#pragma mark - Init/Dealloc

- (instancetype)init
{
    NSAssert(NO, @"SMGatewayRequest - Don't use init method!, please use initWithGateway method.");
    return nil;
}

- (instancetype)initWithGateway:(SMGateway*)aGateway
{
    self = [super init];
    if (self)
    {
        gateway = aGateway;
        
        uploadProgressBlocks = [NSMutableArray new];
        downloadProgressBlocks = [NSMutableArray new];
        
        headers = [NSMutableDictionary new];
    }
    return self;
}

- (instancetype)initWithGateway:(SMGateway *)aGateway preparedURLRequest:(NSURLRequest *)anURLRequest
{
    self = [self initWithGateway:aGateway];
    if (self)
    {
        preparedURLRequest = anURLRequest;
    }
    return self;
}

- (void)dealloc
{
    self.successFailureDispatchQueue = NULL;
}

#if SM_NEEDS_DISPATCH_RETAIN_RELEASE
- (void)setSuccessFailureDispatchQueue:(dispatch_queue_t)successFailureDispatchQueue
{
    if (_successFailureDispatchQueue != successFailureDispatchQueue)
    {
        if (_successFailureDispatchQueue)
        {
            dispatch_release(_successFailureDispatchQueue);
            _successFailureDispatchQueue = NULL;
        }
        
        if (successFailureDispatchQueue)
        {
            dispatch_retain(successFailureDispatchQueue);
            _successFailureDispatchQueue = successFailureDispatchQueue;
        }
    }
}
#endif

#pragma mark - Internet reachability

- (BOOL)isInternetReachable
{
    return [gateway isInternetReachable];
}


#pragma mark - Request execute

- (BOOL)canExecute
{
    return [self isInternetReachable];
}

- (void)start
{
    operation = [gateway startRequest:self];
    SMLog(@"\nSMGatewayRequest start operation:\n%@ \nWith\nurl: %@\ntype: %@\npath: %@\nparams: %@ \nWith headers: %@", operation, operation.originalRequest.URL,self.type, path, parameters, operation.originalRequest.allHTTPHeaderFields);
}

- (BOOL)isExecuting
{
    return (operation.state == NSURLSessionTaskStateRunning);
}

- (void)cancel
{
    [operation cancel];
}

- (BOOL)isCancelled
{
    return (operation.state == NSURLSessionTaskStateCanceling);
}

- (BOOL)isFinished
{
    return (operation.state == NSURLSessionTaskStateCompleted);
}


#pragma mark - Configure request callbacks

- (void)setupSuccessBlock:(SMGatewayRequestSuccessBlock)aSuccessBlock
             failureBlock:(SMGatewayRequestFailureBlock)aFailureBlock
            dispatchQueue:(dispatch_queue_t)aDispatchQueue
{
    NSParameterAssert(aDispatchQueue);
    
    successBlock = [aSuccessBlock copy];
    failureBlock = [aFailureBlock copy];
    self.successFailureDispatchQueue = aDispatchQueue;
}

- (void)addUploadProgressBlock:(SMGatewayRequestProgressBlock)anProgressBlock
                 dispatchQueue:(dispatch_queue_t)aDispatchQueue
{
    NSParameterAssert(anProgressBlock);
    NSParameterAssert(aDispatchQueue);
    
    SMRequestProgressNode* node = [SMRequestProgressNode new];
    node.block = anProgressBlock;
    node.dispatchQueue = aDispatchQueue;
    [uploadProgressBlocks addObject:node];
}

- (void)addDownloadProgressBlock:(SMGatewayRequestProgressBlock)anProgressBlock
                   dispatchQueue:(dispatch_queue_t)aDispatchQueue
{
    NSParameterAssert(anProgressBlock);
    NSParameterAssert(aDispatchQueue);
    
    SMRequestProgressNode* node = [SMRequestProgressNode new];
    node.block = anProgressBlock;
    node.dispatchQueue = aDispatchQueue;
    [downloadProgressBlocks addObject:node];
}


#pragma mark - Execute Request callbacks

- (void)executeSuccessBlockWithOperation:(NSURLSessionTask*)anOperation responseObject:(id)aResponseObject
{
    if (successBlock)
    {
        if (self.successFailureDispatchQueue)
        {
            dispatch_async(self.successFailureDispatchQueue, ^
                           {
                               SMResponse* response = successBlock(anOperation, aResponseObject);
                               if(self.executeAllResponseBlocksSync)
                                   [self executeSynchronouslyAllResponseBlocksWithResponse:response];
                               else
                                   [self executeAllResponseBlocksWithResponse:response];
                           });
        }
    }
}

- (void)executeFailureBlockWithOperation:(NSURLSessionTask*)anOperation error:(NSError*)anError
{
    if (failureBlock)
    {
        if (self.successFailureDispatchQueue)
        {
            dispatch_async(self.successFailureDispatchQueue, ^
                           {
                               SMResponse* response = failureBlock(anOperation, anError);
                               if(self.executeAllResponseBlocksSync)
                                   [self executeSynchronouslyAllResponseBlocksWithResponse:response];
                               else
                                   [self executeAllResponseBlocksWithResponse:response];
                           });
        }
    }
}

- (void)executeAllUploadProgressBlocksWith:(NSProgress *)aProgress
{
    for(SMRequestProgressNode* node in uploadProgressBlocks)
    {
        if (node.dispatchQueue && node.block)
        {
            dispatch_async(node.dispatchQueue, ^
                           {
                               node.block(self, aProgress);
                           });
        }
    }
}

- (void)executeAllDownloadProgressBlocksWith:(NSProgress *)aProgress;
{
    for(SMRequestProgressNode* node in downloadProgressBlocks)
    {
        if (node.dispatchQueue && node.block)
        {
            dispatch_async(node.dispatchQueue, ^
                           {
                               node.block(self, aProgress);
                           });
        }
    }
}


#pragma mark - Headers

- (void)addValue:(NSString*)aHeaderValue forHeaderField:(NSString*)aHeaderField
{
    [headers setObject:aHeaderValue forKey:aHeaderField];
}

- (void)clearHeaders
{
    [headers removeAllObjects];
}


#pragma mark - Prepare request

- (NSMutableURLRequest*)urlRequest
{
    NSError *serializationError = nil;
    __block NSMutableURLRequest *urlRequest = (preparedURLRequest) ? [preparedURLRequest mutableCopy] : [gateway.httpClient.requestSerializer requestWithMethod:self.type URLString:[[NSURL URLWithString:self.path relativeToURL:gateway.httpClient.baseURL] absoluteString] parameters:self.parameters error:&serializationError];
    
    if (serializationError) {
        
        
        if (self.failureBlock)
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(gateway.httpClient.completionQueue ?: dispatch_get_main_queue(), ^{
                self.failureBlock(nil,serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         [urlRequest addValue:obj forHTTPHeaderField:key];
     }];
    
    return urlRequest;
}

- (NSURLSessionTask *)dataTask
{
    SMWeakSelf;
    __block NSURLSessionTask *dataTask = [gateway.httpClient dataTaskWithRequest:self.urlRequest uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
        [weakSelf executeAllUploadProgressBlocksWith:uploadProgress];
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
        [weakSelf executeAllDownloadProgressBlocksWith:downloadProgress];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if(!(dataTask.state == NSURLSessionTaskStateCanceling))
                SMLog(@"\nSMGateway request failed with error:\n%@\n", error);
            [weakSelf executeFailureBlockWithOperation:dataTask error:error];
        } else {
            [weakSelf executeSuccessBlockWithOperation:dataTask responseObject:responseObject];
        }
        SMStrongSelf;
        if (strongSelf)
        {
            [strongSelf->gateway releaseRequest:weakSelf];
        }
    }];
    
    return dataTask;
}


#pragma mark - I/O Stream

- (NSInputStream *)inputStream
{
    //    if (operation)
    //        return operation.inputStream;
    
    return _inputStream;
}

- (NSOutputStream *)outputStream
{
    //    if (operation)
    //        return operation.outputStream;
    
    return _outputStream;
}

@end



@implementation SMRequestProgressNode

@end

