//
//  SMPopupPicker.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 8/11/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import "SMPopupSimplePicker.h"
#import "SMTitledID.h"


@implementation SMPopupSimplePicker

@synthesize dataSource;

#pragma mark - override next methods to customize:

- (UIView*)createPicker
{
    UIPickerView* pv = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    pv.delegate = self;
    pv.dataSource = self;
    pv.showsSelectionIndicator = YES;
    
    return pv;
}

- (void)setDataSource:(NSArray *)aDataSource
{
    dataSource = [aDataSource copy];
    [self.popupedPicker reloadAllComponents];
}

- (UIPickerView*)popupedPicker
{
    return (UIPickerView*)picker;
}

#pragma mark - override next methods to change default behaviours

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [dataSource count];
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString* result = nil;
    if(row >= 0 && row < dataSource.count)
    {
        NSObject* item = [dataSource objectAtIndex:row];
        if([item isKindOfClass:[SMTitledID class]])
            result = ((SMTitledID*)item).title;
        else if([item isKindOfClass:[NSString class]])
            result = (NSString*)item;
        else if([item conformsToProtocol:@protocol(SMPopupPickerItemTitled)])
            result = ((NSObject<SMPopupPickerItemTitled>*)item).itemTitle;
        else
        {
            NSAssert(NO, @"Wrong class in dataSource !!!");
        }
    }
    
    return result;
}

//- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//   return nil;
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SM_POPUPPICKER_VALUE_DID_CHANGE object:self userInfo:nil];
    
    if (selectHandler)
    {
        selectHandler(self,self.selectedItem);
    }
}

- (id)selectedItem
{
    NSInteger index = [self.popupedPicker selectedRowInComponent:0];
    return  index < dataSource.count ? [dataSource objectAtIndex:index] : nil;
}

- (void)setSelectedItem:(NSObject *)aSelectedItem
{
    selectedItem = aSelectedItem;
    if(selectedItem)
    {
        NSUInteger index = [dataSource indexOfObject:selectedItem];
        if(index != NSNotFound)
        {
            [self.popupedPicker selectRow:index inComponent:0 animated:NO];
        }
    }
}

- (void)popupWillAppear:(BOOL)animated
{
    [super popupWillAppear:animated];
    self.selectedItem = selectedItem;

//    // setup current value
//    if(selectedItem)
//    {
//        NSUInteger index = [dataSource indexOfObject:selectedItem];
//        if(index != NSNotFound)
//        {
//            [self.popupedPicker selectRow:index inComponent:0 animated:NO];
//        }
//    }
}

@end
