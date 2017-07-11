//
//  SMPair.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 10/13/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import "SMPair.h"

@implementation SMPair

+ (instancetype)pairWithFirst:(id)aFirst second:(id)aSecond
{
    return [[[self class] alloc] initWithFirst:aFirst second:aSecond];
}

- (instancetype)initWithFirst:(id)aFirst second:(id)aSecond
{
    if((self = [super init]))
    {
        self.first = aFirst;
        self.second = aSecond;
    }
    
    return self;
}

@end


@implementation NSArray (SMPair)

- (SMPair*)pairByFirst:(id)aFirst
{
    SMPair* result = nil;
    for(SMPair* pair in self)
    {
        if([pair.first isEqual:aFirst])
        {
            result = pair;
            break;
        }
    }
    return result;
}

- (SMPair*)pairBySecond:(id)aSecond
{
    SMPair* result = nil;
    for(SMPair* pair in self)
    {
        if([pair.second isEqual:aSecond])
        {
            result = pair;
            break;
        }
    }
    return result;
}

@end
