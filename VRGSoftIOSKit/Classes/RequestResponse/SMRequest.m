//
//  SMRequest.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 15.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMRequest.h"
#import "SMQueueNode.h"

@interface SMResponseNode : SMQueueNode

@property (nonatomic, copy) SMRequestResponseBlock block;

@end

@implementation SMRequest

#pragma mark - Init/Dealloc

- (void)dealloc
{
    SMDeallocLog;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        responseBlocks = [NSMutableArray new];
    }
    return self;
}

#pragma mark - Request execute

- (BOOL)canExecute
{
    return NO;
}

- (void)start
{
    NSAssert(NO, @"Override it!");
}

- (void)cancel
{
    NSAssert(NO, @"Override it!");
}

- (BOOL)isExecuting
{
    NSAssert(NO, @"Override it!");
    return NO;
}

- (BOOL)isCancelled
{
    NSAssert(NO, @"Override it!");
    return NO;
}

- (BOOL)isFinished
{
    NSAssert(NO, @"Override it!");
    return YES;
}

- (void)startWithResponseBlockInMainQueue:(SMRequestResponseBlock)aResponseBlock
{
    [self addResponseBlock:aResponseBlock responseQueue:dispatch_get_main_queue()];
    
    [self start];
}

- (void)startWithResponseBlockInGlobalQueue:(SMRequestResponseBlock)aResponseBlock
{
    [self addResponseBlock:aResponseBlock responseQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];
    
    [self start];
}


#pragma mark - Response blocks

- (instancetype)addResponseBlock:(SMRequestResponseBlock)aResponseBlock responseQueue:(dispatch_queue_t)aResponseQueue
{
    NSParameterAssert(aResponseBlock);
    NSParameterAssert(aResponseQueue);
    
    SMResponseNode* node = [SMResponseNode new];
    node.block = aResponseBlock;
    node.dispatchQueue = aResponseQueue;
    
    [responseBlocks addObject:node];
    return self;
}

- (void)clearAllResponseBlocks
{
    [responseBlocks removeAllObjects];
}

- (void)executeAllResponseBlocksWithResponse:(SMResponse*)aResponse
{
    for(SMResponseNode* node in responseBlocks)
    {
        if (node.dispatchQueue && node.block)
        {
            dispatch_async(node.dispatchQueue, ^
            {
                node.block(aResponse);
            });
        }
    }
}

- (void)executeSynchronouslyAllResponseBlocksWithResponse:(SMResponse*)aResponse
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    dispatch_queue_t currentQueue = dispatch_get_current_queue();
#pragma clang diagnostic pop
    for(SMResponseNode* node in responseBlocks)
    {
        if (!node.dispatchQueue || !node.block)
            continue;
        
        if(currentQueue != node.dispatchQueue)
        {
            dispatch_sync(node.dispatchQueue, ^
            {
                node.block(aResponse);
            });
        }
        else
        {
            node.block(aResponse);
        }
    }
}

@end

@implementation SMResponseNode

@end

