//
//  SMPopupDatePicker.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 9/23/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMPopupPicker.h"

@interface SMPopupDatePicker : SMPopupPicker

@property (nonatomic, readonly) UIDatePicker* popupedPicker;

//!For override
- (void)didPopupDatePickerChanged:(id)sender;

@end
