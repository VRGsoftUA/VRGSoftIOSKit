//
//  SMBOCompoundModel.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 11.02.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMCompoundModel.h"

@implementation SMCompoundModel

#pragma mark - Init

- (instancetype)initWithModels:(NSArray*)aModels
{
    self = [super init];
    if(self)
    {
        _models = [NSArray arrayWithArray:aModels];
        _maxModelsCount = 1;
    }
    return self;
}

#pragma mark - 

+ (NSArray*)compoundModelsFromModels:(NSArray*)aModels
                        groupedByCount:(NSUInteger)aGroupCount
{
    NSMutableArray* result = [NSMutableArray array];

    SMCompoundModel* hub;
    NSArray* subarray;
    NSUInteger count = aModels.count;
    
    for(NSUInteger i = 0; i < count; i += aGroupCount)
    {
        subarray = [aModels subarrayWithRange:NSMakeRange(i, MIN(count - i, aGroupCount))];
        hub = [[SMCompoundModel alloc] initWithModels:subarray];
        hub.maxModelsCount = aGroupCount;
        [result addObject:hub];
    }
    
    return result;
}

@end
