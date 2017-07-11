//
//  SMViewController.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 7/7/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMKitDefines.h"
#import "SMExtensions.h"
#import "SMHelper.h"
#import "SMActivityAdapter.h"
#import "SMNavigationController.h"

/**
 * This class provide useful methods that simplify work with subclasses of UIViewController.
 * Good practice to create base view controller for all view controllers in your project. Useful to inherit this base controller from this class.
 */
@interface SMViewController : UIViewController
{
    BOOL isVisible;
    SMActivityAdapter* activity;
}

/**
 * This property helps to determine is controller visible now.
 */
@property (nonatomic, readonly) BOOL isVisible;

/**
 * Get access to view with background image of your controller.
 */
@property (nonatomic, readonly) UIImageView *backgroundImageView;

/**
 * Get isModal.
 */
@property(nonatomic,readonly) BOOL isModal;

/**
 * Show activity. As activity used wrapper around activity control.
 * @see CTActivityAdapter
 * As example, you can show activity during loading some data, during send request to the server, or when executing some continuous task.
 * @see hideActivity
 */
- (void)showActivity;

/**
 * Hide activity.
 * @see showActivity
 */
- (void)hideActivity;

/**
 * Setup background image for controller view with this method. Just overrid it in your subclass.
 */
- (UIImage*)backgroundImage;

/**
 * Create custom left button for navigation bar
 */
- (UIBarButtonItem*)createLeftNavButton;

/**
 * Create custom left additionals buttons for navigation bar
 */
- (NSArray <UIBarItem *>*)createLeftNavButtonsAdditionals;

/**
 * Create custom title view for navigation bar (return nil by default)
 */
- (UIView*)createTitleViewNavItem;

/**
 * Create custom right button for navigation bar (return nil by default).
 */
- (UIBarButtonItem*)createRightNavButton;

/**
 * Create custom right additionals buttons for navigation bar
 */
- (NSArray <UIBarItem *>*)createRightNavButtonsAdditionals;

#pragma mark - Actions

/**
 * Action to process pressed-on-left-button event
 */
- (void)didBtNavLeftClicked:(id)aSender;

/**
 * Action to process pressed-on-right-button event
 */
- (void)didBtNavRightClicked:(id)aSender;

/**
 * Handy  method to call alert. Also this method before show alert checks is this controller visible.
 */
- (void)showAlertViewWithTitle:(NSString*)aTitle
                       message:(NSString*)aMessage;

/**
 * Handy  method to call alert. Also this method before show alert checks is this controller visible.
 */
- (void)showAlertViewWithTitle:(NSString *)aTitle
                       message:(NSString *)aMessage
             cancelButtonTitle:(NSString *)aCancelButtonTitle
             otherButtonTitles:(NSArray *)aOtherButtonTitles
                  dismissBlock:(void(^)(id alertController, NSInteger buttonIndex))dismissBlock;

/**
 * use if loadView method has been overridden
 */
+ (instancetype)loadFromNib;

/**
 * NSNotification receiver
 */
+ (void)sendNotificationData:(id)aData;
+ (NSString *)notificationKey;
- (void)reciveNotification:(NSNotification *)aNotification;
- (void)reciveNotificationData:(id)aData;


@end
