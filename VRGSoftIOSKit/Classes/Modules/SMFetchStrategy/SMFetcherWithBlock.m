//
//  SMFetcherWithBlock.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 16.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMFetcherWithBlock.h"

@implementation SMFetcherWithBlock

@synthesize callbackQueue;

- (instancetype)initWithFetchBlock:(SMDataFetchBlock)aFetchBlock
{
    self = [super init];
    if(self)
    {
        self.fetchBlock = aFetchBlock;
    }
    return self;
}

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

- (BOOL)canFetchWithMessage:(SMFetcherMessage *)aMessage
{
    return self.fetchBlock != nil;
}

- (void)fetchDataByMessage:(SMFetcherMessage*)aMessage
              withCallback:(SMDataFetchCallback)aFetchCallback
{
    NSAssert(self.callbackQueue, @"SMFetcherWithBlock: callbackQueue is nil!");
    
    dispatch_async(self.callbackQueue, ^
    {
        self.fetchBlock(aMessage, aFetchCallback);
    });
}

- (void)cancelFetching
{
}

@end
