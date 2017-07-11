//
//  SMCompoundValidator.h
//  VRGSoftIOSKit
//
//  Created by Alexander Burkhai on 6/12/13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMValidator.h"

@interface SMCompoundValidator : SMValidator
{
	NSArray* validators;
}

@property (nonatomic, assign) BOOL successIfAtLeastOne; // by default is YES

- (instancetype)initWithValidators:(NSArray*)aValidators;
@property (nonatomic, readonly) SMValidator *firstNotValideValidator;

@end
