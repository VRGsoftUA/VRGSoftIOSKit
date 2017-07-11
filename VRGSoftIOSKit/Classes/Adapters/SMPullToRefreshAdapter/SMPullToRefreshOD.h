//
//  SMPullToRefreshOD.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 15.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMPullToRefreshAdapter.h"

/**
 * This adapter provide wrapper around ODRefreshControl.
 * @see SMPullToRefreshAdapter
 */
@class ODRefreshControl;
@interface SMPullToRefreshOD : SMPullToRefreshAdapter

@property (nonatomic, readonly) ODRefreshControl* refreshControl;

@end
