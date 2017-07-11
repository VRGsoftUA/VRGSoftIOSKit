//
//  SMTextField.h
// VRGSoftIOSKit
//
//  Created by VRGSoft on 8/19/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import "SMValidator.h"
#import "SMFilter.h"
#import "SMFormatter.h"
#import "SMKeyboardAvoiderProtocol.h"

@class SMTextFieldDelegateHolder;

@interface SMTextField : UITextField <UITextFieldDelegate, SMValidationProtocol, SMFormatterProtocol, SMKeyboardAvoiderProtocol>
{
    SMValidator* validator;
    SMFormatter* formatter;
    SMTextFieldDelegateHolder* delegateHolder;
    UIColor* placeholderColor;
    
    CGFloat topT;
    CGFloat leftT;
    CGFloat bottomT;
    CGFloat rightT;
}

@property (nonatomic, weak) id<UITextFieldDelegate> smdelegate;
@property (nonatomic, retain) SMFilter *filter;
@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, assign) BOOL hidenCursor;

@property (nonatomic, strong) UIColor *placeholderColor;

@property(nonatomic,assign) CGFloat topT;
@property(nonatomic,assign) CGFloat leftT;
@property(nonatomic,assign) CGFloat bottomT;
@property(nonatomic,assign) CGFloat rightT;

@end
