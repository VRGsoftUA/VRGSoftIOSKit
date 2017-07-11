//
//  NSObject+Cast.m
//  RyppleIOSApp
//
//  Created by VRGSoft on 9/25/15.
//  Copyright © 2015 Kultprosvet. All rights reserved.
//

#import "NSObject+Cast.h"

@implementation NSObject (Cast)

+ (instancetype)asType:(id)object
{
    if ([object isKindOfClass:self])
    {
        return object;
    }
    
    return nil;
}

@end
