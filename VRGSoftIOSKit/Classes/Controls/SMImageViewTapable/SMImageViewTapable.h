//
//  SMImageViewTapable.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 3/14/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMTargetAction.h"


@interface SMImageViewTapable : UIImageView
{
    NSMutableArray* targetActions;
    NSObject* data;
}

@property (nonatomic, assign) BOOL enable;
@property (nonatomic, strong) NSObject* data;

- (void)addTarget:(id)aTarget action:(SEL)anAction;

@end
