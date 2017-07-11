//
//  UIImage+fixOrientation.m
//  Vivaturizmo-iOS6
//
//  Created by VRGSoft on 17.10.12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "UIImage+fixOrientation.h"

@implementation UIImage (fixOrientation)

- (UIImage *)fixOrientation
{
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImage *)fixOrientationDevice
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIImage *image = self;
    
    switch (orientation)
    {
        case UIDeviceOrientationPortrait:
            image = [[UIImage alloc] initWithCGImage:image.CGImage scale:1.0f orientation:UIImageOrientationDown];
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            image = [[UIImage alloc] initWithCGImage:image.CGImage scale:1.0f orientation:UIImageOrientationUp];
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            image = [[UIImage alloc] initWithCGImage:image.CGImage scale:1.0f orientation:UIImageOrientationLeft];
            break;
            
        case UIDeviceOrientationLandscapeRight:
            image = [[UIImage alloc] initWithCGImage:image.CGImage scale:1.0f orientation:UIImageOrientationRight];
            break;
            
        default:
            image = [[UIImage alloc] initWithCGImage:image.CGImage scale:1.0f orientation:UIImageOrientationDown];
            break;
    }
    return [image fixOrientationGorizontal];
}

- (UIImage *)fixOrientationGorizontal
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
            
            transform = CGAffineTransformTranslate(transform, 0, self.size.width);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            
            break;
            
        case UIImageOrientationUp:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            
            break;
            
        case UIImageOrientationRight:
            
            transform = CGAffineTransformTranslate(transform, self.size.height, self.size.width);
            transform = CGAffineTransformRotate(transform, M_PI);
            
            break;
            
        case UIImageOrientationLeft:
            
            transform = CGAffineTransformTranslate(transform, 0, 0);
            transform = CGAffineTransformRotate(transform, 0);
            
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.height, self.size.width,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationUp:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            
            break;
        default:
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
