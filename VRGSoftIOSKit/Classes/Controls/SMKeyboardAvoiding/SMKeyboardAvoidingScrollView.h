//
//  SMKeyboardAvoidingScrollView.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 1/30/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//
//  Taken as a basis for an example of "TPKeyboardAvoidingScrollView"(Created by Michael Tyson)

#import <UIKit/UIKit.h>
#import "SMKeyboardAvoidingProtocol.h"
#import "SMKeyboardToolbar.h"

@interface SMKeyboardAvoidingScrollView : UIScrollView <SMKeyboardAvoidingProtocol, SMKeyboardToolbarProtocol>
{
    UIEdgeInsets    _priorInset;
    BOOL            _keyboardVisible;
    CGRect          _keyboardRect;
    CGSize          _originalContentSize;
    NSMutableArray *_objectsInKeyboard;
    
    NSUInteger _selectIndexInputField;    
    SMKeyboardToolbar *keyboardToolbar;
}

@end
