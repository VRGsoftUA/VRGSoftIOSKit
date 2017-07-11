//
//  SMDraw.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 04.05.12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#ifndef SMDraw_h
#define SMDraw_h

#import <QuartzCore/QuartzCore.h>

extern void SMDrawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor, bool isHorizontal);
extern void SMDrawLinearGradientVertical(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);
extern void SMDrawLinearGradientHorizontal(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);

extern CGContextRef SMCreateThreadSafeContext(CGSize contextSize);
extern CGImageRef SMCreateCGImageFromThreadSafeContext(CGContextRef context);

extern UIImage* SMImageWithColor(UIColor* color, CGSize size);

#endif
