//
//  SMCellDataModeled.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 3/29/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMCellData.h"

@interface SMCellDataModeled : SMCellData

@property (nonatomic, readonly) id model;

- (instancetype)initWithModel:(id)aModel;

@end
