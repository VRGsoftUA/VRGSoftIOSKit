//
//  SMEntryCell.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 3/30/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMCell.h"
#import "SMTextField.h"

@interface SMCellTextField : SMCell
{
    UILabel *titleLabel;
}

@property (nonatomic, readonly ) SMTextField* textField;

@end
