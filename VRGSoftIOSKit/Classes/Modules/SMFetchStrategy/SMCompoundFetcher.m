//
//  SMCompoundFetcher.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 26.05.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMCompoundFetcher.h"

@interface SMCompoundFetcher ()

@property (nonatomic, strong) NSMutableArray* fetcherNodes;
@property (nonatomic, strong) SMDataFetchCallback fetchCallback;

- (BOOL)isAllFetchersComplete;
- (void)executeNodeAtIndex:(NSUInteger)anIndex withMessage:(SMFetcherMessage*)aMessage;

@end

@implementation SMCompoundFetcher

@synthesize fetcherNodes, fetchCallback, callbackQueue;

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        fetcherNodes = [NSMutableArray new];
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

#pragma mark - Fetchers

- (void)addFetcher:(id<SMDataFetcher>)aDataFetcher
{
    NSAssert(self.callbackQueue, @"SMCompoundFetcher: callbackQueue is nil! Setup callbackQueue before add any fetcher.");

    SMCompoundFetcherNode* node = [SMCompoundFetcherNode new];
    node.fetcher = aDataFetcher;
    node.fetcher.callbackQueue = self.callbackQueue;
    [fetcherNodes addObject:node];
}

- (BOOL)isAllFetchersComplete
{
    BOOL result = YES;
    for(SMCompoundFetcherNode* node in fetcherNodes)
    {
        if(!node.response)
        {
            result = NO;
            break;
        }
    }
    return result;
}

#pragma mark - Create response

- (SMResponse*)createFetcherResponse
{
    SMResponse* response = [SMResponse new];

    NSMutableArray* models = [NSMutableArray array];
    BOOL success = (self.successResponseIfAtLeastOne) ? NO : YES;

    NSUInteger index = 0;
    for(SMCompoundFetcherNode* node in fetcherNodes)
    {
        if (node.response)
        {
            if ([self shouldIncludeResponseResultsFromNodeAtIndex:index])
            {
                [response.dataDictionary addEntriesFromDictionary:node.response.dataDictionary];
                [models addObjectsFromArray:node.response.boArray];
            }
            
            if (self.successResponseIfAtLeastOne)
                success |= node.response.success;
            else
                success &= node.response.success;
        }
        
        index++;
    }
    
    response.success = success;
    response.boArray = models;
    
    return response;
}

- (BOOL)shouldIncludeResponseResultsFromNodeAtIndex:(NSUInteger)anIndex
{
    return YES;
}

#pragma mark - Execute

- (BOOL)canExecuteNextNodeAtIndex:(NSUInteger)anIndex withMessage:(SMFetcherMessage*)aMessage
{
    return YES;
}

- (void)executeNodeAtIndex:(NSUInteger)anIndex withMessage:(SMFetcherMessage*)aMessage
{
    if (anIndex >= [fetcherNodes count])
    {
        SMResponse* response = [self createFetcherResponse];
        response.success = NO;
        self.fetchCallback(response);
        return;
    }
    
    __weak SMCompoundFetcher* __self = self;
    
    SMCompoundFetcherNode* node = [fetcherNodes objectAtIndex:anIndex];
    __weak SMCompoundFetcherNode* __node = node;
    [node.fetcher fetchDataByMessage:aMessage withCallback:^(SMResponse *aResponse)
     {
         __node.response = aResponse;
         
         if (anIndex + 1 < __self.fetcherNodes.count)
         {
            SMFetcherMessage *configuredMessage = [self configuredMessageForNodeAtIndex:anIndex + 1];
            if ([__self canExecuteNextNodeAtIndex:anIndex + 1 withMessage:configuredMessage])
            {
                [__self executeNodeAtIndex:anIndex + 1 withMessage:configuredMessage];
                return;
            }
         }
         
         if (__self.fetchCallback)
            __self.fetchCallback([__self createFetcherResponse]);
     }];
}

- (SMFetcherMessage*)configuredMessageForNodeAtIndex:(NSUInteger)anIndex
{
    return originalMessage;
}

#pragma mark - SMDataFetcher

- (BOOL)canFetchWithMessage:(SMFetcherMessage *)aMessage
{
    BOOL result = YES;
    for(SMCompoundFetcherNode* node in fetcherNodes)
    {
        result &= [node.fetcher canFetchWithMessage:aMessage];
    }
    return result;
}

- (void)fetchDataByMessage:(SMFetcherMessage*)aMessage
              withCallback:(SMDataFetchCallback)aFetchCallback
{
    fetchCallback = aFetchCallback;
    originalMessage = aMessage;
    
    __weak SMCompoundFetcher* __self = self;

    if(self.executeFetchingParallel)
    {
        // execute fetching parallel
        SMFetcherMessage *configuredMessage;
        NSUInteger index = 0;
        for (SMCompoundFetcherNode* node in fetcherNodes)
        {
            __weak SMCompoundFetcherNode* __node = node;
            configuredMessage = [self configuredMessageForNodeAtIndex:index];
            [node.fetcher fetchDataByMessage:configuredMessage withCallback:^(SMResponse *aResponse)
             {
                 __node.response = aResponse;
                 if ([__self isAllFetchersComplete])
                 {
                     if (__self.fetchCallback)
                         __self.fetchCallback([__self createFetcherResponse]);
                 }
             }];
            
            index++;
        }
    }
    else
    {
        // execute fetching consequentially
        SMFetcherMessage *configuredMessage = [self configuredMessageForNodeAtIndex:0];
        [self executeNodeAtIndex:0 withMessage:configuredMessage];
    }

}

- (void)cancelFetching
{
    for (SMCompoundFetcherNode* node in fetcherNodes)
        [node.fetcher cancelFetching];    
}

@end

@implementation SMCompoundFetcherNode

@end
