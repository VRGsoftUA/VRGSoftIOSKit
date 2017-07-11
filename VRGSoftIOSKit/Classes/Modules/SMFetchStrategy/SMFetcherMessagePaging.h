//
//  SMFetcherMessagePaging.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 29.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMFetcherMessage.h"

@interface SMFetcherMessagePaging : SMFetcherMessage

@property (nonatomic, assign) NSUInteger pagingSize;
@property (nonatomic, assign) NSUInteger pagingOffset;
@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) BOOL loadingMore;

@end
