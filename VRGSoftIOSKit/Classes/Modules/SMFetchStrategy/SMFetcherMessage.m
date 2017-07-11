//
//  SMFetcherMessage.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 20.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMFetcherMessage.h"

@implementation SMFetcherMessage

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _defaultParameters = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"defaultParams : %@", _defaultParameters];
}

#pragma mark - NSCopying

//- (id)copyWithZone:(NSZone *)zone
//{
//    SMFetcherMessage *message = [[self class] new];
//    [message.defaultParameters addEntriesFromDictionary:self.defaultParameters];
//    
//    return message;
//}

@end
