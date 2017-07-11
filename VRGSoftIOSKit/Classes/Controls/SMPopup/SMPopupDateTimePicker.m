//
//  SMPopupDateTimePicker.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 11/21/11.
//  Copyright (c) 2011 VRGSoft. all rights reserved.
//

#import "SMPopupDateTimePicker.h"

@implementation SMPopupDateTimePicker

#pragma mark - override next methods to customize:

- (UIView*)createPicker
{
    UIDatePicker* pv = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    pv.datePickerMode = UIDatePickerModeDateAndTime;
    
    [pv addTarget:self action:@selector(didPopupDatePickerChanged:) forControlEvents:UIControlEventValueChanged];

    return pv;
}

@end
