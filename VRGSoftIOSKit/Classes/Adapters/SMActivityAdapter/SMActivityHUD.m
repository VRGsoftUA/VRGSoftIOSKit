//
//  SMActivityHUD.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 15.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMActivityHUD.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation SMActivityHUD

- (id)activity
{
    return activity;
}

- (void)configureWithView:(UIView*)aView
{
    activity = [[MBProgressHUD alloc] initWithView:aView];
    [aView addSubview:activity];
}

- (void)showActivity:(BOOL)animated
{
    [activity.superview bringSubviewToFront:activity];
    [activity showAnimated:animated];
}

- (void)hideActivity:(BOOL)animated
{
    [activity hideAnimated:animated];
}

- (void)releaseActivityView
{
    [activity removeFromSuperview];
    activity = nil;
}

@end
