//
//  SMEntryCell.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 3/30/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMCellTextField.h"
#import "SMCellDataTextField.h"


@interface SMCellTextField ()

//- (void) didChangeValueInTextField:(UITextField *) aTextField;
- (void)didChangeValueInTextField:(NSNotification *) aNotification;

@end


@implementation SMCellTextField

@synthesize textField;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if( (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) )
    {
        textField = [[SMTextField alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width - 20, self.frame.size.height)];
        [self.contentView addSubview:textField];
        textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        [textField addTarget:self action:@selector(didChangeValueInTextField:) forControlEvents:UIControlEventEditingDidEnd];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeValueInTextField:) name:UITextFieldTextDidChangeNotification object:textField];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.backgroundColor = [UIColor clearColor];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.leftView = titleLabel;
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupCellData:(SMCellData *)aCellData
{
    [super setupCellData:aCellData];
    
    SMCellDataTextField *cellDataTextField = (SMCellDataTextField*)aCellData;
    
    textField.autocapitalizationType = cellDataTextField.autocapitalizationType;
    textField.autocorrectionType = cellDataTextField.autocorrectionType;
    textField.keyboardType = cellDataTextField.keyboardType;
    textField.keyboardAppearance = cellDataTextField.keyboardAppearance;
    textField.returnKeyType = cellDataTextField.returnKeyType;
    textField.secureTextEntry = cellDataTextField.textSecured;
    
    
    textField.font = cellDataTextField.textFont;
    textField.text = cellDataTextField.text;
    textField.textColor = cellDataTextField.textColor;
    textField.placeholder = cellDataTextField.placeholder;
    textField.enabled = cellDataTextField.enableEdit;
    
    textField.validator = cellDataTextField.validator;
    textField.filter = cellDataTextField.filter;
    
    if (cellDataTextField.placeholderColor)
        textField.placeholderColor = cellDataTextField.placeholderColor;

    if ([cellDataTextField.title length])
    {
        textField.textAlignment = NSTextAlignmentRight;

        CGSize titleLabelSize = [cellDataTextField.title sizeWithAttributes:@{NSFontAttributeName:cellDataTextField.titleFont}];
        titleLabel.frame = CGRectMake(0, 0, titleLabelSize.width + 10, titleLabelSize.height);
        titleLabel.text = cellDataTextField.title;
        titleLabel.textColor = cellDataTextField.titleColor;
        titleLabel.font = cellDataTextField.titleFont;
    }
    else
    {
        textField.textAlignment = NSTextAlignmentLeft;

        titleLabel.text = nil;
        titleLabel.frame = CGRectZero;
    }
}

- (NSArray *)inputTraits
{
    if (!self.cellData.disableInputTraits && self.cellData.enableEdit)
        return [NSArray arrayWithObject:textField];
    
    return nil;
}

- (void)didChangeValueInTextField:(NSNotification *) aNotification
{
    ((SMCellDataTextField*)self.cellData).text = textField.text;
}

@end



