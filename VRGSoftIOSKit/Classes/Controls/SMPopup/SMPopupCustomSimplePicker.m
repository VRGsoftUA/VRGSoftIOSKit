//
//  SMPopupCustomSimplePicker.m
//  Pods
//
//  Created by VRGSoft on 28.07.13.
//
//

#import "SMPopupCustomSimplePicker.h"
#import "SMTitledID.h"

@implementation SMPopupCustomSimplePicker

- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* result = nil;

    // configure label
    if(!view)
    {
        result = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 270, 44)];
        result.backgroundColor = [UIColor clearColor];
        
        if(self.font)
            result.font = self.font;
        if(self.textColor)
            result.textColor = self.textColor;
        if(self.shadowColor)
            result.shadowColor = self.shadowColor;
        result.shadowOffset = self.shadowOffset;
        result.textAlignment = self.textAlignment;
    }
    else
    {
        result = (UILabel*)view;
    }
    
    // setup text
    if(row < dataSource.count)
    {
        NSObject* item = [dataSource objectAtIndex:row];
        if([item isKindOfClass:[SMTitledID class]])
            result.text = ((SMTitledID*)item).title;
        else if([item isKindOfClass:[NSString class]])
            result.text = (NSString*)item;
        else if([item conformsToProtocol:@protocol(SMPopupPickerItemTitled)])
            result.text = ((NSObject<SMPopupPickerItemTitled>*)item).itemTitle;
        else
        {
            NSAssert(NO, @"Wrong class in dataSource !!!");
        }
    }
    else
    {
        result.text = nil;
    }

    return result;
}

@end
