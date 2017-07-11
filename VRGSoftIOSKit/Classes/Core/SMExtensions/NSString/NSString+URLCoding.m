//
//  NSString+URLCoding.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 11.07.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "NSString+URLCoding.h"

@implementation NSString (URLCoding)

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding
{
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (__bridge CFStringRef)self,
                                                                                 NULL,                                                                                 
                                                                                 CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding));
}

- (NSString *)urlDecodeUsingEncoding:(NSStringEncoding)encoding
{
    return (__bridge_transfer NSString *)(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                  (__bridge CFStringRef)self,
                                                                                                  CFSTR(""),
                                                                                                  CFStringConvertNSStringEncodingToEncoding(encoding)));
}

@end
