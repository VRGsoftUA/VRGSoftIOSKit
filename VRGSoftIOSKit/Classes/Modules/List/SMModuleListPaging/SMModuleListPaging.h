//
//  SMModuleListPaging.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 15.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMModuleList.h"
#import "SMPagingConfig.h"
#import "SMPagingMoreCellProtocols.h"
#import "SMFetcherMessagePaging.h"

@protocol SMModuleListPagingDelegate;

/**
 * GUI layer
 * ModuleList with paging
 **/
@interface SMModuleListPaging : SMModuleList <SMTableDisposerMulticastDelegate>
{
    SMCell<SMPagingMoreCellProtocol>* moreCell;
}

@property (nonatomic, readonly) NSUInteger initialPageOffset;
@property (nonatomic, readonly) BOOL itemsAsPage;
@property (nonatomic, assign) NSUInteger pageSize;
@property (nonatomic, assign) SMLoadMoreDataType loadMoreDataType;

@property (nonatomic, readonly) BOOL reloading;
@property (nonatomic, readonly) BOOL loadingMore;

@property (nonatomic, readonly) NSUInteger pageOffset;

- (instancetype)initWithTableDisposer:(SMTableDisposerModeled *)aTableDisposer
                    initialPageOffset:(NSUInteger)anInitialPageOffset
                          itemsAsPage:(BOOL)anItemsAsPage;

- (BOOL)setupMoreCellDataForSection:(SMSectionReadonly*)section withPagedModelsCount:(NSUInteger)modelsCount;

@end


@protocol SMModuleListPagingDelegate <SMModuleListDelegate>

- (SMCellData<SMPagingMoreCellDataProtocol>*)moreCellDataForPagingModule:(SMModuleListPaging*)aModule;
@optional
- (void)willLoadMoreModuleList:(SMModuleList *)aModuleList;

@end
