//
//  SMTextView.h
// VRGSoftIOSKit
//
//  Created by VRGSoft on 9/6/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import "SMValidator.h"
#import "SMKeyboardAvoiderProtocol.h"
#import "SMFilter.h"

@class SMTextViewDelegateHolder;

@interface SMTextView : UITextView <UITextViewDelegate, SMValidationProtocol, SMKeyboardAvoiderProtocol>
{
    SMValidator* validator;
    SMTextViewDelegateHolder* delegateHolder;
    SMFilter *filter;
}

@property (nonatomic, weak) id<UITextViewDelegate> smdelegate;
@property (nonatomic, strong) SMFilter *filter;
@property (nonatomic, copy) NSString *observedText;

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;
@property (nonatomic, retain) NSAttributedString *attributedPlaceholder;

@end
