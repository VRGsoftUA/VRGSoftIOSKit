//
//  SMPopupViewController.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 25.08.11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import "SMPopupViewController.h"
#import "SMPopupView.h"
#import "SMExtensions.h"

#define SM_MOTION_DURATION         0.4f

@interface SMPopupViewController ()

- (void)hidedButtonPressed:(id)aSender;
- (void)setupSubviews;

- (void)popupWillAppear:(BOOL)animated;
- (void)popupDidAppear:(BOOL)animated;
- (void)popupWillDisappear:(BOOL)animated;
- (void)popupDidDisappear:(BOOL)animated;

@end


@implementation SMPopupViewController

@synthesize popupedView;

@synthesize isShow;
@synthesize overlayView;
@synthesize overlayViewAlpha;

#pragma mark - Init/Dealloc

- (instancetype)init
{
    if( (self = [super init]) )
    {
        overlayViewAlpha = 0.3f;
    }
    return self;
}

#pragma mark - View lifecicle

- (void)setupSubviews
{
    CGRect frame;
    
    frame = self.view.bounds;
    frame.origin.y = self.view.bounds.size.height;
    popupedViewOwner = [[UIView alloc] initWithFrame:frame];
    [self.view addSubview:popupedViewOwner];
    popupedViewOwner.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // btHided
    btHided = [UIButton buttonWithType:UIButtonTypeCustom];
    [popupedViewOwner addSubview:btHided];
    btHided.frame = self.view.bounds;
    btHided.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [btHided addTarget:self action:@selector(hidedButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    btHided.hidden = !popupedView.hideByTapOutside;
    
    if(popupedView.showOverlayView)
    {
        overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:overlayView];
        overlayView.backgroundColor = [UIColor grayColor];
        overlayView.alpha = 0.0f;
        overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view sendSubviewToBack:overlayView];
    }
    
    // popuped view
    if(popupedView)
    {
        [popupedViewOwner addSubview:popupedView];
        frame = popupedView.frame;
        frame.origin.y = self.view.bounds.size.height - frame.size.height;
        frame.size.width = popupedViewOwner.bounds.size.width;
        popupedView.frame = frame;
    }
}

- (void)loadView
{
    self.view = [UIView new];
    self.view.hidden = YES;
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = SMViewAutoresizingFlexibleSize;
    
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)popupWillAppear:(BOOL)animated
{
    self.view.frame = self.view.superview.bounds;
    
    [self setupSubviews];
    
    [self.view.superview bringSubviewToFront:self.view];
    self.view.hidden = NO;
    
    [popupedView popupWillAppear:animated];
}

- (void)popupDidAppear:(BOOL)animated
{
    [popupedView popupDidAppear:animated];
}

- (void)popupWillDisappear:(BOOL)animated
{
    [popupedView popupWillDisappear:animated];
}

- (void)popupDidDisappear:(BOOL)animated
{
    isShow = NO;
    [self.view removeFromSuperview];
    [popupedView popupDidDisappear:animated];
}

#pragma mark - Rotations

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Show/Hide

- (void)showWithAnimation:(BOOL)animation inView:(UIView*)aView
{
    if(isShow || animatingNow) return;
    
    [aView addSubview:self.view];
    [self popupWillAppear:animation];
    
    // anim
    
    isShow = YES;
    
    if(animation)
    {
        // animations
        [UIView animateWithDuration:SM_MOTION_DURATION
                         animations:^(void)
         {
             animatingNow = YES;
             
             // motion
             CGRect frame = popupedViewOwner.frame;
             frame.origin = CGPointZero;
             popupedViewOwner.frame = frame;
             
             // change overlay alpha
             overlayView.alpha = overlayViewAlpha;
         }
                         completion:^(BOOL finished)
         {
             animatingNow = NO;
             
             [self popupDidAppear:animation];
         }];
    }
    else
    {
        // placed
        CGRect frame = popupedViewOwner.frame;
        frame.origin = CGPointZero;
        popupedViewOwner.frame = frame;
        
        [self popupDidAppear:animation];
    }
    
}

- (void)hideWithAnimation:(BOOL)animation
{
    if(!isShow || animatingNow) return;
    
    [self popupWillDisappear:animation];
    
    if(animation)
    {
        animatingNow = YES;
        
        // animations
        [UIView animateWithDuration:SM_MOTION_DURATION
                         animations:^(void)
         {
             // motion
             CGRect frame = popupedViewOwner.frame;
             frame.origin.y = self.view.bounds.size.height;
             popupedViewOwner.frame = frame;
             
             // change overlay alpha
             overlayView.alpha = 0.0f;
         }
                         completion:^(BOOL finished)
         {
             animatingNow = NO;
             [self popupDidDisappear:animation];
         }];
    }
    else
    {
        [self popupDidDisappear:animation];
    }
}

- (void) hidedButtonPressed:(id)aSender
{
    [self hideWithAnimation:YES];
}

- (CGSize)preferredContentSize
{
    if (popupedView)
        return popupedView.bounds.size;
    return CGSizeMake(320, 320);
}

@end
