//
//  SMFilter.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 4/18/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * text filter : base class
 **/
@interface SMFilter : NSObject
{
    NSUInteger maxLengthText;
}

@property (nonatomic, assign) NSUInteger maxLengthText;

- (instancetype)initWithMaxLengthText:(NSUInteger)aMaxLengthText;
- (BOOL)textInField:(id)inputField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string;

@end

/**
 * text with only number
 **/
@interface SMFilterNumbers : SMFilter

@end

/**
 * text with only letters
 **/
@interface SMFilterLetters : SMFilter

@end

/**
 *
 **/
@interface SMFilterLettersAndDigits : SMFilter

@end

/**
 *
 **/
@interface SMFilterRegExp : SMFilter
{
    NSRegularExpression *regExp;
}

@property (nonatomic, readonly) NSRegularExpression *regExp;

- (instancetype)initWithMaxLengthText:(NSUInteger)aMaxLengthText
                  andRegExp:(NSRegularExpression *)aRegExp;

@end

/**
 *
 **/
@interface SMFilterWithEditableRange : SMFilter
{
    NSRange editableRange;
    NSCharacterSet *acceptableCharacters;
}

@property (nonatomic, assign) NSRange editableRange;

- (instancetype)initWithEditableRange:(NSRange)anEditableRange;

@end

/**
 *
 **/
@interface SMFilterNumbersWithEditableRange : SMFilterWithEditableRange

@end
