//
//  SMSectionReadonly.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 29.03.12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMSectionReadonly.h"

@interface SMSectionWritable : SMSectionReadonly
{
    NSMutableArray* cells;
}

- (void)createCells;

- (void)mapFromObject;
- (void)mapToObject;

@end
