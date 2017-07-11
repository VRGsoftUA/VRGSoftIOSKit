//
//  SMModuleLogin.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 11.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMTextField.h"
#import "SMValidationGroup.h"
#import "SMKeyboardAvoidingScrollView.h"
#import "SMGatewayRequest.h"
#import "SMActivityAdapter.h"
#import "SMHelper.h"

@class SMModuleLogin;

typedef void (^SMModuleLoginInvalidFieldCallback) (SMTextField* anInvalidTextField);
typedef SMGatewayRequest* (^SMModuleLoginRequestConfigurator)(NSString* aLogin, NSString* aPassword, __weak SMModuleLogin *moduleLogin);

/**
 * GUI layer
 * Use this module to manage login process.
 **/
@interface SMModuleLogin : NSObject <UITextFieldDelegate>
{
    __weak SMTextField* loginField;
    __weak SMTextField* passwordField;
    __weak UIButton* loginButton;
    
    SMValidator* defaultLoginValidator;
    SMValidator* defaultPasswordValidator;
    
    SMModuleLoginRequestConfigurator requestConfigurator;
}

#pragma mark - Validation logic
@property (nonatomic, strong, readonly) SMValidationGroup* validationGroup;
@property (nonatomic, copy) SMModuleLoginInvalidFieldCallback invalidLoginCallback;
@property (nonatomic, copy) SMModuleLoginInvalidFieldCallback invalidPasswordCallback;

@property (nonatomic, strong) NSString* internetUnreachableAlert;

@property (nonatomic, strong) SMActivityAdapter* activityAdapter;

#pragma mark - Settings
@property (nonatomic, assign) BOOL shouldLoginOnGoPressed;
@property (nonatomic, assign) BOOL autoHideActivityAdapter; // by default is YES

#pragma mark - Fields
@property (nonatomic, readonly) SMTextField* loginField;
@property (nonatomic, readonly) SMTextField* passwordField;
@property (nonatomic, readonly) UIButton* loginButton;

/**
 * Use this method to initialize module with defaul login (SMValidatorEmail) and password (SMValidatorNotEmpty) validators.
 **/
- (instancetype)initWithRequestConfigurator:(SMModuleLoginRequestConfigurator)aRequestConfigurator;

/**
 * Use this method to initialize module with custom login and password validators.
 **/
- (instancetype)initWithLoginValidator:(SMValidator*)aLoginValidator
           passwordValidator:(SMValidator*)aPasswordValidator
         requestConfigurator:(SMModuleLoginRequestConfigurator)aLoginRequestConfigurator;

/**
 * Use this method to setup textfields for login and password.
 * Call this method in -viewDidLoad method of view controller
 * Received fields don't retain (used weak reference)
 **/
- (void)configureWithLoginField:(SMTextField*)aLoginField
                  passwordField:(SMTextField*)aPasswordField
                    loginButton:(UIButton*)aLoginButton
                 controllerView:(UIView*)aControllerView;

/**
 * Use this method only to login programmatically
 **/
- (void)login;

@end
