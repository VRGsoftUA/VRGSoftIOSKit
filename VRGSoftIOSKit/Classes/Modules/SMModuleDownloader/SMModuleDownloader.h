//
//  SMModuleDownloader.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 15.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMDownloaderTask.h"

@protocol SMModuleDownloaderDelegate;

/**
 * DAL
 * Use this module to manage downloading any data from server into your app.
 **/
@interface SMModuleDownloader : NSObject <SMDownloaderTaskDelegate>
{
    dispatch_queue_t downloaderQueue;
    void* queueTag;
    NSMutableArray* tasks;
    NSUInteger currentTaskIndex;
    BOOL originalIdleTimerDisabled;
}

/**
 * All delegate methods call in main queue
 **/
@property (nonatomic, weak) id<SMModuleDownloaderDelegate> delegate;

/**
 * Is downloading now?
 **/
@property (nonatomic, readonly) BOOL downloading;

/**
 * If you want to continue download process even if some task was failed, setup this property to YES.
 * NO by default.
 **/
@property (nonatomic, assign) BOOL continueIfTaskFailed;

/**
 * Use this field to prevent lock screen during loading. After complete downloading previous value of 'idleTimerDisabled' will be restored.
 **/
@property (nonatomic, assign) BOOL disableScreenLockDuringDownloading;

- (void)addTask:(SMDownloaderTask*)aTask;
- (NSUInteger)taskCount;

- (void)start;
- (void)cancel;

@end


@protocol SMModuleDownloaderDelegate <NSObject>

@optional

- (void)downloader:(SMModuleDownloader*)aDownloader
              task:(SMDownloaderTask*)aTask
          progress:(NSProgress *)aProgress;

- (void)downloader:(SMModuleDownloader*)aDownloader didStartTask:(SMDownloaderTask*)aTask atIndex:(NSUInteger)anIndex;
- (void)downloader:(SMModuleDownloader*)aDownloader didCompleteTask:(SMDownloaderTask*)aTask withSuccess:(BOOL)aSuccess;
- (void)downloader:(SMModuleDownloader*)aDownloader didCompleteWithResult:(BOOL)aSuccess;

@end
