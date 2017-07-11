//
//  SMPullToRefreshAdapter.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 15.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMPullToRefreshAdapter.h"

@implementation SMPullToRefreshAdapter

- (void)configureWithTableView:(UITableView*)aTableView
{
    // override it in subclasses
}

- (void)releaseRefreshControl
{
    // override it in subclasses
}

- (void)beginPullToRefresh
{
    self.refreshCallback(self);
}

- (void)endPullToRefresh
{
    // override it in subclasses
}

@end
