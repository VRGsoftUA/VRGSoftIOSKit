//
//  NSString+More.m
//  WebTaxi
//
//  Created by VRGSoft on 9/22/14.
//  Copyright (c) 2014 Caiguda. All rights reserved.
//

#import "NSString+More.h"

@implementation NSString (More)

-(NSString *) stringByStrippingHTML
{
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

- (NSString *)replacePart:(NSString *)aStr partCount:(NSInteger)aCount range:(NSRange *)aRange
{
    /*if (!aStr.length)
     {
     aRange->location = NSNotFound;
     aRange->length = NSNotFound;
     
     return self;
     }*/
    if (!aStr)
    {
        aStr = @"";
    }
    
    NSString *result = nil;
    
    NSArray *array = [self componentsSeparatedByString:[NSString stringWithFormat:@"##%@##",@(aCount)]];
    if (array.count <= 1)
    {
        aRange->location = NSNotFound;
        aRange->length = NSNotFound;
        return (result)?result:self;
    }
    result = @"";
    aRange->length = aStr.length;
    for (NSString *str in array)
    {
        
        NSString *prefix = [NSString stringWithFormat:@"%@%@",result,str];
        if (str == array.lastObject)
        {
            result = prefix;
            
        } else
        {
            aRange->location = prefix.length;
            result = [NSString stringWithFormat:@"%@%@",prefix,aStr];
        }
        
    }
    if (!result)
    {
        aRange->location = NSNotFound;
        aRange->length = NSNotFound;
    }
    return (result)?result:self;
}

- (NSString *)replaceParts:(NSArray *)aParts
{
    NSString *result = nil;
    result = [NSString stringWithString:self];
    for (NSInteger i = 0; i < aParts.count; i++)
    {
        NSRange r;
        result = [result replacePart:aParts[i] partCount:i range:&r];
    }
    
    return result;
}

- (NSString *)replacePart:(NSString *)aStr partCount:(NSInteger)aCount
{
    NSRange r;
    return [self replacePart:aStr partCount:aCount range:&r];
}
@end
