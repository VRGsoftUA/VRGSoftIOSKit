//
//  SMTargetAction.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 3/14/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMTargetAction.h"

@implementation SMTargetAction

@synthesize target;
@synthesize action;

+ (SMTargetAction*)targetActionWithTarget:(id)aTarget action:(SEL)anAction
{
    return [[[self class] alloc] initWithTarget:aTarget action:anAction];
}

- (instancetype)initWithTarget:(id)aTarget action:(SEL)anAction
{
    if ((self = [super init]))
    {
        [self setTarget:aTarget action:anAction];
    }
    return self;
}

- (void)setTarget:(id)aTarget action:(SEL)anAction
{
    target = aTarget;
    action = anAction;
}

- (void)sendActionFrom:(id)aSender
{
    if(action && [target respondsToSelector:action])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"        
        [target performSelector:action withObject:aSender];
#pragma clang diagnostic pop
    }
}

@end


@implementation SMTargetActionList

- (instancetype)init
{
    if( (self = [super init]) )
    {
        taList = [NSMutableArray new];
    }
    return self;
}

- (void)addTarget:(id)aTarget action:(SEL)anAction
{
    [taList addObject:[[SMTargetAction alloc] initWithTarget:aTarget action:anAction]];
}

- (void)sendActionsFrom:(id)aSender
{
    for(SMTargetAction* ta in taList)
    {
        [ta sendActionFrom:aSender];
    }
}

@end
