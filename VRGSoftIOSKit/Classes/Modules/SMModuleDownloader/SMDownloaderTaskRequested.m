//
//  SMDownloaderTaskRequested.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 24.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMDownloaderTaskRequested.h"

@interface SMDownloaderTaskRequested ()

- (void)informDelegateAboutDownloadProgress:(NSProgress *)aProgress;
- (void)informDelegateAboutCompleteWithSuccess:(BOOL)aSuccess;

@end


@implementation SMDownloaderTaskRequested

@synthesize request;

- (instancetype)initWithRequest:(SMGatewayRequest*)aRequest
{
    self = [super init];
    if(self)
    {
        request = aRequest;
        
        __weak SMDownloaderTaskRequested* __self = self;
        [request addDownloadProgressBlock:^(SMGatewayRequest *request, NSProgress *progress)
        {
            [__self informDelegateAboutDownloadProgress:progress];
            
        } dispatchQueue:taskQueue];
        
        [request addResponseBlock:^(SMResponse *aResponse)
        {
            [__self requestCompleteWithResponse:aResponse];
            [__self informDelegateAboutCompleteWithSuccess:aResponse.success];
            
        } responseQueue:taskQueue];
    }
    return self;
}

- (void)dealloc
{
    [request cancel];
}

- (void)requestCompleteWithResponse:(SMResponse*)aResponse
{
    // override it
}

- (void)start
{
    [request start];
}

- (void)cancel
{
    [request cancel];
}

- (void)informDelegateAboutDownloadProgress:(NSProgress *)aProgress
{
    dispatch_async(delegateQueue, ^
    {
        [delegate task:self downloadProgress:aProgress];
    });
}

- (void)informDelegateAboutCompleteWithSuccess:(BOOL)aSuccess
{
    completedSuccess = aSuccess;
    dispatch_async(delegateQueue, ^
    {
        [delegate task:self completeWithSuccess:aSuccess];
    });
}

@end
