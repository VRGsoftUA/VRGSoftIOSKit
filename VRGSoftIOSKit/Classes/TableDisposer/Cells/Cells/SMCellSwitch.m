//
//  SMBooleanCell.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 3/30/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMCellSwitch.h"
#import "SMCellDataSwitch.h"
#import "DCRoundSwitch.h"


@interface SMCellSwitch ()

- (void)didChangeBoolValueInSwitch:(UISwitch *) aSwitch;

@end

@implementation SMCellSwitch

- (void)setupCellData:(SMCellDataSwitch *)aCellData
{
    [super setupCellData:aCellData];
    
    id switcher = nil;
    
    if (aCellData.onText && aCellData.offText) 
    {
        switcher = [DCRoundSwitch new];
        ((DCRoundSwitch*)switcher).onText = aCellData.onText;
        ((DCRoundSwitch*)switcher).offText = aCellData.offText;
        ((DCRoundSwitch*)switcher).on = aCellData.boolValue;
        ((DCRoundSwitch*)switcher).enabled = aCellData.enableEdit;
    }
    else
    {
        switcher = [UISwitch new];
        ((UISwitch*)switcher).on = aCellData.boolValue;
        ((UISwitch*)switcher).enabled = aCellData.enableEdit;
        [switcher sizeToFit];
    }
    
    [switcher addTarget:self action:@selector(didChangeBoolValueInSwitch:) forControlEvents:UIControlEventValueChanged];
    
    self.accessoryView = switcher;
}

#pragma mark - Change Bool Value

- (void)didChangeBoolValueInSwitch:(UISwitch *) aSwitch
{
    ((SMCellDataSwitch*)self.cellData).boolValue = aSwitch.on;

    SMCellDataSwitch* cellData = (SMCellDataSwitch*)self.cellData;
    [cellData.targetAction sendActionFrom:cellData];
}

@end
