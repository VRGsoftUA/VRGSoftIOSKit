//
//  SMDownloaderTaskWithBlock.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 24.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMDownloaderTaskWithBlock.h"

@implementation SMDownloaderTaskWithBlock

- (void)start
{
    __weak __typeof(&*self) weakself = self;
    self.block(weakself);
}

- (void)taskCompleteWithSuccess:(BOOL)aSuccess
{
    completedSuccess = aSuccess;
    dispatch_async(delegateQueue, ^
    {
       [delegate task:self completeWithSuccess:aSuccess];
    });
}

@end
