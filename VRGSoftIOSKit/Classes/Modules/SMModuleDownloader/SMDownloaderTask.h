//
//  SMDownloaderTask.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 24.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SMDownloaderTaskDelegate;

/**
 * DAL
 * Downloader task - use for process unit of download work.
 **/
@interface SMDownloaderTask : NSObject
{
    dispatch_queue_t taskQueue;

    dispatch_queue_t delegateQueue;
    
    __weak id<SMDownloaderTaskDelegate> delegate;
    BOOL completedSuccess;
}

@property (nonatomic, strong) NSString* identifier;
@property (nonatomic, readonly) BOOL completedSuccess;

@property (nonatomic, readonly) dispatch_queue_t delegateQueue;

- (void)setDelegate:(id<SMDownloaderTaskDelegate>)aDelegate withDispatchQueue:(dispatch_queue_t)aDispatchQueue;

- (void)start;
- (void)cancel;

@end

/**
 * Use only for SMModuleDownloader
 **/
@protocol SMDownloaderTaskDelegate <NSObject>

- (void)task:(SMDownloaderTask*)aTask downloadProgress:(NSProgress *)aProgress;
- (void)task:(SMDownloaderTask*)aTask completeWithSuccess:(BOOL)aSuccess;

@end
