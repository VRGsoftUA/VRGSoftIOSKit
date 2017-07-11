//
//  UIColor+Color.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 11.07.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "UIColor+Color.h"

@interface UIColor (Private)

- (BOOL) isRGB;

@end

@implementation UIColor (Color)

+ (UIColor *)colorWithRedI:(NSInteger)red greenI:(NSInteger)green blueI:(NSInteger)blue alphaI:(NSInteger)alpha
{
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f];
}

- (NSString *)htmlHexString
{
    CGColorRef color = self.CGColor;
    size_t count = CGColorGetNumberOfComponents(color);
    const CGFloat *components = CGColorGetComponents(color);
    
    static NSString *stringFormat = @"%02x%02x%02x";
    
    // Grayscale
    if (count == 2)
    {
        NSUInteger white = (NSUInteger)(components[0] * (CGFloat)255);
        return [NSString stringWithFormat:stringFormat, white, white, white];
    }
    
    // RGB
    else if (count == 4)
    {
        return [NSString stringWithFormat:stringFormat, (NSUInteger)(components[0] * (CGFloat)255),
                (NSUInteger)(components[1] * (CGFloat)255), (NSUInteger)(components[2] * (CGFloat)255)];
    }
    
    // Unsupported color space
    return nil;
}

- (BOOL)isRGB
{
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor)) == kCGColorSpaceModelRGB;
}

- (CGFloat)red
{
    NSAssert([self isRGB], @"Not RGB!");
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    return components[0];
}

- (CGFloat)green
{
    NSAssert([self isRGB], @"Not RGB!");
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    return components[1];
}

- (CGFloat)blue
{
    NSAssert([self isRGB], @"Not RGB!");
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    return components[2];
}

@end
