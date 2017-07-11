//
//  SMCellDataTextView.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 04.04.12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMCellDataTextView.h"
#import "SMCellTextView.h"


@implementation SMCellDataTextView

@synthesize textAlignment;
@synthesize autocapitalizationType;
@synthesize autocorrectionType;
@synthesize keyboardType;
@synthesize keyboardAppearance;
@synthesize returnKeyType;

@synthesize validator;
@synthesize filter;

@synthesize placeholder;
@synthesize placeholderColor;

#pragma mark - Init/Dealloc

- (instancetype)initWithObject:(NSObject *)aObject key:(NSString *)aKey
{
    self = [super initWithObject:aObject key:aKey];
    if(self)
    {
        self.cellClass = [SMCellTextView class];
        self.cellSelectionStyle = UITableViewCellSelectionStyleNone;
        
        textAlignment = NSTextAlignmentLeft;
        autocapitalizationType = UITextAutocapitalizationTypeNone;
        autocorrectionType = UITextAutocorrectionTypeNo;
        keyboardType = UIKeyboardTypeDefault;
        keyboardAppearance = UIKeyboardAppearanceDefault;
        returnKeyType = UIReturnKeyDefault;
        
        self.cellHeight = 90;
    }
    return self;
}

@end
