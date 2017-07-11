//
//  SMCellDataButton.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 3/30/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMCellData.h"
#import "SMTargetAction.h"

@interface SMCellDataButton : SMCellData

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, assign) NSTextAlignment titleAlignment;

@property (nonatomic, readonly) SMTargetAction* targetAction;

- (void)setTarget:(id)aTarget action:(SEL)anAction;

@end
