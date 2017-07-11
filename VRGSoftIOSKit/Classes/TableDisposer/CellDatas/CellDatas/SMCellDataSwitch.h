//
//  SMBooleanCellData.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 3/30/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMCellDataStandart.h"
#import "SMTargetAction.h"


@interface SMCellDataSwitch : SMCellDataStandart

@property (nonatomic, assign) BOOL boolValue;
@property (nonatomic, readonly) SMTargetAction* targetAction;

@property (nonatomic, retain) NSString* onText;
@property (nonatomic, retain) NSString* offText;

- (void)setTarget:(id)aTarget action:(SEL)anAction;

@end
