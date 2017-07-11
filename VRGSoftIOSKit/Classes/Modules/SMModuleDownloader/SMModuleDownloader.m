//
//  SMModuleDownloader.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 15.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMModuleDownloader.h"
#import "SMKitDefines.h"

@interface SMModuleDownloader ()

- (void)startTaskAtIndex:(NSUInteger)anIndex;

- (void)informDelegateAboutCompleteWithSuccess:(BOOL)aSuccess;
- (void)informDelegateAboutStartTask:(SMDownloaderTask*)aTask atIndex:(NSUInteger)anIndex;
- (void)informDelegateAboutCompleteTask:(SMDownloaderTask*)aTask withSuccess:(BOOL)aSuccess;

@end

@implementation SMModuleDownloader

@synthesize downloading;

#pragma mark - Init/Dealloc

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        tasks = [NSMutableArray new];
        downloaderQueue = dispatch_queue_create("com.caiguda.SMModuleDownloader", NULL);
        queueTag = &queueTag;
        dispatch_queue_set_specific(downloaderQueue, queueTag, queueTag, NULL);
    }
    return self;
}

- (void)dealloc
{
#if SM_NEEDS_DISPATCH_RETAIN_RELEASE
    if (downloaderQueue)
        dispatch_release(downloaderQueue);
#endif
    downloaderQueue = NULL;
}

- (void)addTask:(SMDownloaderTask*)aTask
{
    NSParameterAssert(aTask);
    
    dispatch_async(downloaderQueue, ^
    {
        [tasks addObject:aTask];
        [aTask setDelegate:self withDispatchQueue:downloaderQueue];
    });
}

- (NSUInteger)taskCount
{
    return [tasks count];
}

- (void)start
{
	NSAssert(!dispatch_get_specific(queueTag), @"SMModuleDownloader: Invoked on incorrect queue");
    NSAssert(self.delegate, @"SMModuleDownloader: setup delegate");
    
    originalIdleTimerDisabled = [UIApplication sharedApplication].idleTimerDisabled;
    [UIApplication sharedApplication].idleTimerDisabled = self.disableScreenLockDuringDownloading;

    dispatch_async(downloaderQueue, ^
    {
        if(tasks.count)
        {
            currentTaskIndex = 0;
            [self startTaskAtIndex:currentTaskIndex];
            downloading = YES;
        }
        else
            [self informDelegateAboutCompleteWithSuccess:NO];
    });
}

- (void)cancel
{
    void(^cancelBlock)(void) = ^(void)
    {
        for(SMDownloaderTask* task in tasks)
            [task cancel];
        currentTaskIndex = 0;
        downloading = NO;
    };
    if(dispatch_get_specific(queueTag))
        cancelBlock();
    else
        dispatch_async(downloaderQueue, cancelBlock);
}

- (void)startTaskAtIndex:(NSUInteger)anIndex
{
	NSAssert(dispatch_get_specific(queueTag), @"SMModuleDownloader: Invoked on incorrect queue");
    
    SMDownloaderTask* task = [tasks objectAtIndex:currentTaskIndex];
    [task start];
    [self informDelegateAboutStartTask:task atIndex:anIndex];
}

#pragma mark - Inform delegate

- (void)informDelegateAboutCompleteWithSuccess:(BOOL)aSuccess
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [UIApplication sharedApplication].idleTimerDisabled = originalIdleTimerDisabled;

        if([self.delegate respondsToSelector:@selector(downloader:didCompleteWithResult:)])
            [self.delegate downloader:self didCompleteWithResult:aSuccess];
    });
}

- (void)informDelegateAboutStartTask:(SMDownloaderTask*)aTask atIndex:(NSUInteger)anIndex
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        if([self.delegate respondsToSelector:@selector(downloader: didStartTask:atIndex:)])
            [self.delegate downloader:self didStartTask:aTask atIndex:anIndex];
    });
}

- (void)informDelegateAboutCompleteTask:(SMDownloaderTask*)aTask withSuccess:(BOOL)aSuccess
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        if([self.delegate respondsToSelector:@selector(downloader:didCompleteTask:withSuccess:)])
            [self.delegate downloader:self didCompleteTask:aTask withSuccess:aSuccess];
    });
}

#pragma mark - SMDownloaderTaskDelegate

- (void)task:(SMDownloaderTask*)aTask downloadProgress:(NSProgress *)aProgress
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        if([self.delegate respondsToSelector:@selector(downloader:task:progress:)])
            [self.delegate downloader:self task:aTask progress:aProgress];
    });
}

- (void)task:(SMDownloaderTask*)aTask completeWithSuccess:(BOOL)aSuccess
{
    [self informDelegateAboutCompleteTask:aTask withSuccess:aSuccess];

    if(!aSuccess && !_continueIfTaskFailed)
    {
        [self cancel];
        [self informDelegateAboutCompleteWithSuccess:NO];
        return;
    }

    ++currentTaskIndex;
    if(currentTaskIndex < tasks.count)
    {
        [self startTaskAtIndex:currentTaskIndex];
    }
    else
    {
        downloading = NO;

        BOOL result = YES;
        for(SMDownloaderTask* task in tasks)
            result &= task.completedSuccess;
        [self informDelegateAboutCompleteWithSuccess:result];
    }

}

@end
