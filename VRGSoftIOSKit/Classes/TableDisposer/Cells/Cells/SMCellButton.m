//
//  SMButtonCell.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 3/30/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMCellButton.h"
#import "SMCellDataButton.h"

@implementation SMCellButton

- (void)setupCellData:(SMCellDataButton *)aCellData
{
    [super setupCellData:aCellData];
    
    self.textLabel.text = aCellData.title;
    self.textLabel.textAlignment = aCellData.titleAlignment;
    self.textLabel.textColor = aCellData.titleColor;
    self.textLabel.font = aCellData.titleFont;
}

@end
