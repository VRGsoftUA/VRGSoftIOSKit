//
//  UIView+Controler.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 11.07.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Controller)

- (UIViewController*)firstAvailableUIViewController;
- (id)traverseResponderChainForUIViewController;

@end
