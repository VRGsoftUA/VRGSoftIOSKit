//
//  UIButton+Images.m
//  
//
//  Created by Alexander Burkhai on 2/26/13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "UIButton+Images.h"
#import "UIImage+More.h"

@implementation UIButton (Images)

- (void)setupIconImagesWithNormalImage:(UIImage *)normalImage
                         selectedImage:(UIImage *)selectedImage
                         disabledImage:(UIImage *)disabledImage
{
    [self setImage:normalImage forState:UIControlStateNormal];
    [self setImage:selectedImage forState:UIControlStateHighlighted];
    [self setImage:selectedImage forState:UIControlStateSelected];
    [self setImage:selectedImage forState:(UIControlStateHighlighted | UIControlStateSelected)];
    [self setImage:disabledImage forState:UIControlStateDisabled];
}

- (void)setupBackgroundImagesWithNormalImage:(UIImage *)normalImage
                               selectedImage:(UIImage *)selectedImage
                               disabledImage:(UIImage *)disabledImage
{    
    [self setBackgroundImage:disabledImage forState:UIControlStateDisabled];
    [self setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
    [self setBackgroundImage:selectedImage forState:UIControlStateSelected];
    [self setBackgroundImage:selectedImage forState:(UIControlStateHighlighted | UIControlStateSelected)];
    [self setBackgroundImage:normalImage forState:UIControlStateNormal];
}

- (void)setupBackgroundImagesWithNormalName:(NSString *)normalName
                               selectedName:(NSString *)selectedName
                               disabledName:(NSString *)disabledName
{
    UIImage *normalImage = [normalName length] ? [UIImage imageNamed:normalName] : nil;
    UIImage *selectedImage = [selectedName length] ? [UIImage imageNamed:selectedName] : nil;
    UIImage *disabledImage = [disabledName length] ? [UIImage imageNamed:disabledName] : nil;
    
    [self setupBackgroundImagesWithNormalImage:normalImage
                                 selectedImage:selectedImage
                                 disabledImage:disabledImage];
}

#pragma mark - Configure

- (void)configureProperHighlightedSelectedStateImages
{
    [self setImage:[self imageForState:UIControlStateSelected]
          forState:(UIControlStateHighlighted | UIControlStateSelected)];
    [self setBackgroundImage:[self backgroundImageForState:UIControlStateSelected]
                    forState:(UIControlStateHighlighted | UIControlStateSelected)];
}

- (void)setBackgroundColor:(UIColor *)aBackgroundColor forState:(UIControlState)aState
{
    [self setBackgroundImage:[UIImage resizableImageWithColor:aBackgroundColor] forState:aState];
}

@end
