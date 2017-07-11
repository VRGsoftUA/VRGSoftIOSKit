//
//  SMValidator.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 7/12/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import "SMValidator.h"

@implementation SMValidator

@synthesize validatableObject;
@synthesize errorMessage,titleMessage;

- (BOOL)validate
{
    return NO;
}

+ (BOOL)isCharCanBeInputByPhonePad:(char)c
{
    return (c >= '0' && c <= '9');
}

+ (NSString *)onlyNumbersStringFromText:(NSString *)aText
{
    NSMutableString *res = [NSMutableString new];
    for(int i = 0; i < [aText length]; i++)
    {
        char next = [aText characterAtIndex:i];
        if([self isCharCanBeInputByPhonePad:next])
            [res appendFormat:@"%c", next];
    }
    return res;
}

@end

@implementation SMValidatorAny

- (BOOL)validate
{
    return YES;
}

@end

@implementation SMValidatorNumber

- (BOOL)validate
{
    validatableObject.validatableText = [validatableObject.validatableText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSRegularExpression* regExp = [[NSRegularExpression alloc]initWithPattern:@"^[0-9]+$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger count = 0;
    if(validatableObject && validatableObject.validatableText)
        count = [regExp numberOfMatchesInString:validatableObject.validatableText options:0 range:NSMakeRange(0, [validatableObject.validatableText length])];
    return count == 1;
}

@end

@implementation SMValidatorLetters

- (BOOL)validate
{
    validatableObject.validatableText = [validatableObject.validatableText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSRegularExpression* regExp = [[NSRegularExpression alloc]initWithPattern:@"^[A-Za-z]+$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger count = 0;
    if(validatableObject && validatableObject.validatableText)
        count = [regExp numberOfMatchesInString:validatableObject.validatableText options:0 range:NSMakeRange(0, [validatableObject.validatableText length])];
    return count == 1;
}

@end

@implementation SMValidatorWords

- (BOOL)validate
{
    validatableObject.validatableText = [validatableObject.validatableText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSRegularExpression* regExp = [[NSRegularExpression alloc]initWithPattern:@"^([A-Za-z]| )+$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger count = 0;
    if(validatableObject && validatableObject.validatableText)
        count = [regExp numberOfMatchesInString:validatableObject.validatableText options:0 range:NSMakeRange(0, [validatableObject.validatableText length])];
    return count == 1;
}

@end

@implementation SMValidatorEmail

- (BOOL)validate
{
    validatableObject.validatableText = [validatableObject.validatableText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    static NSString* mailRegExp = @"^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\\.)+(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|asia|jobs|museum)$";
    NSRegularExpression* regExp = [[NSRegularExpression alloc]initWithPattern:mailRegExp options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger count = 0;
    if(validatableObject && validatableObject.validatableText)
        count = [regExp numberOfMatchesInString:validatableObject.validatableText options:0 range:NSMakeRange(0, [validatableObject.validatableText length])];
    return count == 1;
}

@end

@implementation SMValidatorEqual

@synthesize isIgnoreCase;

- (instancetype)initWithTestedField:(id<SMValidationProtocol>)aTestedObject
{
    if( (self = [super init]) )
    {
        testedValidator = [aTestedObject validator];
        isIgnoreCase = NO;
    }
    
    return self;
}

- (instancetype)initWithTestedFieldValidator:(SMValidator *)aTestedValidator
{
    if( (self = [super init]) )
    {
        testedValidator = aTestedValidator;
        isIgnoreCase = NO;
    }
    
    return self;
}

- (BOOL) validate
{
    validatableObject.validatableText = [validatableObject.validatableText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (isIgnoreCase)
    {
        BOOL result = ([validatableObject.validatableText compare:testedValidator.validatableObject.validatableText options:NSCaseInsensitiveSearch] == 0);
        return result;
    } else
    {
        return [validatableObject.validatableText isEqualToString:testedValidator.validatableObject.validatableText];
    }
}

@end

@implementation SMValidatorNotEmpty

- (BOOL)validate
{
    validatableObject.validatableText = [validatableObject.validatableText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [validatableObject.validatableText length] > 0;
}

@end

@implementation SMValidatorUSAZipCode

- (BOOL)validate
{
    validatableObject.validatableText = [validatableObject.validatableText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSRegularExpression* regExp = [[NSRegularExpression alloc]initWithPattern:@"^[0-9]+$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger count = 0;
    if(validatableObject && validatableObject.validatableText && [validatableObject.validatableText length] == 5)
    {
        count = [regExp numberOfMatchesInString:validatableObject.validatableText options:0 range:NSMakeRange(0, [validatableObject.validatableText length])];
    }
    return count == 1;
}

@end

@implementation SMValidatorFullName

- (BOOL)validate
{
    validatableObject.validatableText = [validatableObject.validatableText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSRegularExpression* regExp = [[NSRegularExpression alloc]initWithPattern:@"^([A-Za-zА-Яа-я])+ ([A-Za-zА-Яа-я])+$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger count = 0;
    if(validatableObject && validatableObject.validatableText)
        count = [regExp numberOfMatchesInString:validatableObject.validatableText options:0 range:NSMakeRange(0, [validatableObject.validatableText length])];
    return count == 1;
}

@end

@implementation SMValidatorURL

- (BOOL)validate
{
    validatableObject.validatableText = [validatableObject.validatableText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSRegularExpression* regExp = [[NSRegularExpression alloc]initWithPattern:@"^http(s)?://[a-z0-9-]+(.[a-z0-9-]+)+(:[0-9]+)?(/.*)?$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger count = 0;
    if(validatableObject && validatableObject.validatableText)
        count = [regExp numberOfMatchesInString:validatableObject.validatableText options:0 range:NSMakeRange(0, [validatableObject.validatableText length])];
    return count == 1;
}

@end

@implementation SMValidatorIntWithRange

- (instancetype)initWithRange:(NSRange)aRange
{
    self = [super init];
    if (self)
    {
        range = aRange;
    }
    return self;
}

- (BOOL)validate
{
    BOOL result = NO;
    validatableObject.validatableText = [validatableObject.validatableText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    int intValue = [validatableObject.validatableText intValue];
    result = intValue >= range.location && intValue <= range.location + range.length;
    return result;
}

@end

@implementation SMValidatorStringWithRange

- (instancetype)initWithRange:(NSRange)aRange
{
    self = [super init];
    if (self)
    {
        range = aRange;
    }
    return self;
}

- (BOOL)validate
{
    BOOL result = NO;
    validatableObject.validatableText = [validatableObject.validatableText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(validatableObject && validatableObject.validatableText && 
       [validatableObject.validatableText length] >= range.location &&
       [validatableObject.validatableText length] <= range.location + range.length)
        result = YES;
    return result;
}

@end

@implementation SMValidatorCountNumberInTextWithRange

- (instancetype)initWithRange:(NSRange)aRange
{
    self = [super init];
    if (self)
    {
        range = aRange;
    }
    return self;
}

- (BOOL)validate
{
    BOOL result = NO;
    validatableObject.validatableText = [validatableObject.validatableText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(validatableObject && validatableObject.validatableText)
    {
        NSString *onlyNumber = [self.class onlyNumbersStringFromText:validatableObject.validatableText];
        if (onlyNumber && [onlyNumber length] >= range.location && [onlyNumber length] <= range.location + range.length)
            result = YES;
    }
    return result;
}

@end

@implementation SMValidatorMoney

- (BOOL)validate
{
    validatableObject.validatableText = [validatableObject.validatableText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];    
    NSUInteger count = 0;    
    if(validatableObject && validatableObject.validatableText)
    {    
        NSRegularExpression* regExp = [[NSRegularExpression alloc]initWithPattern:@"^[1-9]+([0])?(\\.[0-9]{1,2})?$" options:NSRegularExpressionCaseInsensitive error:nil];
        count = [regExp numberOfMatchesInString:validatableObject.validatableText options:0 range:NSMakeRange(0, [validatableObject.validatableText length])];

        if (count == 0) 
        {
            regExp = [[NSRegularExpression alloc]initWithPattern:@"^[0]\\.[1-9]([0-9])?$" options:NSRegularExpressionCaseInsensitive error:nil];
            count = [regExp numberOfMatchesInString:validatableObject.validatableText options:0 range:NSMakeRange(0, [validatableObject.validatableText length])];
        }
        
        if (count == 0)
        {
            regExp = [[NSRegularExpression alloc]initWithPattern:@"^[0]\\.[0-9][1-9]$" options:NSRegularExpressionCaseInsensitive error:nil];
            count = [regExp numberOfMatchesInString:validatableObject.validatableText options:0 range:NSMakeRange(0, [validatableObject.validatableText length])];
        }
    }
    
    return count == 1;
}

@end

@implementation SMValidatorRegExp

@synthesize regularExpression;

- (instancetype)initWithRegExp:(NSRegularExpression *)aRegExp
{
    if( (self = [super init]) )
    {
        self.regularExpression = aRegExp;
    }
    return self;
}

- (BOOL)validate
{
    BOOL result = NO;
    
    validatableObject.validatableText = [validatableObject.validatableText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(validatableObject.validatableText)
    {
        NSUInteger count = 0;
        count = [regularExpression numberOfMatchesInString:validatableObject.validatableText options:0 range:NSMakeRange(0, [validatableObject.validatableText length])];
        
        result = count == 1;
    }
    
    return result;
}

@end


@implementation SMValidatorDomain

- (BOOL)validate
{
    validatableObject.validatableText = [validatableObject.validatableText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSUInteger count = 0;
    if(validatableObject && validatableObject.validatableText)
    {
        NSRegularExpression* regExp = [[NSRegularExpression alloc]initWithPattern:@"^(http://|https://|[a-zA-Z0-9])(([a-zA-Z0-9\\-]{0,90}[a-zA-Z0-9])?\\.)+[a-zA-Z]{2,6}$"
                                                                          options:NSRegularExpressionCaseInsensitive error:nil];
        count = [regExp numberOfMatchesInString:validatableObject.validatableText
                                        options:0
                                          range:NSMakeRange(0, [validatableObject.validatableText length])];
    }
    
    return count == 1;
}

@end
