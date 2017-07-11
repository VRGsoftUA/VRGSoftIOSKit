//
//  SMPopoverViewController.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 2/14/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMPopoverViewController.h"

@implementation SMPopoverViewController

@synthesize popoverOwner;

- (instancetype)initWithPopupView:(SMPopupView *)aPopupedView
{
    if( (self = [super init]) )
    {
        popupedView = aPopupedView;
        self.modalInPopover = !popupedView.hideByTapOutside;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.bounds = popupedView.bounds;

    popupedView.autoresizingMask = UIViewAutoresizingNone;
    [self.view addSubview:popupedView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [popupedView popupWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [popupedView popupDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [popupedView popupWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [popupedView popupDidDisappear:animated];
    
//    [popoverOwner autorelease];
    popoverOwner = nil;
}

- (CGSize)preferredContentSize
{
    if (popupedView)
        return popupedView.bounds.size;
    return CGSizeMake(320, 320);
}

@end
