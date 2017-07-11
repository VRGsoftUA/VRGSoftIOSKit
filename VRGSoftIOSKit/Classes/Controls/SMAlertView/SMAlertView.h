//
//  SMAlertView.h
//  VRGSoftIOSKitDemo
//
//  Created by VRGSoft on 04.09.14.
//  Copyright (c) 2014 VRGSoft. all rights reserved.
//

#import <UIKit/UIKit.h>

void SMShowSimpleAlert(NSString* aTitle, NSString* aMessage);

@interface SMAlertView : UIAlertView

@end


void SMShowSimpleAlertController(NSString* aTitle, NSString* aMessage);
void SMShowSimpleAlertControllerFromVc(NSString* aTitle, NSString* aMessage, UIViewController *aFromVc);

@interface SMAlertController : UIAlertController

- (void)show;
- (void)hide;

- (void)showFromViewController:(UIViewController *)aVc;

+ (UIViewController *)topViewController;
+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController;

+ (instancetype)showAlertControllerWithTitle:(NSString *)title
                                     message:(NSString *)message
                          fromViewController:(UIViewController *)aVc
                           cancelButtonTitle:(NSString *)cancelButtonTitle
                           otherButtonTitles:(NSArray <NSString *> *)otherButtonTitles
                                     handler:(void (^)(id alertController, NSInteger buttonIndex))block;

+ (instancetype)showSheetControllerWithTitle:(NSString *)title
                                     message:(NSString *)message
                          fromViewController:(UIViewController *)aVc
                           cancelButtonTitle:(NSString *)cancelButtonTitle
                           otherButtonTitles:(NSArray <NSString *> *)otherButtonTitles
                                     handler:(void (^)(id alertController, NSInteger buttonIndex))block;
@end
