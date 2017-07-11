//
//  SMDownloaderTask.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 24.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMDownloaderTask.h"
#import "SMKitDefines.h"

@interface SMDownloaderTask ()

#if SM_NEEDS_DISPATCH_RETAIN_RELEASE
    @property (nonatomic, assign) dispatch_queue_t delegateQueue;
#else
    @property (nonatomic, strong) dispatch_queue_t delegateQueue;
#endif

@end

@implementation SMDownloaderTask

@synthesize completedSuccess, delegateQueue;

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        taskQueue = dispatch_queue_create("com.caiguda.SMDownloaderTaskQueue", NULL);
    }
    return self;
}

- (void)dealloc
{
    self.delegateQueue = NULL;
    
#if SM_NEEDS_DISPATCH_RETAIN_RELEASE
    if (taskQueue)
        dispatch_release(taskQueue);
#endif
    taskQueue = NULL;
}

- (void)setDelegate:(id<SMDownloaderTaskDelegate>)aDelegate withDispatchQueue:(dispatch_queue_t)aDispatchQueue
{
    NSParameterAssert(aDelegate);
    NSParameterAssert(aDispatchQueue);
    
    delegate = aDelegate;
    self.delegateQueue = aDispatchQueue;
}

#if SM_NEEDS_DISPATCH_RETAIN_RELEASE
- (void)setDelegateQueue:(dispatch_queue_t)aDelegateQueue
{
    if (delegateQueue != aDelegateQueue)
    {
        if (delegateQueue)
        {
            dispatch_release(delegateQueue);
            delegateQueue = NULL;
        }
        
        if (aDelegateQueue)
        {
            dispatch_retain(aDelegateQueue);
            delegateQueue = aDelegateQueue;
        }
    }
}
#endif

- (void)start
{
    // override it
}

- (void)cancel
{
    // override it
}
@end
