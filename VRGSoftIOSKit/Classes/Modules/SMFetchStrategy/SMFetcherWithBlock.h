//
//  SMFetcherWithBlock.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 16.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMDataFetcher.h"

typedef void (^SMDataFetchBlock)(SMFetcherMessage *aMessage, SMDataFetchCallback aCallback);

/**
 * Use this to determine fetching logic in block
 **/
@interface SMFetcherWithBlock : NSObject <SMDataFetcher>

@property (nonatomic, copy) SMDataFetchBlock fetchBlock;

- (instancetype)initWithFetchBlock:(SMDataFetchBlock)aFetchBlock;

@end
