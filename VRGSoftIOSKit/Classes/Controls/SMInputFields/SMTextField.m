//
//  SMTextField.m
// VRGSoftIOSKit
//
//  Created by VRGSoft on 8/19/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import "SMTextField.h"
#import "SMKeyboardAvoidingProtocol.h"


@interface SMTextFieldDelegateHolder : NSObject <UITextFieldDelegate>

@property (nonatomic, weak) SMTextField* holdedTextField;

@end

@interface SMTextField ()

- (void)setup;

@end

@implementation SMTextField

@synthesize validatableText;
@synthesize smdelegate;
@synthesize keyboardAvoiding;
@synthesize filter;
@synthesize placeholderColor;

@synthesize topT;
@synthesize bottomT;
@synthesize leftT;
@synthesize rightT;


#pragma mark - Init/Dealloc

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if( (self = [super initWithCoder:aDecoder]) )
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    delegateHolder = [SMTextFieldDelegateHolder new];
    delegateHolder.holdedTextField = self;
    super.delegate = delegateHolder;
}

- (void)setPadding:(CGFloat)aPadding
{
    if (aPadding > 0)
    {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, aPadding, self.bounds.size.height)];
        self.leftView = view;
        self.leftViewMode = UITextFieldViewModeAlways;
        
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, aPadding, self.bounds.size.height)];
        self.rightView = view;
        self.rightViewMode = UITextFieldViewModeAlways;
    }
    else
    {
        self.leftView = nil;
        self.leftViewMode = UITextFieldViewModeNever;
        self.rightView = nil;
        self.rightViewMode = UITextFieldViewModeNever;
    }
}

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    if (self.hidenCursor)
        return CGRectZero;
    else
        return [super caretRectForPosition:position];
}

#pragma mark - CTValidationProtocol

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

#pragma mark - SMFormatterProtocol

- (void)setFormatter:(SMFormatter*)aFormatter
{
    formatter = aFormatter;
    formatter.formattableObject = self;
}

- (SMFormatter*)formatter
{
    return formatter;
}

- (NSString *)formattingText
{
    return self.text;
}

#pragma mark - UITextFieldDelegate

- (void)setDelegate:(id<UITextFieldDelegate>)aDelegate
{
    smdelegate = aDelegate;
}

- (id<UITextFieldDelegate>)delegate
{
    return smdelegate;
}

- (void)setPlaceholderColor:(UIColor *)aPlaceholderColor
{
    placeholderColor = aPlaceholderColor;
    
    if (self.placeholder.length)
    {
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{ NSForegroundColorAttributeName : placeholderColor }];
        self.attributedPlaceholder = str;
    }
}

- (void)setPlaceholder:(NSString *)placeholder
{
    [super setPlaceholder:placeholder];
    if (placeholderColor)
    {
        self.placeholderColor = placeholderColor;
    }
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect rect = [super textRectForBounds:bounds];
    
    CGRect result = UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(topT,leftT,bottomT,rightT));
    
    return result;
}
/*
- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect rect = [super placeholderRectForBounds:bounds];
    
    CGRect result = UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(topT,leftT,bottomT,rightT));
    
    return result;
}
*/
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect rect = [super editingRectForBounds:bounds];
    
    CGRect result = UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(topT,leftT,bottomT,rightT));
    
    return result;
}

@end


@implementation SMTextFieldDelegateHolder

@synthesize holdedTextField;

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    BOOL result = YES;
    
    if([holdedTextField.smdelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)])
        result = [holdedTextField.smdelegate textFieldShouldBeginEditing:textField];
    
    return result;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [holdedTextField.keyboardAvoiding adjustOffset];
    
    if([holdedTextField.smdelegate respondsToSelector:@selector(textFieldDidBeginEditing:)])
        [holdedTextField.smdelegate textFieldDidBeginEditing:textField];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    BOOL result = YES;
    
    if([holdedTextField.smdelegate respondsToSelector:@selector(textFieldShouldEndEditing:)])
        result = [holdedTextField.smdelegate textFieldShouldEndEditing:textField];
    
    return result;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([holdedTextField.smdelegate respondsToSelector:@selector(textFieldDidEndEditing:)])
        [holdedTextField.smdelegate textFieldDidEndEditing:textField];
}

- (BOOL)textField:(SMTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL result = YES;
    if (textField.filter)
        result = [textField.filter textInField:textField shouldChangeCharactersInRange:range replacementString:string];
    
    if(result && [textField formatter])
        result = [[textField formatter] formatWithNewCharactersInRange:range replacementString:string];
    
    // at this moment we should know latest version of textfield.text and
    // if formatter setuped he can format text by its own logic and returns result NO - even in this case we may want to make some stuff in delegate method
    if([holdedTextField.smdelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)])
        result &= [holdedTextField.smdelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    
    return result;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    BOOL result = YES;
    
    if([holdedTextField.smdelegate respondsToSelector:@selector(textFieldShouldClear:)])
        result = [holdedTextField.smdelegate textFieldShouldClear:textField];
    
    return result;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL result = YES;
    
    if([holdedTextField.smdelegate respondsToSelector:@selector(textFieldShouldReturn:)])
        result = [holdedTextField.smdelegate textFieldShouldReturn:textField];
    
    if(result)
        [holdedTextField.keyboardAvoiding responderShouldReturn:textField];
    
    return result;
}

@end
