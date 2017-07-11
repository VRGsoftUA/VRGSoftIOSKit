
//
//  SMDraw.c
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 04.05.12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//


#import "SMDraw.h"

void SMDrawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor, bool isHorizontal)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.0f, 1.0f};
    CGColorRef colors_c[2] = {startColor, endColor};
    CFArrayRef colors = CFArrayCreate(NULL, (const void**)colors_c, 2, &kCFTypeArrayCallBacks);
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, locations);
    
    CGPoint startPoint;
    CGPoint endPoint;
    if(isHorizontal)
    {
        startPoint = CGPointMake(rect.origin.x, rect.origin.y);
        endPoint = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
    }
    else
    {
        startPoint = CGPointMake(rect.origin.x, rect.origin.y);
        endPoint = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
    }
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);

    CFRelease(colors);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

void SMDrawLinearGradientVertical(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor)
{
    SMDrawLinearGradient(context, rect, startColor, endColor, true);
}

void SMDrawLinearGradientHorizontal(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor)
{
    SMDrawLinearGradient(context, rect, startColor, endColor, false);
}

CGContextRef SMCreateThreadSafeContext(CGSize contextSize)
{
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(NULL,
                                                 (int)contextSize.width,
                                                 (int)contextSize.height,
                                                 8,
                                                 0,
                                                 space,
                                                 (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
	CGColorSpaceRelease(space);
    return context;
}

CGImageRef SMCreateCGImageFromThreadSafeContext(CGContextRef context)
{
    return CGBitmapContextCreateImage(context);
}

UIImage* SMImageWithColor(UIColor* color, CGSize size)
{
    UIImage* result = nil;
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

