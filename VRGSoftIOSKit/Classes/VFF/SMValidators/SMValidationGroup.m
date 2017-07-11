//
//  SMValidationGroup.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 10.07.11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMValidationGroup.h"
#import "SMValidator.h"

@interface SMValidationGroup ()
{
    NSMutableArray *textFields;
    NSMutableArray *rightViews;
}
- (void)showInvalidViewForField:(UITextField*)aTextField;

@end


@implementation SMValidationGroup

@synthesize invalidIndicatorImage;
@synthesize delegate;

#pragma mark - Init/Dealloc

- (instancetype)init
{
    return [self initWithValidators:nil];
}

- (instancetype)initWithValidators:(NSArray <SMValidator *>*)aValidators
{
    self = [super init];
    if(self)
    {
        validators = (aValidators) ? ([aValidators mutableCopy]) : ([NSMutableArray new]);
        textFields = [NSMutableArray new];
        rightViews = [NSMutableArray new];
    }
    
    return self;
}

#pragma mark - Validators

- (void)addValidator:(SMValidator*)aValidator
{
    NSParameterAssert(aValidator);
    [validators addObject:aValidator];
}

- (void)addValidators:(NSArray*)aValidators
{
    [validators addObjectsFromArray:aValidators];
}

- (void)removeAllValidators
{
    [validators removeAllObjects];
    [self hideInvalidIndicators];
}

#pragma mark - Validation

- (NSArray <id <SMValidationProtocol>> *)validate
{
    [self hideInvalidIndicators];
    NSMutableArray* result = [NSMutableArray array];
    NSMutableArray* validationResults = [NSMutableArray array];
    
    for (SMValidator *validator in validators)
    {
        [validationResults addObject: [NSNumber numberWithBool:[validator validate]]];
    }
    
    // to castom proccess any links between validatable vields
    if(delegate && [delegate respondsToSelector:@selector(proccessValidationResults:)])
    {
        [delegate proccessValidationResults:validationResults];
    }
    
    if ([validators count] == [validationResults count])
    {
        SMValidator *validator = nil;
        for(int i = 0; i < [validationResults count]; ++i)
        {
            validator = [validators objectAtIndex:i];
            if( ![[validationResults objectAtIndex:i] boolValue] )
            {
                [result addObject:validator.validatableObject];
                if ([validator.validatableObject isKindOfClass:[UITextField class]])
                {
                    [self showInvalidViewForField:(UITextField*)validator.validatableObject];
                }
            }
        }
    }
    else
    {
        NSAssert(nil, @"CTValidationGroup: [textFields count] != [validationResults count]");
    }
    
    return result;
}

- (void)showInvalidViewForField:(UITextField*)aTextField
{
    if (![textFields containsObject:aTextField])
    {
        [textFields addObject:aTextField];
        [rightViews addObject:(aTextField.rightView)?aTextField.rightView:[NSNull null]];
    }
    
    if (invalidIndicatorImage)
    {
        aTextField.rightView = [[UIImageView alloc] initWithImage:invalidIndicatorImage];
        aTextField.rightViewMode = UITextFieldViewModeAlways;
    } else if (delegate && [delegate respondsToSelector:@selector(prepareInvalidIndicatorView:)])
    {
        aTextField.rightViewMode = UITextFieldViewModeAlways;
        [delegate prepareInvalidIndicatorView:aTextField];
    }
}

- (void)hideInvalidViewForField:(UITextField*)aTextField
{
    if ([textFields containsObject:aTextField])
    {
        NSInteger i = [textFields indexOfObject:aTextField];
        id v = rightViews[i];
        if (![v isKindOfClass:[NSNull class]])
        {
            [aTextField setRightView:v];
        } else
        {
            [aTextField setRightView:nil];
        }
        
        
        [textFields removeObject:aTextField];
        [rightViews removeObject:v];
    }
}

- (void)hideInvalidIndicators
{
    for(UITextField *tf in textFields)
    {
        NSInteger i = [textFields indexOfObject:tf];
        id v = rightViews[i];
        if (![v isKindOfClass:[NSNull class]])
        {
            [tf setRightView:v];
        } else
        {
            [tf setRightView:nil];
        }
    }
    
    [textFields removeAllObjects];
    [rightViews removeAllObjects];
}

@end
