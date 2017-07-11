//
//  SMCompoundFetcher.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 26.05.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMDataFetcher.h"

/**
 *
 * Use this fetcher to execute several other fetchers (this fetchers can be any type).
 * This fetchers can be executed parallel or consequentially.
 * You responsible to create one new Response for responses of other executed fetchers.
 *
 * Composit pattern used.
 **/
@interface SMCompoundFetcher : NSObject <SMDataFetcher>
{
    NSMutableArray* fetcherNodes;
    SMDataFetchCallback fetchCallback;
    
    SMFetcherMessage *originalMessage;
}

/**
 * Setup this parameter to YES if you want to execute all fetchers parallel.
 * Otherwise, if you want to execute all fetchers consequentially setup this parameter to NO.
 * NO, by default
 **/
@property (nonatomic, assign) BOOL executeFetchingParallel;

/**
 * NO, by default
 **/
@property (nonatomic, assign) BOOL successResponseIfAtLeastOne;

- (void)addFetcher:(id<SMDataFetcher>)aDataFetcher;

/**
 * Create one SMResponse from responses of all fetchers.
 * By default this method only merges boArrays and datadictionaries in new response.
 * Override it if you need your own rules to create new response.
 **/
- (SMResponse*)createFetcherResponse;

/**
 * When executing fetchers in serial mode you can override this method to determine when next node can be executed or 
 * executing should be finished. By default returns YES.
 **/
- (BOOL)canExecuteNextNodeAtIndex:(NSUInteger)anIndex withMessage:(SMFetcherMessage*)aMessage;

/**
 * When executing fetchers you can override this method to send properly configured message of original(input) message for node at index.
 * by default this method returns original message.
 * NOTE: you should create new configured message by configurating copy of original message - use [originalMessage copy]
 **/
- (SMFetcherMessage*)configuredMessageForNodeAtIndex:(NSUInteger)anIndex;

/**
 * returns YES by default
 **/
- (BOOL)shouldIncludeResponseResultsFromNodeAtIndex:(NSUInteger)anIndex;

@end

/**
 * This is inner class used in SMCompoundFetcher
 **/
@interface SMCompoundFetcherNode : NSObject

@property (nonatomic, strong) id<SMDataFetcher> fetcher;
@property (nonatomic, strong) SMResponse* response;

@end

