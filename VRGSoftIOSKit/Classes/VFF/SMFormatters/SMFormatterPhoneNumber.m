//
//  SMFormatterPhoneNumber.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 12/14/11.
//  Copyright (c) 2011 VRGSoft. all rights reserved.
//

#import "SMFormatterPhoneNumber.h"

@interface SMFormatterPhoneNumber ()

- (BOOL)phoneFormatForTextField:(UITextField *)textField
  shouldChangeCharactersInRange:(NSRange)range
              replacementString:(NSString *)string
                     withLocale:(NSString *)locale;

/*
 Attemps to format the phone number to the specified locale.
 */
- (NSString *)format:(NSString *)phoneNumber withLocale:(NSString *)locale;

/*
 Strips the input string from characters added by the formatter.
 Namely, it removes any character that couldn't have been entered by the user.
 */
- (NSString *)strip:(NSString *)phoneNumber;

/*
 Returns true if the character comes from a phone pad.
 */
- (BOOL)canBeInputByPhonePad:(unichar)c;

@end

@implementation SMFormatterPhoneNumber

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSArray *usPhoneFormats = [NSArray arrayWithObjects:
                                   @"+1 (###) ###-####",
                                   @"1 (###) ###-####",
                                   @"011 $",
                                   @"###-####",
                                   @"(###) ###-####", nil];
        
        NSArray *ukPhoneFormats = [NSArray arrayWithObjects:
                                   @"+44 ##########",
                                   @"00 $",
                                   @"0### - ### ####",
                                   @"0## - #### ####",
                                   @"0#### - ######", nil];
        
        
        NSArray *jpPhoneFormats = [NSArray arrayWithObjects:
                                   @"+81 ############",
                                   @"001 $",
                                   @"(0#) #######",
                                   @"(0#) #### ####", nil];
        
        NSArray *ruPhoneFormats = [NSArray arrayWithObjects:
                                   @"+7 (###) ###-####",
                                   @"7 (###) ###-####",
                                   @"(###) ###-####",
                                   @"(#####) ##-###",
                                   @"8 (###) ###-####",
                                   nil];
        
        NSArray *uaPhoneFormats = [NSArray arrayWithObjects:
                                   @"+380 ## ###-##-##",
                                   @"380 ## ###-##-##",
                                   @"0## ###-##-##",
                                   @"(###) ###-##-##",
                                   nil];
        predefinedFormats = [[NSDictionary alloc] initWithObjectsAndKeys:
                             usPhoneFormats, @"us",
                             ukPhoneFormats, @"uk",
                             jpPhoneFormats, @"jp",
                             ruPhoneFormats, @"ru",
                             uaPhoneFormats, @"ua",
                             nil];
        acceptableInputCharacters = [NSCharacterSet characterSetWithCharactersInString:@"+*#0123456789"];
    }
    return self;
}

- (BOOL)formatWithNewCharactersInRange:(NSRange)aRange replacementString:(NSString*)aString
{
    UITextField* textField = (UITextField*)self.formattableObject;
    return [self phoneFormatForTextField:textField shouldChangeCharactersInRange:aRange replacementString:aString withLocale:self.locale];
}

- (BOOL)phoneFormatForTextField:(UITextField *)textField
  shouldChangeCharactersInRange:(NSRange)range
              replacementString:(NSString *)string
                     withLocale:(NSString *)locale
{
    BOOL result = NO;
    if ([string length] > 0)
    {
        if ([string rangeOfCharacterFromSet:acceptableInputCharacters].location != NSNotFound)
        {
            NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
            text = [self format:text withLocale:locale];
            if (text)
                textField.text = text;
        }
    }
    else
    {
        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        text = [self format:text withLocale:locale];
        if (text)
            textField.text = text;
    }
    
    return result;
}

- (NSString *)formattedTextFromString:(NSString *)aOriginalString
{
    NSString *result = [self format:aOriginalString withLocale:self.locale];
    if (result)
        return result;
    
    return aOriginalString; // cant format input string
}

- (NSString *)format:(NSString *)phoneNumber withLocale:(NSString *)locale
{
    NSArray *localeFormats = [predefinedFormats objectForKey:locale];
    if(localeFormats == nil)
        return phoneNumber;
    
    NSString *input = [self strip:phoneNumber];
    for(NSString *phoneFormat in localeFormats)
    {
        int i = 0;
        NSMutableString *temp = [NSMutableString new];
        
        for(int p = 0; temp != nil && i < [input length] && p < [phoneFormat length]; p++)
        {
            unichar c = [phoneFormat characterAtIndex:p];
            BOOL required = [self canBeInputByPhonePad:c];
            unichar next = [input characterAtIndex:i];
            
            switch(c)
            {
                case '$':
                    p--;
                    [temp appendFormat:@"%c", next];
                    i++;
                    break;
                case '#':
                    if(next < '0' || next > '9')
                    {
                        temp = nil;
                        break;
                    }
                    [temp appendFormat:@"%c", next]; i++;
                    break;
                default:
                    if(required)
                    {
                        if(next != c)
                        {
                            temp = nil;
                            break;
                        }
                        [temp appendFormat:@"%c", next]; i++;
                        
                    }
                    else
                    {
                        [temp appendFormat:@"%c", c];
                        if(next == c) i++;
                    }
                    break;
            }
        }
        if(i == [input length])
        {
            return temp;
        }
    }
    
    if (self.acceptsNotPredefinedFormattedPhoneNumber)
        return input;
    else
        return nil;
}

- (NSString *)strip:(NSString *)phoneNumber
{
    NSMutableString *res = [NSMutableString new];
    for(int i = 0; i < [phoneNumber length]; i++)
    {
        unichar next = [phoneNumber characterAtIndex:i];
        if([self canBeInputByPhonePad:next])
            [res appendFormat:@"%c", next];
    }
    return res;
}

- (BOOL)canBeInputByPhonePad:(unichar)c
{
    return [acceptableInputCharacters characterIsMember:c];
}

- (NSString*)rawText
{
    return (self.formattableObject.formattingText) ? ([self strip:self.formattableObject.formattingText]) : (nil);
}

@end
