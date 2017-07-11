//
//  SMTextView.m
// VRGSoftIOSKit
//
//  Created by VRGSoft on 9/6/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import "SMTextView.h"
#import "SMKeyboardAvoidingProtocol.h"
#import "SMKitDefines.h"

@interface SMTextViewDelegateHolder : NSObject <UITextViewDelegate>

@property (nonatomic, weak) SMTextView* holdedTextView;

@end

@interface SMTextView ()

@property (nonatomic, retain) UITextView* placeholderTextView;

- (void)setup;
- (void)setPlaceHolderHidden:(BOOL)aHidden;

@end

@implementation SMTextView

@synthesize smdelegate;
@synthesize keyboardAvoiding;
@synthesize observedText;
@synthesize filter;


#pragma mark - Init

- (instancetype)init
{
    if ((self = [super init]))
    {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self setup];
    }
    return self;
}

#pragma mark - Setup

- (void)setup
{
    delegateHolder = [SMTextViewDelegateHolder new];
    delegateHolder.holdedTextView = self;
    
    super.delegate = delegateHolder;
}

#pragma mark - SMValidationProtocol

- (void)setValidator:(SMValidator*)aValidator
{
    validator = aValidator;
    validator.validatableObject = self;
}

- (NSString*)validatableText
{
    return self.text;
}

- (void)setValidatableText:(NSString *)aValidatableText
{
    self.text = aValidatableText;
}

- (SMValidator*)validator
{
    return validator;
}

- (BOOL)validate
{
    return (validator) ? ([validator validate]) : (YES);
}

#pragma mark - Placeholder

- (UITextView*)placeholderTextView
{
    if (!_placeholderTextView)
    {
        _placeholderTextView = [[UITextView alloc] initWithFrame:self.bounds];
        _placeholderTextView.backgroundColor = [UIColor clearColor];
        _placeholderTextView.font = self.font;
        _placeholderTextView.textColor = [UIColor grayColor];
        _placeholderTextView.editable = NO;
        _placeholderTextView.userInteractionEnabled = NO;
        _placeholderTextView.hidden = [self.text length] > 0;
        _placeholderTextView.autoresizingMask = SMViewAutoresizingFlexibleSize;
        _placeholderTextView.textContainerInset = self.textContainerInset;
        [self addSubview:_placeholderTextView];
    }
    return _placeholderTextView;
}

- (void)setPlaceholder:(NSString *)aPlaceholder
{
    self.placeholderTextView.text = aPlaceholder;
    if ([self.placeholder length])
        self.placeholderTextView.hidden = [self.text length] > 0;
}

- (NSString *)placeholder
{
    return self.placeholderTextView.text;
}

- (void)setAttributedPlaceholder:(NSAttributedString *)aAttributedPlaceholder
{
    self.placeholderTextView.attributedText = aAttributedPlaceholder;
}

- (NSAttributedString *)attributedPlaceholder
{
    return self.placeholderTextView.attributedText;
}

- (void)setPlaceholderColor:(UIColor *)aPlaceholderColor
{
    self.placeholderTextView.textColor = aPlaceholderColor;
}

- (UIColor *)placeholderColor
{
    return self.placeholderTextView.textColor;
}

- (void)setTextContainerInset:(UIEdgeInsets)aTextContainerInset
{
    [super setTextContainerInset:aTextContainerInset];
    self.placeholderTextView.textContainerInset = aTextContainerInset;
}

- (void)setTextAlignment:(NSTextAlignment)aTextAlignment
{
    [super setTextAlignment:aTextAlignment];
    self.placeholderTextView.textAlignment = aTextAlignment;
}

- (void)setPlaceHolderHidden:(BOOL)aHidden
{
    self.placeholderTextView.hidden = aHidden;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    if ([self.placeholder length])
        self.placeholderTextView.hidden = [self.text length] > 0;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeholderTextView.font = font;
}


#pragma mark - UITextViewDelegate

- (void)setDelegate:(id<UITextViewDelegate>)delegate
{
    if(delegate)
    {
        NSAssert(NO, @"Must use mudelegate!");
    }
}

- (id<UITextViewDelegate>)delegate
{
    return delegateHolder;
}

@end


@implementation SMTextViewDelegateHolder

@synthesize holdedTextView;

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    BOOL result = YES;
    
    if([holdedTextView.smdelegate respondsToSelector:@selector(textViewShouldBeginEditing:)])
        result = [holdedTextView.smdelegate textViewShouldBeginEditing:textView];
    
    return result;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    BOOL result = YES;
    
    if([holdedTextView.smdelegate respondsToSelector:@selector(textViewShouldEndEditing:)])
        result = [holdedTextView.smdelegate textViewShouldEndEditing:textView];
    
    return result;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [holdedTextView.keyboardAvoiding adjustOffset];
    
    if([holdedTextView.smdelegate respondsToSelector:@selector(textViewDidBeginEditing:)])
        [holdedTextView.smdelegate textViewDidBeginEditing:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    holdedTextView.observedText = textView.text;
    
    if([holdedTextView.smdelegate respondsToSelector:@selector(textViewDidEndEditing:)])
        [holdedTextView.smdelegate textViewDidEndEditing:textView];
}

- (BOOL)textView:(SMTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL result = YES;
    
    if (textView.filter)
        result = [textView.filter textInField:textView shouldChangeCharactersInRange:range replacementString:text];
    
    if(result && [holdedTextView.smdelegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)])
        result = [holdedTextView.smdelegate textView:textView shouldChangeTextInRange:range replacementText:text];
    
    if(result)
    {
        NSString* newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
        [textView setPlaceHolderHidden:newString.length];
    }
    
    return result;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if([holdedTextView.smdelegate respondsToSelector:@selector(textViewDidChange:)])
        [holdedTextView.smdelegate textViewDidChange:textView];
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if([holdedTextView.smdelegate respondsToSelector:@selector(textViewDidChangeSelection:)])
        [holdedTextView.smdelegate textViewDidChangeSelection:textView];
}

@end
