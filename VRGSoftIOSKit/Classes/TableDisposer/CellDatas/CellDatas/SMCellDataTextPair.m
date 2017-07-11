//
//  SMCellDataTextPair.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 04.04.12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMCellDataTextPair.h"

@implementation SMCellDataTextPair

@synthesize title, titleFont, titleColor;
@synthesize text, textFont, textColor;

#pragma mark - Init/Dealloc

- (instancetype)initWithObject:(NSObject *)aObject key:(NSString *)aKey
{
    self = [super initWithObject:aObject key:aKey];
    if(self)
    {
        titleFont = [UIFont systemFontOfSize:16];
        titleColor = [UIColor blackColor];
        
        textFont = [UIFont systemFontOfSize:16];
        textColor = [UIColor blackColor];
    }
    return self;
}

#pragma mark - Maping

- (void)mapFromObject
{
    if (object && key)
        text = [object valueForKeyPath:key];
}

- (void)mapToObject
{
    if (object && key)
        [object setValue:text forKeyPath:key];
}

@end
