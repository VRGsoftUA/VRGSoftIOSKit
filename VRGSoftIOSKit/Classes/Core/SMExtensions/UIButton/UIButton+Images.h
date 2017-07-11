//
//  UIButton+Images.h
//  
//
//  Created by Alexander Burkhai on 2/26/13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIButton (Images)

- (void)setupIconImagesWithNormalImage:(UIImage *)normalImage
                         selectedImage:(UIImage *)selectedImage
                         disabledImage:(UIImage *)disabledImage;
- (void)setupBackgroundImagesWithNormalImage:(UIImage *)normalImage
                               selectedImage:(UIImage *)selectedImage
                               disabledImage:(UIImage *)disabledImage;
- (void)setupBackgroundImagesWithNormalName:(NSString *)normalName
                               selectedName:(NSString *)selectedName
                               disabledName:(NSString *)disabledName;

/*
 * configure (UIControlStateHighlighted | UIControlStateSelected) state properly according to UIControlStateSelected images
 */
- (void)configureProperHighlightedSelectedStateImages;

- (void)setBackgroundColor:(UIColor *)aBackgroundColor forState:(UIControlState)aState;

@end
