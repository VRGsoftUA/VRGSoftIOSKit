//
//  SMDownloaderTaskWithBlock.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 24.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMDownloaderTask.h"
#import "SMResponse.h"

@class SMDownloaderTaskWithBlock;
typedef void (^SMDownloaderTaskBlock) (SMDownloaderTaskWithBlock* aTask);

/**
 * DAL
 * This block will execute in taskQueue (You must execute it only in queue taskQueue!).
 **/
@interface SMDownloaderTaskWithBlock : SMDownloaderTask

@property (nonatomic, copy) SMDownloaderTaskBlock block;

- (void)taskCompleteWithSuccess:(BOOL)aSuccess;

@end
