//
//  SMGatewayRequestMultipart.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 24.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMGatewayRequestMultipart.h"
#import "SMGateway.h"

@implementation SMGatewayRequestMultipart

#pragma mark - Init

- (instancetype)initWithGateway:(SMGateway*)aGateway
{
    self = [super initWithGateway:aGateway];
    if(self)
    {
        constructingBlocks = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithGateway:(SMGateway *)aGateway preparedURLRequest:(NSURLRequest *)anURLRequest
{
    NSAssert(NO, @"This initialization method cannot be used in multipart request");
    return nil;
}

#pragma mark - Multipart

- (void)addConstructingMultipartFormDataBlock:(SMConstructingMultipartFormDataBlock)block
{
    [constructingBlocks addObject:[block copy]];
}

#pragma mark - Prepare request

- (NSMutableURLRequest*)urlRequest
{
    SMWeakSelf;
    
    NSError *serializationError = nil;
    NSMutableURLRequest *urlRequest = (preparedURLRequest) ? [preparedURLRequest mutableCopy] : [gateway.httpClient.requestSerializer multipartFormRequestWithMethod:self.type URLString:[[NSURL URLWithString:self.path relativeToURL:gateway.httpClient.baseURL] absoluteString] parameters:self.parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
                                                                                                 {
                                                                                                     SMStrongSelf;
                                                                                                     
                                                                                                     if (strongSelf)
                                                                                                     {
                                                                                                         for (SMConstructingMultipartFormDataBlock block in strongSelf->constructingBlocks)
                                                                                                         {
                                                                                                             block((id<SMMultipartFormData>)formData);
                                                                                                         }
                                                                                                     }
                                                                                                     
                                                                                                 } error:&serializationError];
    
    if (serializationError) {
        
        
        if (self.failureBlock)
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(gateway.httpClient.completionQueue ?: dispatch_get_main_queue(), ^{
                weakSelf.failureBlock(nil,serializationError);
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
    
    __block NSURLSessionTask *dataTask = [gateway.httpClient uploadTaskWithStreamedRequest:self.urlRequest progress:^(NSProgress * _Nonnull uploadProgress) {
        
        [weakSelf executeAllUploadProgressBlocksWith:uploadProgress];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
            if(!(dataTask.state == NSURLSessionTaskStateCanceling))
                SMLog(@"\nSMGateway request failed with error:\n%@\n", error);
            [weakSelf executeFailureBlockWithOperation:dataTask error:error];
        } else {
            [weakSelf executeSuccessBlockWithOperation:dataTask responseObject:responseObject];
        }
    }];
    
    return dataTask;
}

@end
