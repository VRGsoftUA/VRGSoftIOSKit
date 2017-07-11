//
//  SMPopovedStrategy.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 06.06.12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMPopoverable.h"

@interface SMPopovedStrategy : NSObject

@property (nonatomic, assign) Class popoverBackgroundViewClass;

@property (nonatomic, weak, readonly) UIView* popovedView;
@property (nonatomic, retain, readonly) UIPopoverController *popoverController;
@property (nonatomic, assign, readonly) UIPopoverArrowDirection permittedArrowDirections;


- (void)presentPopoverFromView:(UIView*)aView
         withContentController:(UIViewController<SMPopoverable>*)aPopoverableController
      permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections
                      animated:(BOOL)animated;

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;

@end
