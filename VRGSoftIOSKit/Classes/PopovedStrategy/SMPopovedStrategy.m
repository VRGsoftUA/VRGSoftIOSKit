//
//  SMPopovedStrategy.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 06.06.12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMPopovedStrategy.h"


@interface SMPopovedStrategy ()

- (UIPopoverController*)popoverControllerWithContent:(UIViewController*)aController;

@end

@implementation SMPopovedStrategy

@synthesize popoverBackgroundViewClass;
@synthesize popovedView;
@synthesize popoverController;
@synthesize permittedArrowDirections;

- (void)presentPopoverFromView:(UIView*)aView
         withContentController:(UIViewController<SMPopoverable>*)aPopoverableController
      permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections
                      animated:(BOOL)animated
{
    popovedView = aView;
    permittedArrowDirections = arrowDirections;
    popoverController = [self popoverControllerWithContent:aPopoverableController];
    aPopoverableController.sm_popover = self.popoverController;

    [self.popoverController presentPopoverFromRect:popovedView.bounds
                                            inView:popovedView
                          permittedArrowDirections:permittedArrowDirections
                                          animated:animated];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if(popoverController.isPopoverVisible)
    {
        [popoverController dismissPopoverAnimated:NO];
    
        [popoverController presentPopoverFromRect:popovedView.bounds
                                           inView:popovedView
                         permittedArrowDirections:permittedArrowDirections
                                         animated:NO];
    }
}

#pragma mark - Private

- (UIPopoverController*)popoverControllerWithContent:(UIViewController*)aController
{
    if(!popoverController)
    {
        popoverController = [[UIPopoverController alloc] initWithContentViewController:aController];
        if(popoverBackgroundViewClass)
            [popoverController setPopoverBackgroundViewClass:popoverBackgroundViewClass];
    }
    else
    {
        [popoverController setContentViewController:aController];
        [popoverController setPopoverContentSize:aController.preferredContentSize];
    }
    
    return popoverController;
}

@end
