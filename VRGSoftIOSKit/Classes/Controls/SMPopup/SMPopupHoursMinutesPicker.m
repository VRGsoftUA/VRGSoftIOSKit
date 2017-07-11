//
//  SMPopupHoursMinutesPicker.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 12/6/11.
//  Copyright (c) 2011 VRGSoft. all rights reserved.
//

#import "SMPopupHoursMinutesPicker.h"


@implementation SMPopupHoursMinutesPicker

#pragma mark - Override next methods to customize:

- (UIView*)createPicker
{
    UIPickerView* pv = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    pv.dataSource = self;
    pv.delegate = self;
    pv.showsSelectionIndicator = YES;
    
    return pv;
}

- (UIPickerView*)popupedPicker
{
    return (UIPickerView*)picker;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return (component == 0) ? (24) : (60);
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@", @(row)];
}

- (id)selectedItem
{
    NSInteger hours = [self.popupedPicker selectedRowInComponent:0];
    NSInteger minutes = [self.popupedPicker selectedRowInComponent:1];
    return [NSNumber numberWithInteger:60 * hours + minutes];
}

- (void)popupWillAppear:(BOOL)animated
{
    [super popupWillAppear:animated];
    
    CGRect frame;
    
    // hours
    if(UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
        frame = CGRectMake(60, 130, 70, 44);
    else
        frame = CGRectMake(60, 90, 70, 44);

    UILabel* lbHours = [[UILabel alloc] initWithFrame:frame];
    lbHours.text = @"hours";
    lbHours.backgroundColor = [UIColor clearColor];
    [self addSubview:lbHours];

    // minutes
    if(UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
        frame = CGRectMake(200, 130, 70, 44);
    else
        frame = CGRectMake(370, 90, 70, 44);

    UILabel* lbMinutes = [[UILabel alloc] initWithFrame:frame];
    lbMinutes.text = @"minutes";
    lbMinutes.backgroundColor = [UIColor clearColor];
    lbMinutes.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self addSubview:lbMinutes];

    // setup current value
    if(selectedItem)
    {
        NSNumber* selNumber = selectedItem;
        [self.popupedPicker selectRow:[selNumber intValue] / 60 inComponent:0 animated:NO];
        [self.popupedPicker selectRow:[selNumber intValue] % 60 inComponent:1 animated:NO];
    }
}

@end
