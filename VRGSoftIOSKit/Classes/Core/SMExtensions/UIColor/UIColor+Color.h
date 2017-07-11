//
//  UIColor+Color.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 11.07.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface UIColor (Color)

+ (UIColor*)colorWithRedI:(NSInteger)red
                   greenI:(NSInteger)green
                    blueI:(NSInteger)blue
                   alphaI:(NSInteger)alpha;

- (NSString*)htmlHexString;
- (CGFloat)red;
- (CGFloat)green;
- (CGFloat)blue;

@end
