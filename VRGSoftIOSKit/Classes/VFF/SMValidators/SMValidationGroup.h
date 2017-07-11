//
//  SMValidationGroup.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 10.07.11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMValidator.h"

@protocol SMValidationGroupDelegate;

@interface SMValidationGroup : NSObject
{
    NSMutableArray* validators;
    UIImage* invalidIndicatorImage;
}

@property (nonatomic, retain) UIImage* invalidIndicatorImage;
@property (nonatomic, assign) NSObject<SMValidationGroupDelegate>* delegate;

- (instancetype)initWithValidators:(NSArray <SMValidator *>*)aValidators;

- (void)addValidator:(SMValidator*)aValidator;
- (void)addValidators:(NSArray*)aValidators;
- (void)removeAllValidators;

- (NSArray <id <SMValidationProtocol>> *)validate;
- (void)hideInvalidIndicators;

- (void)showInvalidViewForField:(UITextField*)aTextField;
- (void)hideInvalidViewForField:(UITextField*)aTextField;

@end


@protocol SMValidationGroupDelegate <NSObject>
@optional
- (void)proccessValidationResults:(NSMutableArray*)aValidationResults;
- (void)prepareInvalidIndicatorView:(UITextField *)aTextField;
@end

