//
//  SMTableDisposerMaped.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 30.03.12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMTableDisposerMapped.h"

#import "SMCellDataMaped.h"
#import "SMKeyboardAvoidingTableView.h"

@interface SMTableDisposerMapped ()

- (void)mapFromObject;
@end

@implementation SMTableDisposerMapped

- (void)mapFromObject
{
    for(SMSectionReadonly* section in sections)
    {
        if([section isKindOfClass:[SMSectionWritable class]])
        {
            [(SMSectionWritable*)section mapFromObject];
        }
    }
}

- (void)mapToObject
{
    for(SMSectionReadonly* section in sections)
    {
        if([section isKindOfClass:[SMSectionWritable class]])
        {
            [(SMSectionWritable*)section mapToObject];
        }
    }
}

- (void)reloadData
{
    if([tableView isKindOfClass:[SMKeyboardAvoidingTableView class]])
    {
        [((SMKeyboardAvoidingTableView*)tableView) removeAllObjectsForKeyboard];
    }
    
    [self mapFromObject];
    
    for(SMSectionReadonly* section in sections)
    {
        [section updateCellDataVisibility];
    }
    [tableView reloadData];
}

@end
