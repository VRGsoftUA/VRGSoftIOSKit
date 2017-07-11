//
//  SMCompoundValidator.m
//  VRGSoftIOSKit
//
//  Created by Alexander Burkhai on 6/12/13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMCompoundValidator.h"

@implementation SMCompoundValidator
@synthesize firstNotValideValidator;

- (instancetype)initWithValidators:(NSArray *)aValidators
{
    self = [super init];
    if (self)
    {        
        validators = [NSArray arrayWithArray:aValidators];
        self.successIfAtLeastOne = YES;
    }
    return self;
}

- (BOOL)validate
{
    NSAssert([validators count], @"count of validators should be more than 0");
    
    BOOL result = (self.successIfAtLeastOne) ? NO : YES;
    for (SMValidator *validator in validators)
    {
        validator.validatableObject = self.validatableObject;
        BOOL valid = [validator validate];
        if (valid && self.successIfAtLeastOne)
            return YES;
        else if (!valid && !self.successIfAtLeastOne)
            return NO;
    }
    
    return result;
}

- (SMValidator *)firstNotValideValidator
{
    SMValidator *result;
    for (SMValidator *validator in validators)
    {
        validator.validatableObject = self.validatableObject;
        BOOL valid = [validator validate];
        if (!valid)
        {
            result = validator;
            break;
        }
    }
    
    return result;
}

- (NSString *)errorMessage
{
    if (errorMessage)
    {
        return errorMessage;
    } else
    {
        return [self firstNotValideValidator].errorMessage;
    }
}

- (NSString *)titleMessage
{
    if (titleMessage)
    {
        return titleMessage;
    } else
    {
        return [self firstNotValideValidator].titleMessage;
    }
}

@end
