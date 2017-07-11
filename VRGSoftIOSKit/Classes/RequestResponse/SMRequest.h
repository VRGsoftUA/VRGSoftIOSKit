//
//  SMRequest.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 15.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMKitDefines.h"
#import "SMResponse.h"

typedef void (^SMRequestResponseBlock)(SMResponse* aResponse);

@interface SMRequest : NSObject
{
    NSMutableArray* responseBlocks;
}

@property (nonatomic, assign) BOOL executeAllResponseBlocksSync;

#pragma mark - Request execute/cancel
- (BOOL)canExecute;
- (void)start;
- (BOOL)isExecuting;

- (void)cancel;
- (BOOL)isCancelled;
- (BOOL)isFinished;

- (void)startWithResponseBlockInMainQueue:(SMRequestResponseBlock)aResponseBlock;
- (void)startWithResponseBlockInGlobalQueue:(SMRequestResponseBlock)aResponseBlock;

#pragma mark - Response blocks
- (instancetype)addResponseBlock:(SMRequestResponseBlock)aResponseBlock responseQueue:(dispatch_queue_t)aResponseQueue;
- (void)clearAllResponseBlocks;

#pragma mark - Protected methods (use only in subclasses)
/**
 * Execute all response blocks asynchronously
 **/
- (void)executeAllResponseBlocksWithResponse:(SMResponse*)aResponse;
/**
 * Execute all response blocks synchronously
 **/
- (void)executeSynchronouslyAllResponseBlocksWithResponse:(SMResponse*)aResponse;

@end
