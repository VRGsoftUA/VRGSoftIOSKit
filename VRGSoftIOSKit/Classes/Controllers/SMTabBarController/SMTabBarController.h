//
//  SMTabBarController.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 07.04.12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTabedToolbar.h"
#import "SMViewController.h"

/**
 * You can configure item of a tabbar controller with this class.
 */
@interface SMTabBarItem : NSObject

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) UIColor* titleColor;
@property (nonatomic, retain) UIColor* titleColorSelected;

@property (nonatomic, retain) UIFont* titleFont;

@property (nonatomic, retain) UIColor* titleShadowColor;
@property (nonatomic, assign) CGSize titleShadowOffset;

@property (nonatomic, retain) UIImage* imageNormal;
@property (nonatomic, retain) UIImage* imageSelected;

@property (nonatomic, retain) UIImage* backgroundImageNormal;
@property (nonatomic, retain) UIImage* backgroundImageSelected;

@end

@class SMTabBarController;

/**
 * View controller that is a tab of tabbar controller mast implement this protocol.
 */
@protocol SMTabBarItemProtocol <NSObject>

/**
 * Create and configure item of a tabbar in tabbar controller.
 * in -init method of your controller (that is a tab of your tabbar controller) you should create instance of a SMTabBarItem and configure them.
 */
@property (nonatomic, retain) SMTabBarItem* smtabBarItem;

/**
 * Get SMTabBarControler that contatains you controller as a tab. You don't need to setup this proprty by yourself. SMTabBarControler do it for you.
 */
@property (nonatomic, weak) SMTabBarController* smtabBarController;
@end


/**
 * Delegate for SMTabBarController
 */
@protocol SMTabBarControllerDelegate <NSObject>

@optional
- (BOOL)tabBarController:(SMTabBarController*)aTabBarController shouldSelectViewController:(UIViewController *)aViewController;
- (void)tabBarController:(SMTabBarController *)aTabBarController didSelectViewController:(UIViewController *)aViewController;

@end

/**
 * This enum determine how frame of buttons in tabbar will be calculated.
 */
typedef enum SMTabBarControllerStyle
{
    /**
     * Tabbar buttons frame will be calculated to fill all areay of tabbar.
     */
    SMTabBarControllerStyleTabsFullSize,
    /**
     * Tabbar buttons frame will be calculated in next way: button size will be setup from button image.
     * Later you can setup origin of button directly in method configureTabBarButton:atIndex:.
     * @see configureTabBarButton:atIndex:
     */
    SMTabBarControllerStyleTabsSizeByBGImage,
    /**
     * Hide tabbar and don't create tabbar buttons.
     * Expects that you have your own switcher and will implement manual switch
     */
    SMTabBarControllerStyleTabsHidden
    
} SMTabBarControllerStyle;


/**
 * Custom tabbar controller.
 * With this class you can customize:
 * <ul>
 * <li> tabbar:
 *   <ul><li> place of tabbar: at te botom or at the top of controller;</li>
 *       <li> background of tabbar: color or image;</li>
 *       <li> height of a tabbar;</li>
 *   </ul>
 * </li>
 * <li> tabbar button (customize all buttons and each button independetly): you can customize all properties of button.</li>
 * <li>setup arrow that selected current tab.</li>
 */
@interface SMTabBarController : SMViewController <SMTabedToolbarDelegate>
{
    SMTabedToolbar* tabBar;
    
    UIImageView* tabArrowImageView;
    
    UIView* contentView;
    UIView* currentView;
    UIButton* disabledButton;
}

/**
 * Delegate of tabbar controler. @see SMTabBarControllerDelegate
 */
@property (nonatomic, weak) id<SMTabBarControllerDelegate> delegate;

/**
 * Style of tabbar. Generaly determine how frame of buttons in tabbar will be calculated.
 */
@property (nonatomic, assign) SMTabBarControllerStyle style;

/**
 * Height of a tabbar.
 */
@property (nonatomic, assign) CGFloat tabBarHeight;

/**
 * If YES tabbar will be placed at the top of controller, else - at the bottom. NO by default.
 */
@property (nonatomic, assign) BOOL tabBarOnTheTop;

/**
 * Setup background image of all tabbar.
 */
@property (nonatomic, retain) UIImage* tabBarBackgroundImage;

/**
 * If YES tabbar will be fill with color from tabBarBackgroundColor property.
 * @see tabBarBackgroundColor
 */
@property (nonatomic, assign) BOOL tabBarDrawsColor;

/**
 * Color to fill tabbar.
 * @see tabBarDrawsColor
 */
@property (nonatomic, retain) UIColor* tabBarBackgroundColor;

/**
 * If YES user can interact with buttons on a tabbar. YES by default
 */
@property (nonatomic, assign) BOOL tabBarEnabled;

/**
 * If you setup this property, then array will be placed near current (selected) tab. nill by default (without any array).
 */
@property (nonatomic, retain) UIImage* tabArrowImage;

/**
 * Array of view controllers for tabbar controller. Each controller must implement SMTabBarItemProtocol protocol.
 * Generally you setup all controllers for tabbar during initialization of a tabbar controller.
 * @see SMTabBarItemProtocol
 */
@property (nonatomic, copy) NSArray* viewControllers;

/**
 * You can determine index of selected controller(tab), or can make some tab selected.
 * @see selectedViewController
 */
@property (nonatomic, assign) NSUInteger selectedIndex;

/**
 * You can determine selected controller(tab), or can make some tab selected.
 * @see selectedIndex
 */
@property (nonatomic, assign) UIViewController* selectedViewController;

/**
 * Override to customize tabbar. This method do nothing by default.
 */
- (void)configureTabBar;

/**
 * Override to customize class of button used in tabbar. This method create UIButton by default.
 */
- (UIButton*)createTabBarButtonAtIndex:(NSUInteger)anIndex;

/**
 * Override to customize any properties of button.
 * As example, if you want customize title for some button or frame, ect.
 * Or you can configure all button in this method instead of customize all independently in property smtabBarItem in each controller.
 * @see SMTabBarItemProtocol
 * This method do nothing by default.
 */
- (void)configureTabBarButton:(UIButton*)aTabBarButton atIndex:(NSUInteger)anIndex;

/**
 * Now each button add as a bar button item (bbi) inside tabbar (tabbar it is a subclass of toolbar). So each bbi separated with space.
 * By default spaces configured to placed all buttons close to each other.
 */
- (CGFloat)spaceBeforeTabBarButtonAtIndex:(NSUInteger)anIndex;

/**
 * Update title for already created button.
 */
- (void)updateTabBarButtonTitle:(NSString*)aTabBarButtonTitle forTabBarAtIndex:(NSUInteger)aTabBarButtonIndex;

@end


@interface UIViewController (SMTabBarController)

@property (nonatomic, weak) SMTabBarController* smtabBarController;

@end
