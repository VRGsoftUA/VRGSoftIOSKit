//
//  SMLabelCellData.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 3/30/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMCellDataStandart.h"
#import "SMCellStandart.h"


@implementation SMCellDataStandart

@synthesize subtitle;
@synthesize image;
@synthesize imageURL;
@synthesize imagePlaceholder;
@synthesize title;
@synthesize titleFont;
@synthesize subtitleFont;
@synthesize titleColor;
@synthesize subtitleColor;
@synthesize titleTextAlignment;

#pragma mark - Init/Dealloc

- (instancetype)initWithObject:(NSObject *)aObject key:(NSString *)aKey
{
    self = [super initWithObject:aObject key:aKey];
    if (self)
    {
        self.cellClass = [SMCellStandart class];
        
        titleTextAlignment = NSTextAlignmentLeft;
        titleFont = [UIFont systemFontOfSize:18];
        subtitleFont = [UIFont systemFontOfSize:16];
        titleColor = [UIColor blackColor];
        subtitleColor = [UIColor grayColor];
    }
    return self;
}

#pragma mark - Maping

- (void)mapFromObject
{
    if (object && key)
        subtitle = [object valueForKeyPath:key];
}

- (void)mapToObject
{
    if (object && key)
        [object setValue:subtitle forKeyPath:key];
}

@end
