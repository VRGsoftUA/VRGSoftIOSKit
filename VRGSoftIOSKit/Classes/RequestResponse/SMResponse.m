//
//  SMResponse.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 15.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMResponse.h"

@implementation SMResponse

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _dataDictionary = [NSMutableDictionary new];
        _boArray = [NSMutableArray new];
    }
    return self;
}

@end
