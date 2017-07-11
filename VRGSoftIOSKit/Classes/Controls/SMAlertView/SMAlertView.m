//
//  SMAlertView.m
//  VRGSoftIOSKitDemo
//
//  Created by VRGSoft on 04.09.14.
//  Copyright (c) 2014 VRGSoft. all rights reserved.
//

#import "SMAlertView.h"

void SMShowSimpleAlert(NSString* aTitle, NSString* aMessage)
{
    [[[SMAlertView alloc] initWithTitle:aTitle message:aMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@implementation SMAlertView

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hide) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)hide
{
    [self dismissWithClickedButtonIndex:-1 animated:YES];
}

@end


void SMShowSimpleAlertController(NSString* aTitle, NSString* aMessage)
{
    SMShowSimpleAlertControllerFromVc(aTitle, aMessage, [SMAlertController topViewController]);
}

void SMShowSimpleAlertControllerFromVc(NSString* aTitle, NSString* aMessage, UIViewController *aFromVc)
{
    __block SMAlertController *ac = [SMAlertController alertControllerWithTitle:aTitle message:aMessage preferredStyle:UIAlertControllerStyleAlert];
    
    [ac addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [ac showFromViewController:aFromVc];
}


@implementation SMAlertController

- (void)dealloc
{
    NSLog(@"DEALLOC - %@",NSStringFromClass([self class]));
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hide) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)hide
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)show
{
    [self showFromViewController:[[self class] topViewController]];
}

- (void)showFromViewController:(UIViewController *)aVc
{
    [aVc presentViewController:self animated:YES completion:NULL];
}

+ (UIViewController *)topViewController
{
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController)
    {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else
    {
        return rootViewController;
    }
}

+ (instancetype)showAlertControllerWithTitle:(NSString *)title
                                     message:(NSString *)message
                          fromViewController:(UIViewController *)aVc
                           cancelButtonTitle:(NSString *)cancelButtonTitle
                           otherButtonTitles:(NSArray <NSString *> *)otherButtonTitles
                                     handler:(void (^)(id alertController, NSInteger buttonIndex))block
{
    SMAlertController *alertController = [[self class] showAlertControllerWithStyle:UIAlertControllerStyleAlert title:title message:message fromViewController:aVc cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles handler:block];
    
    return alertController;
}

+ (instancetype)showSheetControllerWithTitle:(NSString *)title
                                     message:(NSString *)message
                          fromViewController:(UIViewController *)aVc
                           cancelButtonTitle:(NSString *)cancelButtonTitle
                           otherButtonTitles:(NSArray <NSString *> *)otherButtonTitles
                                     handler:(void (^)(id alertController, NSInteger buttonIndex))block
{
    SMAlertController *alertController = [[self class] showAlertControllerWithStyle:UIAlertControllerStyleActionSheet title:title message:message fromViewController:aVc cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles handler:block];
    
    return alertController;
}

+ (instancetype)showAlertControllerWithStyle:(UIAlertControllerStyle)aAlertControllerStyle
                                       title:(NSString *)title
                                     message:(NSString *)message
                          fromViewController:(UIViewController *)aVc
                           cancelButtonTitle:(NSString *)cancelButtonTitle
                           otherButtonTitles:(NSArray <NSString *> *)otherButtonTitles
                                     handler:(void (^)(id alertController, NSInteger buttonIndex))block
{
    if (!cancelButtonTitle.length && !otherButtonTitles.count)
        cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
    
    SMAlertController *alertController = [[self class] alertControllerWithTitle:title message:message preferredStyle:aAlertControllerStyle];
    
    __weak SMAlertController *__alertController;
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (block)
        {
            block(__alertController,0);
        }
    }];
    
    [alertController addAction:cancelAction];
    
    for (NSUInteger i = 0; i < otherButtonTitles.count; i++)
    {
        NSUInteger __i = i + 1;
        NSString *buttonTitle = otherButtonTitles[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (block)
            {
                block(__alertController,__i);
            }
        }];
        
        [alertController addAction:action];
    }
    
    [alertController showFromViewController:aVc];
    
    return alertController;
}

@end
