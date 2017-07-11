//
//  SMValidator.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 7/12/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>

@class SMValidator;

@protocol SMValidationProtocol <NSObject>

@property (nonatomic, assign) NSString* validatableText;

- (void)setValidator:(SMValidator*)aValidator;
- (SMValidator*)validator;
- (BOOL)validate;

@end

/**
 * Base validator
 **/
@interface SMValidator : NSObject
{
    __weak id<SMValidationProtocol> validatableObject;
    NSString *errorMessage;
    NSString *titleMessage;
}

@property (nonatomic, weak) id<SMValidationProtocol> validatableObject;
@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, strong) NSString *titleMessage;

- (BOOL)validate;

+ (NSString*)onlyNumbersStringFromText:(NSString*)aText;
+ (BOOL)isCharCanBeInputByPhonePad:(char)c;

@end


/**
 * Alwayse return YES
 **/
@interface SMValidatorAny : SMValidator
@end


/**
 * return YES for only numbers
 **/
@interface SMValidatorNumber : SMValidator
@end

/**
 * only english letters
 **/
@interface SMValidatorLetters : SMValidator
@end

/**
 * only english words
 **/
@interface SMValidatorWords : SMValidator
@end

/**
 * only email
 **/
@interface SMValidatorEmail : SMValidator
@end

/**
 * return YES if current value equal with value of testedValidator
 **/
@interface SMValidatorEqual : SMValidator
{
    SMValidator *testedValidator;
    BOOL isIgnoreCase;
}

- (instancetype)initWithTestedField:(id<SMValidationProtocol>)aTestedObject;
- (instancetype)initWithTestedFieldValidator:(SMValidator *)aTestedValidator;
@property(nonatomic,assign) BOOL isIgnoreCase;

@end

/**
 *
 **/
@interface SMValidatorNotEmpty : SMValidator
@end

/**
 *
 **/
@interface SMValidatorUSAZipCode : SMValidator
@end

/**
 *
 **/
/// full name consist of first name ' ' lastName
@interface SMValidatorFullName : SMValidator
@end

/**
 *
 **/
@interface SMValidatorURL : SMValidator
@end

/**
 *
 **/
///
@interface SMValidatorIntWithRange : SMValidator
{
    NSRange range;
}

- (instancetype)initWithRange:(NSRange)aRange;

@end

/**
 *
 **/
@interface SMValidatorStringWithRange : SMValidator
{
    NSRange range;
}

- (instancetype)initWithRange:(NSRange)aRange;

@end

/**
 * validation count number in phone number. Example: (050)-50-50-500
 **/
@interface SMValidatorCountNumberInTextWithRange : SMValidator
{
    NSRange range;
}

- (instancetype)initWithRange:(NSRange)aRange;

@end


/**
 *
 **/
@interface SMValidatorMoney : SMValidator
@end

/**
 *
 **/
@interface SMValidatorRegExp : SMValidator

@property (nonatomic, retain) NSRegularExpression* regularExpression;

- (instancetype)initWithRegExp:(NSRegularExpression*)aRegExp;

@end

/**
 *
 **/
@interface SMValidatorDomain : SMValidator
@end

