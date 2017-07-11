//
//  SMCellDataMaped.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 3/29/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMCellDataMaped.h"

@implementation SMCellDataMaped

@synthesize key;
@synthesize object;

- (instancetype)init
{
    NSAssert(NO, @"You can't use this method! Instead use 'initWithObject:key:'");
    return nil;
}

- (instancetype)initWithObject:(NSObject *)aObject key:(NSString *)aKey
{
    self = [super init];
    if (self)
    {
        key = aKey;
        object = aObject;
    }
    return self;
}

- (void) mapFromObject
{
    NSAssert(nil, @"Override this method in subclasses!");
}

- (void) mapToObject
{
    NSAssert(nil, @"Override this method in subclasses!");
}

@end
