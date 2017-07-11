//
//  UIImageView+More.m
//  BondJeansApp
//
//  Created by VRGSoft on 5/2/15.
//  Copyright (c) 2015 VRGSoft. All rights reserved.
//

#import "UIImageView+More.h"

@implementation UIImageView (More)

- (void)setImage:(UIImage *)image animte:(BOOL)animate
{
    if (animate)
    {
        [UIView transitionWithView:self
                          duration:0.2f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.image = image;
                        } completion:NULL];

    } else
    {
        self.image = image;
    }
}
@end
