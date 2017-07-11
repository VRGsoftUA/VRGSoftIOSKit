//
//  SMPopupHoursMinutesPicker.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 12/6/11.
//  Copyright (c) 2011 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMPopupPicker.h"

@interface SMPopupHoursMinutesPicker : SMPopupPicker <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, readonly) UIPickerView* popupedPicker;

@end
