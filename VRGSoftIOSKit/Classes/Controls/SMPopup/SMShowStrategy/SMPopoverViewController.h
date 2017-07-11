//
//  SMPopoverViewController.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 2/14/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMPopupView.h"

@interface SMPopoverViewController : UIViewController
{
    SMPopupView* popupedView;
}

@property (nonatomic, assign) UIPopoverController* popoverOwner;

- (instancetype)initWithPopupView:(SMPopupView*)aPopupedView;

@end
