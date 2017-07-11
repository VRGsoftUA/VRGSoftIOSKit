//
//  UIImage+More.m
//  BondJeansApp
//
//  Created by VRGSoft on 5/4/15.
//  Copyright (c) 2015 VRGSoft. All rights reserved.
//

#import "UIImage+More.h"

@implementation UIImage (More)

+ (UIImage *)imageWithColor:(UIColor *)aColor size:(CGSize)aSize
{
    CGRect rect = CGRectMake(0.0f, 0.0f, aSize.width, aSize.height);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [aColor CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)drawImage:(UIImage *)aImage position:(CGPoint)aPosition
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height) blendMode:kCGBlendModeSourceOut alpha:1.0f];
    [aImage drawInRect:CGRectMake(aPosition.x - aImage.size.width/2.0f, aPosition.y - aImage.size.height/2.0f, aImage.size.width, aImage.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

- (UIImage *)rotateOnDegrees:(float)aDegrees
{
    CGFloat rads = M_PI * aDegrees / 180;
    float newSide = MAX([self size].width, [self size].height);
    
    CGSize rotatedSize = CGSizeMake(newSide, newSide);
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(ctx, rads);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextDrawImage(UIGraphicsGetCurrentContext(),CGRectMake(-newSide / 2.0f, -newSide/2.0f, self.size.width, self.size.height),self.CGImage);
    UIImage *i = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return i;
}

- (UIImage *)tintedImageWithColor:(UIColor *)aColor
{
    if (!aColor)
    {
        return self;
    }
    
    CGFloat scale = self.scale;
    CGSize size = CGSizeMake(scale * self.size.width, scale * self.size.height);
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    // ---
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextDrawImage(context, rect, self.CGImage);
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    [aColor setFill];
    CGContextFillRect(context, rect);
    
    // ---
    CGImageRef bitmapContext = CGBitmapContextCreateImage(context);
    
    UIImage *coloredImage = [UIImage imageWithCGImage:bitmapContext scale:scale orientation:UIImageOrientationUp];
    
    CGImageRelease(bitmapContext);
    
    UIGraphicsEndImageContext();
    
    return coloredImage;
}

- (NSData *)dataJPEGWithkBSize:(NSUInteger)aKbSize
{
    CGFloat maxCompression = 0.1f;
    NSUInteger maxFileSize = aKbSize*1024;
    
    CGFloat compression = 1.0f;
    
    __block NSData *data = UIImageJPEGRepresentation(self, compression);
    
    while ([data length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        data = UIImageJPEGRepresentation(self, compression);
    }
    
    data = UIImageJPEGRepresentation(self, compression+0.05);
    
    return data;
}

+ (UIImage *)resizableImageWithColor:(UIColor *)aColor
{
    UIImage *result = [[self imageWithColor:aColor size:CGSizeMake(1, 1)] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode: UIImageResizingModeStretch];
    
    return result;
}

@end
