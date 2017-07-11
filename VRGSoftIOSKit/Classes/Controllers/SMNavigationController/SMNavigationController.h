//
//  SMNavigationController.h
//  BondChooseQualityApp
//
//  Created by VRGSoft on 10/11/14.
//  Copyright (c) 2014 VRGSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMNavigationController : UINavigationController

- (void)pushFadeViewController:(UIViewController *)viewController;
- (void)popFadeViewController;
- (void)popFadeRootViewController;

@end
