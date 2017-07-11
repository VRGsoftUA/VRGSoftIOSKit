//
//  UIImage+More.h
//  BondJeansApp
//
//  Created by VRGSoft on 5/4/15.
//  Copyright (c) 2015 VRGSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (More)

+ (UIImage *)imageWithColor:(UIColor *)aColor size:(CGSize)aSize;

- (UIImage *)drawImage:(UIImage *)aImage position:(CGPoint)aPosition;
- (UIImage *)rotateOnDegrees:(float)aDegrees;
- (UIImage *)tintedImageWithColor:(UIColor *)aColor;
- (NSData *)dataJPEGWithkBSize:(NSUInteger)aKbSize;
+ (UIImage *)resizableImageWithColor:(UIColor *)aColor;

@end
