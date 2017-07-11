//
//  SMPopupCustomSimplePicker.h
//  Pods
//
//  Created by VRGSoft on 28.07.13.
//
//

#import "SMPopupSimplePicker.h"
#import "SMPopupPickerItemTitled.h"

@interface SMPopupCustomSimplePicker : SMPopupSimplePicker

@property (nonatomic, weak) UIFont* font;
@property (nonatomic, strong) UIColor* textColor;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, strong) UIColor* shadowColor;
@property (nonatomic, assign) CGSize shadowOffset;

@end
