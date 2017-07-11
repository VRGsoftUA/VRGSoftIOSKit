//
//  SMEntryCellData.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 3/30/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMCellDataTextField.h"
#import "SMCellTextField.h"


@implementation SMCellDataTextField

@synthesize textSecured;
@synthesize placeholder, placeholderColor;

@synthesize autocapitalizationType;
@synthesize autocorrectionType;
@synthesize keyboardType;
@synthesize keyboardAppearance;
@synthesize returnKeyType;

@synthesize validator;
@synthesize filter;

#pragma mark - Init/Dealloc

- (instancetype)initWithObject:(NSObject *)aObject key:(NSString *)aKey
{
    self = [super initWithObject:aObject key:aKey];
    if(self)
    {
        self.cellClass = [SMCellTextField class];
        self.cellSelectionStyle = UITableViewCellSelectionStyleNone;

        autocapitalizationType = UITextAutocapitalizationTypeNone;
        autocorrectionType = UITextAutocorrectionTypeNo;
        keyboardType = UIKeyboardTypeDefault;
        keyboardAppearance = UIKeyboardAppearanceDefault;
        returnKeyType = UIReturnKeyDefault;
    }
    return self;
}

@end
