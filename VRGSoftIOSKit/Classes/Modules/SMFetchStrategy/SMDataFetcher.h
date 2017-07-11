//
//  SMDataFetcher.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 16.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMResponse.h"
#import "SMFetcherMessage.h"
#import "SMKitDefines.h"

typedef void (^SMDataFetchCallback) (SMResponse* aResponse);

/**
 * Always setup callbackQueue before use fetcher!
 **/
@protocol SMDataFetcher <NSObject>

#if !OS_OBJECT_USE_OBJC
    @property (nonatomic, assign) dispatch_queue_t callbackQueue;
#else
    @property (nonatomic, strong) dispatch_queue_t callbackQueue;
#endif

- (BOOL)canFetchWithMessage:(SMFetcherMessage*)aMessage;

- (void)fetchDataByMessage:(SMFetcherMessage*)aMessage
              withCallback:(SMDataFetchCallback)aFetchCallback;

- (void)cancelFetching;

@end
