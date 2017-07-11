//
//  SMPagingConfig.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 19.02.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _SMLoadMoreDataType
{
    SMLoadMoreDataTypeAuto,
    SMLoadMoreDataTypeManual
    
} SMLoadMoreDataType;

@interface SMPagingConfig : NSObject

@property (nonatomic, assign) NSUInteger pageSize;
@property (nonatomic, assign) BOOL enablePaging;
@property (nonatomic, assign) SMLoadMoreDataType loadMoreDataType;
@property (nonatomic, assign) BOOL useCompoundCells;
@property (nonatomic, assign) NSUInteger compoundCellsGroupByCount;

@end
