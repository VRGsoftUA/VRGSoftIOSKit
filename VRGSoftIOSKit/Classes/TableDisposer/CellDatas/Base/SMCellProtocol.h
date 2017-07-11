//
//  SMCellProtocol.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 3/29/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#ifndef VRGSoftIOSKit_SMCellProtocol_h
#define VRGSoftIOSKit_SMCellProtocol_h

#import "SMCellData.h"

@protocol SMCellProtocol <NSObject>

@property (nonatomic, readonly) SMCellData *cellData;

- (void)setupCellData:(SMCellData *)aCellData;

@end

#endif
