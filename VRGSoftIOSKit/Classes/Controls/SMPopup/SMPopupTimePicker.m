//
//  SMPopupTimePicker.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 9/29/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import "SMPopupTimePicker.h"
#import "SMKitDefines.h"

@implementation SMPopupTimePicker

#pragma mark - override next methods to customize:

- (UIView*)createPicker
{
    UIDatePicker* pv = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    pv.datePickerMode = UIDatePickerModeTime;
    
    [pv addTarget:self action:@selector(didPopupDatePickerChanged:) forControlEvents:UIControlEventValueChanged];

    return pv;
}

@end
