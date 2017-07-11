//
//  SMCellDataModeled.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 3/29/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMCellDataModeled.h"

@implementation SMCellDataModeled

@synthesize model;

- (instancetype)init
{
    NSAssert(NO, @"You can't use this method! Instead use 'initWithModel:'");
    return nil;
}

- (instancetype)initWithModel:(id)aModel
{
    self = [super init];
    if (self)
    {
        model = aModel;
    }
    return self;
}

@end
