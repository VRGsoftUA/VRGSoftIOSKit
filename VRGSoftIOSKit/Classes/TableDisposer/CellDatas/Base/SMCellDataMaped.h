//
//  SMCellDataMaped.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 3/29/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMCellData.h"

@interface SMCellDataMaped : SMCellData
{
    NSString *key;
    NSObject *object;
}

@property (nonatomic, readonly) NSString *key;
@property (nonatomic, readonly) NSObject *object;

- (instancetype)initWithObject:(NSObject *)aObject key:(NSString *)aKey;

- (void)mapFromObject;
- (void)mapToObject;

@end
