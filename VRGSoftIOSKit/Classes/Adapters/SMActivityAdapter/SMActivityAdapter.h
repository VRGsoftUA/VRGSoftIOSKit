//
//  SMActivityAdapter.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 15.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Adapter for any activities. Like UIActivityIndicatorView, MBProgressHUD etc.
 * Implemented according to Adapter pattern.
 * This pattern make ability to use any activity inside ready logic and switch between activity without any changes in code that used this wrapper.
 */
@interface SMActivityAdapter : NSObject

/**
 * Get activity wrapped by this adapter.
 */
@property (nonatomic, readonly) id activity;

/**
 * Configure wrapped activity in this method.
 * You should call this method in methods like -viewDidLoad: (in controller) or some of -init methods in view subclasses.
 * @param aView Parent view for activity.
 */
- (void)configureWithView:(UIView*)aView;

/**
 * Remove and nullify wrapped activity here.
 * As example, you can call this method inside -viewDidUnload of controller.
 */
- (void)releaseActivityView;

/**
 * Show activity with or without animation.
 * @param animated Determine would be activity appears with animation.
 */
- (void)showActivity:(BOOL)animated;

/**
 * Hide activity with or without animation.
 * @param animated Determine would be activity disappears with animation.
 */
- (void)hideActivity:(BOOL)animated;

@end
