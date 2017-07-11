//
//  SMPopupViewController.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 25.08.11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import <UIKit/UIKit.h>

@class SMPopupView;

@interface SMPopupViewController : UIViewController
{
@protected
    UIButton* btHided;
    UIView* popupedViewOwner;
    SMPopupView* popupedView;
    UIView* overlayView;
    
    float overlayViewAlpha;
    
    BOOL animatingNow;
    BOOL isShow;
}

@property (nonatomic, retain) SMPopupView* popupedView;
@property (nonatomic, readonly) UIView* overlayView;                            ///< get overlayView
@property (nonatomic, assign) float overlayViewAlpha;                           ///< change alpha of overlayView (to change color of overlayView use property 'overlayView')
@property (nonatomic, readonly) BOOL isShow;

- (void)showWithAnimation:(BOOL)animation inView:(UIView*)aView;               ///< show popupedView
- (void)hideWithAnimation:(BOOL)animation;                                     ///< hide popupedView

@end
