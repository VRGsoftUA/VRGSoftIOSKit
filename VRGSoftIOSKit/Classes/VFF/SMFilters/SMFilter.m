//
//  SMFilter.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 4/18/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMFilter.h"

/**
 * text filter : base class
 **/
@implementation SMFilter

@synthesize maxLengthText;

- (instancetype)init
{
    return [self initWithMaxLengthText:NSNotFound];
}

- (instancetype)initWithMaxLengthText:(NSUInteger)aMaxLengthText
{
    if( (self = [super init]) )
    {
        maxLengthText = aMaxLengthText;
    }
    return self;
}

- (BOOL)textInField:(id)inputField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL result = YES;
    
    if ([string length] > 0)
    {
        result = ([[[inputField text] stringByReplacingCharactersInRange:range withString:string] length]) <= maxLengthText;
    }
    return result;
}

@end

@implementation SMFilterNumbers

- (BOOL)textInField:(id)inputTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL result = YES;
    
    NSUInteger len = [string length];
    
    if (len > 0)
    {
        result = [string rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound;
        result &= ([[[inputTextField text] stringByReplacingCharactersInRange:range withString:string] length]) <= maxLengthText;
    }
    
    return result;
}

@end

/// text with only letters
@implementation SMFilterLetters

- (BOOL)textInField:(id)inputTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL result = YES;
    
    NSUInteger len = [string length];
    
    if (len > 0)
    {
//#warning wrong check if string contains characters not only from input set - in case of copy/paste operation when string for ex. 6611aaaww2 - same for other filters
        result = [string rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]].location != NSNotFound;
        result &= ([[[inputTextField text] stringByReplacingCharactersInRange:range withString:string] length]) <= maxLengthText;
    }
    
    return result;
}

@end

@implementation SMFilterLettersAndDigits

- (BOOL)textInField:(id)inputTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL result = YES;
    
    NSUInteger len = [string length];
    
    if(len > 0)
    {
        result = [string rangeOfCharacterFromSet:[NSCharacterSet alphanumericCharacterSet]].location != NSNotFound;
        result &= ([[[inputTextField text] stringByReplacingCharactersInRange:range withString:string] length]) <= maxLengthText;
    }
    
    return result;
}

@end

@implementation SMFilterRegExp

@synthesize regExp;

- (instancetype)init
{
    self = [self initWithMaxLengthText:NSNotFound andRegExp:nil];
    return self;
}

- (instancetype)initWithMaxLengthText:(NSUInteger)aMaxLengthText
                  andRegExp:(NSRegularExpression *)aRegExp
{
    self = [super init];
    if (self)
    {
        maxLengthText = aMaxLengthText;
        regExp = aRegExp;
    }
    return self;
}

- (BOOL)textInField:(id)inputTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL result = YES;
    NSString* newString = [[inputTextField text] stringByReplacingCharactersInRange:range withString:string];
    if ([regExp pattern].length > 0 && newString.length > 0)
    {
        NSUInteger count = [regExp numberOfMatchesInString:newString options:0 range:NSMakeRange(0, newString.length)];
        result = count == 1;
        result &= newString.length <= maxLengthText;
    }
    return result;
}

@end

@implementation SMFilterWithEditableRange

@synthesize editableRange;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        editableRange = NSMakeRange(NSNotFound, 0);
    }
    return self;
}

- (instancetype)initWithEditableRange:(NSRange)anEditableRange
{
    self = [super init];
    if (self)
    {
        editableRange = anEditableRange;
    }
    return self;
}

- (BOOL)textInField:(id)inputTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (editableRange.location == NSNotFound)
        return NO;
    
    BOOL result = YES;
    
    if ([string length] > 0)
    {
        if (editableRange.length == 0)
            return NO;
        
        result &= range.location >= editableRange.location;
        
        if (result && acceptableCharacters)
            result &= [string rangeOfCharacterFromSet:acceptableCharacters].location != NSNotFound;
        
        if (result)
        {
            NSString *newText = [[inputTextField text] stringByReplacingCharactersInRange:range withString:string];
            result &= [newText length] <= NSMaxRange(editableRange);
        }
    }
    else
    {
        result = range.location >= editableRange.location && NSMaxRange(range) <= NSMaxRange(editableRange);
    }
    
    return result;
}

@end

@implementation SMFilterNumbersWithEditableRange

- (instancetype)initWithEditableRange:(NSRange)anEditableRange
{
    self = [super initWithEditableRange:anEditableRange];
    if (self)
    {
        acceptableCharacters = [NSCharacterSet decimalDigitCharacterSet];
    }
    return self;
}

@end
