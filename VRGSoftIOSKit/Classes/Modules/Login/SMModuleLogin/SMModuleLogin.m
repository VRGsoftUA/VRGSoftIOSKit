//
//  SMModuleLogin.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 11.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMModuleLogin.h"
#import "SMAlertView.h"

@interface SMModuleLogin ()

- (void)loginButtonPressed:(UIButton*)aSender;

@end

@implementation SMModuleLogin

@synthesize validationGroup;
@synthesize invalidLoginCallback, invalidPasswordCallback;
@synthesize internetUnreachableAlert;
@synthesize shouldLoginOnGoPressed, activityAdapter;

@synthesize loginField, passwordField, loginButton;

#pragma mark - Init/Dealloc

- (instancetype)initWithRequestConfigurator:(SMModuleLoginRequestConfigurator)aRequestConfigurator
{
    self = [self initWithLoginValidator:[SMValidatorEmail new]
                      passwordValidator:[SMValidatorNotEmpty new]
                    requestConfigurator:aRequestConfigurator];
    return self;
}

- (instancetype)initWithLoginValidator:(SMValidator*)aLoginValidator
           passwordValidator:(SMValidator*)aPasswordValidator
         requestConfigurator:(SMModuleLoginRequestConfigurator)aRequestConfigurator
{
    self = [super init];
    if(self)
    {
        defaultLoginValidator = aLoginValidator;
        defaultPasswordValidator = aPasswordValidator;
        requestConfigurator = aRequestConfigurator;
        
        self.autoHideActivityAdapter = YES;
        
        invalidLoginCallback = ^(SMTextField* anInvalidTextField)
        {
            if(anInvalidTextField.validator.errorMessage)
                SMShowSimpleAlert(nil, anInvalidTextField.validator.errorMessage);
            else
                SMShowSimpleAlert(nil, NSLocalizedString(@"Invalid login", nil));
        };
        invalidPasswordCallback = ^(SMTextField* anInvalidTextField)
        {
            if(anInvalidTextField.validator.errorMessage)
                SMShowSimpleAlert(nil, anInvalidTextField.validator.errorMessage);
            else
                SMShowSimpleAlert(nil, NSLocalizedString(@"Invalid password", nil));
        };
        internetUnreachableAlert = NSLocalizedString(@"No internet connection", nil);
    }
    return self;
}

#pragma mark - Configure

- (void)configureWithLoginField:(SMTextField*)aLoginField
                  passwordField:(SMTextField*)aPasswordField
                    loginButton:(UIButton*)aLoginButton
                 controllerView:(UIView*)aControllerView
{
    //
    [activityAdapter configureWithView:aControllerView];
    //
    
    loginField = aLoginField;
    passwordField = aPasswordField;
    loginButton = aLoginButton;
    
    //
    if(!loginField.validator)
        loginField.validator = defaultLoginValidator;
    if(!passwordField.validator)
        passwordField.validator = defaultPasswordValidator;
    
    NSArray* validators = @[loginField.validator, passwordField.validator];
    validationGroup = [[SMValidationGroup alloc] initWithValidators:validators];
    
    [loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    if([aControllerView isKindOfClass:[SMKeyboardAvoidingScrollView class]])
    {
        SMKeyboardAvoidingScrollView* scrollView = (SMKeyboardAvoidingScrollView*)aControllerView;
        [scrollView addObjectForKeyboard:loginField];
        [scrollView addObjectForKeyboard:passwordField];
    }
    
    if(shouldLoginOnGoPressed)
    {
        passwordField.smdelegate = self;
        passwordField.returnKeyType = UIReturnKeyGo;
    }
}

#pragma mark - Login actions

- (void)login
{
    NSArray* errorFields = [validationGroup validate];
    
    if (errorFields.count)
    {
        SMTextField* textField = [errorFields objectAtIndex:0];
        SMModuleLoginInvalidFieldCallback invalidCallback = (textField == loginField) ? (invalidLoginCallback) : (invalidPasswordCallback);
        if (invalidCallback)
            invalidCallback(textField);
    }
    else
    {
        [loginField resignFirstResponder];
        [passwordField resignFirstResponder];
        
        __weak SMModuleLogin *weakself = self;
        SMGatewayRequest* loginRequest = requestConfigurator(loginField.text, passwordField.text, weakself);
        
        if([loginRequest isInternetReachable])
        {
            if (self.autoHideActivityAdapter)
            {
                [loginRequest addResponseBlock:^(SMResponse *aResponse)
                 {
                     SMModuleLogin *strongself = weakself;
                     if (strongself)
                         [strongself->activityAdapter hideActivity:YES];
                 
                 } responseQueue:dispatch_get_main_queue()];
            }
            
            [activityAdapter showActivity:YES];
            [loginRequest start];
        }
        else
        {
            SMShowSimpleAlert(nil, internetUnreachableAlert);
        }
        
    }
}

- (void)loginButtonPressed:(UIButton*)aSender
{
    [self login];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == passwordField)
    {
        [self login];
    }
    return YES;
}

- (void)setShouldLoginOnGoPressed:(BOOL)aShouldLoginOnGoPressed
{
    shouldLoginOnGoPressed = aShouldLoginOnGoPressed;
    if(shouldLoginOnGoPressed)
    {
        passwordField.smdelegate = self;
        passwordField.returnKeyType = UIReturnKeyGo;
    }else
    {
        passwordField.smdelegate = nil;
        passwordField.returnKeyType = UIReturnKeyDone;
    }
}

@end
