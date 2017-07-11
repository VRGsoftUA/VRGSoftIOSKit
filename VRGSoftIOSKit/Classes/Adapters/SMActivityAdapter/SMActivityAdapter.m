//
//  SMActivityAdapter.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 15.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMActivityAdapter.h"

@implementation SMActivityAdapter

@dynamic activity;

- (id)activity
{
    // override it in subclasses
    return nil;
}

- (void)configureWithView:(UIView*)aView
{
    // override it in subclasses
}

- (void)showActivity:(BOOL)animated
{
    // override it in subclasses
}

- (void)hideActivity:(BOOL)animated
{
    // override it in subclasses
}

- (void)releaseActivityView
{
    // override it in subclasses
}

@end
