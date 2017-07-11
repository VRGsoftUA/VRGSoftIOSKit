//
//  SMEntryCellData.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 3/30/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMCellDataTextPair.h"
#import "SMValidator.h"
#import "SMFilter.h"


@interface SMCellDataTextField : SMCellDataTextPair

@property(nonatomic, assign) BOOL textSecured;                                       ///< default is NO

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

@property (nonatomic, assign) UITextAutocapitalizationType autocapitalizationType;   ///< default is UITextAutocapitalizationTypeSentences
@property (nonatomic, assign) UITextAutocorrectionType autocorrectionType;           ///< default is UITextAutocorrectionTypeDefault
@property (nonatomic, assign) UIKeyboardType keyboardType;                           ///< default is UIKeyboardTypeDefault
@property (nonatomic, assign) UIKeyboardAppearance keyboardAppearance;               ///< default is UIKeyboardAppearanceDefault
@property (nonatomic, assign) UIReturnKeyType returnKeyType;                         ///< default is UIReturnKeyDefault

@property (nonatomic, retain) SMValidator *validator;
@property (nonatomic, retain) SMFilter *filter;

@end
