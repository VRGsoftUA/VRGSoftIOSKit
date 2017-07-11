//
//  SMNativePullToRefresh.h
//  RetouchMe
//
//  Created by OLEKSANDR SEMENIUK on 2/15/17.
//  Copyright © 2017 ISD. All rights reserved.
//

#import "SMPullToRefreshAdapter.h"

@interface SMNativePullToRefresh : SMPullToRefreshAdapter
{
    UIRefreshControl *refreshControl;
}

@property (nonatomic, readonly) UIRefreshControl *refreshControl;

@end
