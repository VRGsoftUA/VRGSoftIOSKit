//
//  SMPopupPicker.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 8/11/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMPopupPicker.h"
#import "SMPopupPickerItemTitled.h"

#define SM_POPUPPICKER_VALUE_DID_CHANGE    @"SM_POPUPPICKER_VALUE_DID_CHANGE"

/**
 * This class can work with dataSource elements of classes MUTitledID or NSString, else generate assert.
 * This picker has only one component in pickerView.
 */
@interface SMPopupSimplePicker : SMPopupPicker <UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray* dataSource;
}

@property (nonatomic, copy) NSArray* dataSource;
@property (nonatomic, readonly) UIPickerView* popupedPicker;

@end
