//
//  SMPopupView.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 2/13/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMKitDefines.h"
#import "SMPopupViewController.h"


#define SM_POPUPVIEW_WILL_SHOW     @"PopupViewWillShow"
#define SM_POPUPVIEW_DID_SHOW      @"PopupViewDidShow"
#define SM_POPUPVIEW_WILL_HIDE     @"PopupViewWillHide"
#define SM_POPUPVIEW_DID_HIDE      @"PopupViewDidHide"
#define SM_POPUPVIEW_NEED_HIDE     @"PopupViewNeedHide"

@interface SMPopupView : UIView

@property (nonatomic, readonly) id showStrategy;
@property (nonatomic, assign) BOOL hideByTapOutside;
/**
 * Determine show or not overlay view (by default it is gray transparent view above any free space)
 **/
@property (nonatomic, assign) BOOL showOverlayView;
@property (nonatomic, readonly) BOOL isVisible;

- (void)prepareToRelease;

- (void)hideWithAnimation:(BOOL)animation;

// for iPhone
- (void)showWithAnimation:(BOOL)animation inView:(UIView*)aView;

// for iPad
- (void)showFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated;

- (void) prepareToShow;

// use it only in subclasses of this class, dont cull it manyally in your code (outside of subclasses of this classe)
- (void)setup;
- (void)popupWillAppear:(BOOL)animated;
- (void)popupDidAppear:(BOOL)animated;
- (void)popupWillDisappear:(BOOL)animated;
- (void)popupDidDisappear:(BOOL)animated;


#pragma mark - NSNotificationNeedHide
- (void)notificationNeedHide:(NSNotification *)aNotification;
@end
