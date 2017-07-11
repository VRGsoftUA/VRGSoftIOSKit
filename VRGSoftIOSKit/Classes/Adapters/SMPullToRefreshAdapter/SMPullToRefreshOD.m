//
//  SMPullToRefreshOD.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 15.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMPullToRefreshOD.h"
#import <ODRefreshControl/ODRefreshControl.h>

@interface SMPullToRefreshOD ()

- (void)refreshControlDidBeginRefreshing:(ODRefreshControl*)aSender;

@end

@implementation SMPullToRefreshOD

@synthesize refreshControl;

- (void)configureWithTableView:(UITableView*)aTableView
{
    refreshControl = [[ODRefreshControl alloc] initInScrollView:aTableView];
    [refreshControl addTarget:self action:@selector(refreshControlDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
}

- (void)releaseRefreshControl
{
    refreshControl = nil;
}

- (void)beginPullToRefresh
{
    [refreshControl beginRefreshing];
    [super beginPullToRefresh];
}

- (void)endPullToRefresh
{
    [refreshControl endRefreshing];
}

- (void)refreshControlDidBeginRefreshing:(ODRefreshControl*)aSender
{
    if(refreshControl != aSender)
        return;

    [self beginPullToRefresh];
}

- (void)setEnabled:(BOOL)enabled
{
    refreshControl.enabled = enabled;
}

- (BOOL)enabled
{
    return refreshControl.enabled;
}

@end
