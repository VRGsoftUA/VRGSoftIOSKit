//
//  NSString+More.h
//  WebTaxi
//
//  Created by VRGSoft on 9/22/14.
//  Copyright (c) 2014 Caiguda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (More)

- (NSString *) stringByStrippingHTML;

- (NSString *)replacePart:(NSString *)aStr partCount:(NSInteger)aCount range:(NSRange *)aRange;
- (NSString *)replaceParts:(NSArray *)aParts;
- (NSString *)replacePart:(NSString *)aStr partCount:(NSInteger)aCount;

@end
