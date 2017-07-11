//
//  SMNativePullToRefresh.m
//  RetouchMe
//
//  Created by OLEKSANDR SEMENIUK on 2/15/17.
//  Copyright © 2017 ISD. All rights reserved.
//

#import "SMNativePullToRefresh.h"


@implementation SMNativePullToRefresh
@synthesize refreshControl;

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        refreshControl = [UIRefreshControl new];
        [refreshControl addTarget:self action:@selector(refreshControlDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    }
    
    return self;
}

- (void)configureWithTableView:(UIScrollView *)aTableView
{
    [aTableView addSubview:refreshControl];
    [aTableView sendSubviewToBack:refreshControl];
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

- (void)setEnabled:(BOOL)enabled
{
    refreshControl.enabled = enabled;
}

- (BOOL)enabled
{
    return refreshControl.enabled;
}

- (void)refreshControlDidBeginRefreshing:(UIRefreshControl *)aSender
{
    if(refreshControl != aSender)
        return;
    
    [self beginPullToRefresh];
}

@end
