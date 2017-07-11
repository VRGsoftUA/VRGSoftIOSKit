//
//  SMKeyboardToolbar.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 4/16/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMToolbar.h"

@protocol SMKeyboardToolbarProtocol <NSObject>

- (void)didNextButtonPressd;
- (void)didPrevButtonPressd;
- (void)didDoneButtonPressd;

@end

@interface SMKeyboardToolbar : SMToolbar
{
    UIBarButtonItem *bbiBack;
    UIBarButtonItem *bbiNext;
    UIBarButtonItem *bbiDone;
}

@property (nonatomic, weak) id<SMKeyboardToolbarProtocol> smdelegate;
@property (nonatomic, readonly) UIBarButtonItem *bbiDone;
@property (nonatomic, readonly) UIBarButtonItem *bbiBack;
@property (nonatomic, readonly) UIBarButtonItem *bbiNext;

@property (nonatomic, assign) UIKeyboardAppearance keyboardAppearance;

- (void)selectedInputFieldIndex:(NSInteger)selectInsex allCountInputFields:(NSInteger)allCountInputFields;

@end
