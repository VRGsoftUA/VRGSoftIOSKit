//
//  SMPagingConfig.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 19.02.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMPagingConfig.h"

@implementation SMPagingConfig

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _pageSize = 20;
        _enablePaging = YES;
        _loadMoreDataType = SMLoadMoreDataTypeAuto;
        _useCompoundCells = NO;
        _compoundCellsGroupByCount = 2;
    }
    return self;
}

@end
