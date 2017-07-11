//
//  SMCreditCardNumberFormatter.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 2/5/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//



@interface SMCreditCardNumberFormatter : NSObject

- (BOOL)cardFormatForTextField:(UITextField *)textField
 shouldChangeCharactersInRange:(NSRange)range
             replacementString:(NSString *)string
               separatorString:(NSString *)separatorString;
@end
