//
//  SMKeyboardAvoidingTableView.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 1/30/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//
//  Taken as a basis for an example of "TPKeyboardAvoidingTableView"(Created by Michael Tyson)

#import <UIKit/UIKit.h>
#import "SMKeyboardAvoidingProtocol.h"
#import "SMKeyboardToolbar.h"

@interface SMKeyboardAvoidingTableView : UITableView <SMKeyboardAvoidingProtocol, SMKeyboardToolbarProtocol>
{
    UIEdgeInsets    _priorInset;
    BOOL            _keyboardVisible;
    CGRect          _keyboardRect;
    NSMutableArray *_objectsInKeyboard;
    NSMutableDictionary* _indexPathseObjectsInKeyboard;
    
    NSUInteger _selectIndexInputField;
    id _inputField;
    SMKeyboardToolbar *keyboardToolbar;
    
    BOOL            _isAnimated;
}

- (void)sordetInputTraits:(NSArray*)inputTraits byIndexPath:(NSIndexPath*)indexPath;

@end
