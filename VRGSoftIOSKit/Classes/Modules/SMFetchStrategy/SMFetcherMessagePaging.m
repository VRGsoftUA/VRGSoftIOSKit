//
//  SMFetcherMessagePaging.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 29.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMFetcherMessagePaging.h"

@implementation SMFetcherMessagePaging

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"super - %@; pagingSize %@ ; pagingOffset %@ ; reloading : %@ ; loadinMore : %@ ;", [super debugDescription], @(self.pagingSize), @(self.pagingOffset), @(self.reloading), @(self.loadingMore)];
}

#pragma mark - NSCopying

//- (id)copyWithZone:(NSZone *)zone
//{
//    SMFetcherMessagePaging* message = (SMFetcherMessagePaging*)[super copyWithZone:zone];
//    message.pagingSize = self.pagingSize;
//    message.pagingOffset = self.pagingOffset;
//    message.reloading = self.reloading;
//    message.loadingMore = self.loadingMore;
//    
//    return message;
//}

@end
