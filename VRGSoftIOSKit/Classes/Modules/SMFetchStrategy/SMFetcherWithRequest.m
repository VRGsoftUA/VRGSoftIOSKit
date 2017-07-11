//
//  SMFetcherWithRequest.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 16.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMFetcherWithRequest.h"

@implementation SMFetcherWithRequest

@synthesize request;
@synthesize fetchCallback;
@synthesize callbackQueue;

- (void)dealloc
{
    self.callbackQueue = NULL;
}

#if SM_NEEDS_DISPATCH_RETAIN_RELEASE
- (void)setCallbackQueue:(dispatch_queue_t)aCallbackQueue
{
    if (callbackQueue != aCallbackQueue)
    {
        if (callbackQueue)
        {
            dispatch_release(callbackQueue);
            callbackQueue = NULL;
        }
        
        if (aCallbackQueue)
        {
            dispatch_retain(aCallbackQueue);
            callbackQueue = aCallbackQueue;
        }
    }
}
#endif

#pragma mark - Request

- (SMRequest*)preparedRequestByMessage:(SMFetcherMessage*)aMessage;
{
    NSAssert(NO, @"Override this method!");
    return nil;
}

- (void)setRequest:(SMRequest *)aRequest
{
    NSAssert(self.callbackQueue, @"SMFetcherWithRequest: callbackQueue is nil! Setup callbackQueue before setup request.");
    
    if(request != aRequest)
    {
        [self cancelFetching];
        request = aRequest;
        __weak SMFetcherWithRequest* __self = self;
        [request addResponseBlock:^(SMResponse *aResponse)
         {
             aResponse.boArray = [__self processFetchedModelsInResponse:aResponse];;
             
             if (__self.fetchCallback)
                 __self.fetchCallback(aResponse);
         } responseQueue:self.callbackQueue];
    }
}

- (BOOL)canFetchWithMessage:(SMFetcherMessage *)aMessage
{
    if(!preparedRequest)
        preparedRequest = [self preparedRequestByMessage:aMessage];
    
    return [preparedRequest canExecute];
}

- (void)fetchDataByMessage:(SMFetcherMessage*)aMessage
              withCallback:(SMDataFetchCallback)aFetchCallback
{
    fetchCallback = aFetchCallback;
    
    if(!preparedRequest)
        preparedRequest = [self preparedRequestByMessage:aMessage];
    
    self.request = preparedRequest;
    preparedRequest = nil;
    
    [request start];
}

- (NSMutableArray*)processFetchedModelsInResponse:(SMResponse *)aResponse
{
    return aResponse.boArray;
}

- (void)cancelFetching
{
    [request cancel];
}

@end
