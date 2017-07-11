//
//  SMPopupDatePicker.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 9/23/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import "SMPopupDatePicker.h"


@implementation SMPopupDatePicker

@synthesize popupedPicker;

#pragma mark - override next methods to customize:

- (UIView*)createPicker
{
    UIDatePicker* pv = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    pv.datePickerMode = UIDatePickerModeDate;
    [pv addTarget:self action:@selector(didPopupDatePickerChanged:) forControlEvents:UIControlEventValueChanged];
    return pv;
}

- (UIDatePicker*)popupedPicker
{
    return (UIDatePicker*)self->picker;
}

- (id)selectedItem
{
    return self.popupedPicker.date;
}

- (void)popupWillAppear:(BOOL)animated
{
    [super popupWillAppear:animated];
    
    // setup current value
    if(self->selectedItem)
    {
        if([self->selectedItem isKindOfClass:[NSDate class]])
        {
            self.popupedPicker.date = self->selectedItem;
        }
        else
        {
            NSAssert(NO, @"Wrong class type !!!");
        }
    }
}

- (void)didPopupDatePickerChanged:(id)sender
{
    if (self.selectHandler)
    {
        self.selectHandler(self,self.selectedItem);
    }
}

@end
