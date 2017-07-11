//
//  SMCellDataButton.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 3/30/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMCellDataButton.h"
#import "SMCellButton.h"

@implementation SMCellDataButton

@synthesize targetAction;

@synthesize title;
@synthesize titleFont;
@synthesize titleColor;
@synthesize titleAlignment;

#pragma mark - Init/Dealloc

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.cellClass = [SMCellButton class];
        
        titleAlignment = NSTextAlignmentLeft;
        titleFont = [UIFont systemFontOfSize:18];
        titleColor = [UIColor blackColor];
        targetAction = [[SMTargetAction alloc] init];
    }
    return self;
}

#pragma mark - Target/Action

- (void)setTarget:(id)aTarget action:(SEL)anAction
{
    [targetAction setTarget:aTarget action:anAction];
    [self addCellSelectedTarget:targetAction.target action:targetAction.action];
}

@end
