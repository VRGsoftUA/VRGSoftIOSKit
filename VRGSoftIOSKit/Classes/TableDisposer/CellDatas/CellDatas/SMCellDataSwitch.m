//
//  SMBooleanCellData.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 3/30/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMCellDataSwitch.h"
#import "SMCellSwitch.h"

@implementation SMCellDataSwitch

@synthesize boolValue;
@synthesize targetAction;
@synthesize onText;
@synthesize offText;

#pragma mark - Init/Dealloc

- (instancetype)initWithObject:(NSObject *)aObject key:(NSString *)aKey
{
    self = [super initWithObject:aObject key:aKey];
    if(self)
    {
        self.cellClass = [SMCellSwitch class];
        self.cellSelectionStyle = UITableViewCellSelectionStyleNone;
        targetAction = [[SMTargetAction alloc] init];
    }
    return self;
}

#pragma mark - Target/Action

- (void)setTarget:(id)aTarget action:(SEL)anAction
{
    [targetAction setTarget:aTarget action:anAction];
}

#pragma mark - Maping

- (void)mapFromObject
{
    if (object && key)
        boolValue = [[object valueForKeyPath:key] boolValue];
}

- (void)mapToObject
{
    if (object && key)
        [object setValue:[NSNumber numberWithBool:boolValue] forKeyPath:key];
}

@end
