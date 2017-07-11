//
//  SMActivityHUD.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 15.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMActivityAdapter.h"

/**
 * This adapter provide wrapper around MBProgressHUD activity.
 * @see CTActivityAdapter
 */

@class MBProgressHUD;

@interface SMActivityHUD : SMActivityAdapter
{
    MBProgressHUD* activity;
}

@end
