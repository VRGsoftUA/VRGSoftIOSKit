//
//  SMPopupView.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 2/13/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMPopupView.h"
#import "SMPopoverViewController.h"
#import "SMKitDefines.h"


@implementation SMPopupView

@synthesize showStrategy;
@synthesize hideByTapOutside;
@synthesize showOverlayView;
@synthesize isVisible;

#pragma mark - Init/Dealloc

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if( (self = [super initWithCoder:aDecoder]) )
    {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        [self setup];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) setup
{
    hideByTapOutside = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationNeedHide:) name:SM_POPUPVIEW_NEED_HIDE object:nil];
    
}

- (void)prepareToRelease
{
    if([showStrategy isKindOfClass:[SMPopupViewController class]])
    {
        showStrategy = nil;
    }
}

- (void)prepareToShow
{
    showStrategy = nil;
    
    if(!SM_IS_IPAD)
    {
        SMPopupViewController* popupController = [[SMPopupViewController alloc] init];
        popupController.popupedView = self;
        
        showStrategy = popupController;
    }
    else
    {
        SMPopoverViewController* popoverViewController = [[SMPopoverViewController alloc] initWithPopupView:self];
        UIPopoverController* popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverViewController];
        popoverViewController.popoverOwner = popoverController;
        popoverViewController = nil;
        
        showStrategy = popoverController;
    }
}

- (void)popupWillAppear:(BOOL)animated
{
    isVisible = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:SM_POPUPVIEW_WILL_SHOW object:self];
}

- (void)popupDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SM_POPUPVIEW_DID_SHOW object:self];
}

- (void)popupWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SM_POPUPVIEW_WILL_HIDE object:self];
}

- (void)popupDidDisappear:(BOOL)animated
{
    showStrategy = nil;
    
    isVisible = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:SM_POPUPVIEW_DID_HIDE object:self];
}

- (void)hideWithAnimation:(BOOL)animation
{
    if(!SM_IS_IPAD)
    {
        [(SMPopupViewController*)showStrategy hideWithAnimation:animation];
    }
    else
    {
        [(UIPopoverController*)showStrategy dismissPopoverAnimated:animation];
    }
    
}

- (void)showWithAnimation:(BOOL)animation inView:(UIView*)aView
{
    if(!SM_IS_IPAD)
    {
        CGRect frame = self.frame;
        frame.size.width = aView.frame.size.width;
        self.frame = frame;
        [(SMPopupViewController*)showStrategy showWithAnimation:animation inView:aView];
    }
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated
{
    if(SM_IS_IPAD)
    {
        [(UIPopoverController*)showStrategy presentPopoverFromRect:rect inView:view permittedArrowDirections:arrowDirections animated:animated];
    }
}


#pragma mark - NSNotificationNeedHide

- (void)notificationNeedHide:(NSNotification *)aNotification
{
    [self hideWithAnimation:YES];
}

@end
