//
//  NSString+URLCoding.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 11.07.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLCoding)

- (NSString*)urlEncodeUsingEncoding:(NSStringEncoding)encoding;
- (NSString*)urlDecodeUsingEncoding:(NSStringEncoding)encoding;

@end
