//
//  SMTextCellData.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 3/30/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMCellDataLabel.h"
#import "SMCellLabel.h"

@implementation SMCellDataLabel

#pragma mark - Init/Dealloc

- (instancetype)initWithObject:(NSObject *)aObject key:(NSString *)aKey
{
    self = [super initWithObject:aObject key:aKey];
    if(self)
    {
        self.cellClass = [SMCellLabel class];
    }
    return self;
}

@end
