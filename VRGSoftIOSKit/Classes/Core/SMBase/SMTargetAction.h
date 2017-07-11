//
//  SMTargetAction.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 3/14/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMTargetAction : NSObject

@property (nonatomic, weak, readonly) id target;
@property (nonatomic, readonly) SEL action;

+ (SMTargetAction*)targetActionWithTarget:(id)aTarget action:(SEL)anAction;

- (instancetype)initWithTarget:(id)aTarget action:(SEL)anAction;

- (void)setTarget:(id)aTarget action:(SEL)anAction;
- (void)sendActionFrom:(id)aSender;

@end


@interface SMTargetActionList : NSObject
{
    NSMutableArray* taList;
}

- (void)addTarget:(id)aTarget action:(SEL)anAction;
- (void)sendActionsFrom:(id)aSender;

@end


@protocol SMTargetActionListProtocol <NSObject>

@property (nonatomic, readonly) SMTargetActionList* taList;

- (void)addTarget:(id)aTarget action:(SEL)anAction;

@end
