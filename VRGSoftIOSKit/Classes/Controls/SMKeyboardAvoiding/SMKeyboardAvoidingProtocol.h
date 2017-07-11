//
//  SMKeyboardAvoidingProtocol.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 02.04.12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMKeyboardToolbar.h"

@protocol SMKeyboardAvoiderProtocol;

@protocol SMKeyboardAvoidingProtocol <NSObject>

@property (nonatomic, readonly) SMKeyboardToolbar *keyboardToolbar;
@property (nonatomic, assign) BOOL showsKeyboardToolbar;

- (void)adjustOffset;
- (void)hideKeyBoard;

- (void)addObjectForKeyboard:(id<UITextInputTraits, SMKeyboardAvoiderProtocol>)objectForKeyboard;
- (void)removeObjectForKeyboard:(id<UITextInputTraits, SMKeyboardAvoiderProtocol>)objectForKeyboard;

- (void)addObjectsForKeyboard:(NSArray *)objectsForKeyboard;
- (void)removeObjectsForKeyboard:(NSArray *)objectsForKeyboard;

- (void)removeAllObjectsForKeyboard;

- (void)responderShouldReturn:(UIResponder*)aResponder;

@end


