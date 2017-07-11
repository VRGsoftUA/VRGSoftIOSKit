//
//  SMPaging.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 19.02.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMPagingConfig.h"
#import "SMCompoundCell.h"
#import "SMGateway.h"
#import "SMFetchable.h"
#import "SMTableDisposerModeled.h"
#import "SMPagingMoreCellProtocols.h"

@protocol SMPagingDelegate;

@interface SMPaging : NSObject <SMFetchable, SMTableDisposerMulticastDelegate, SMTableDisposerModeledMulticastDelegate>
{
    AFNetworkReachabilityManager* reachability;
    SMCell<SMPagingMoreCellProtocol>* moreCell;
}

@property (nonatomic, readonly) SMPagingConfig* pagingConfig;
@property (nonatomic, readonly) SMTableDisposerModeled* tableDisposer;

@property (nonatomic, weak) id<SMPagingDelegate> delegate;

@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) BOOL loadingMore;
@property (nonatomic, strong) NSDate* lastUpdate;

@property (nonatomic, readonly) NSUInteger pageOffset;
@property (nonatomic, readonly) NSMutableArray* models;
@property (nonatomic, readonly) NSMutableArray* compoundModels;

#pragma mark - Init/Dealloc
- (instancetype)initWithConfig:(SMPagingConfig*)aPagingConfig
       tableDisposer:(SMTableDisposerModeled*)aTableDisposer;

#pragma mark - Load/Reload data
- (void)reloadData;
- (void)loadMoreData;
- (NSArray*)didFetchData:(NSArray*)aData;
- (void)setupModels:(NSArray*)aModels;

#pragma mark - Notifications
- (void)reachabilityChangedNotification:(NSNotification*)aNotification;

@end


@protocol SMPagingDelegate <NSObject>

- (SMGatewayRequest*)fetchRequestForPaging:(SMPaging*)aPaging;
- (SMCellData<SMPagingMoreCellDataProtocol>*)moreCellDataForPaging:(SMPaging*)aPaging;

@optional

- (BOOL)shouldFetchForPaging:(SMPaging*)aPaging;
- (void)willBeginFetchingForPaging:(SMPaging*)aPaging;
- (void)didCompleteFetchingForPaging:(SMPaging*)aPaging;

- (NSArray*)paging:(SMPaging*)aPaging didFetchedDataWithSuccess:(NSArray*)aData;
- (void)paging:(SMPaging*)aPaging didFetchedDataWithFailure:(SMResponse*)aResponse;

@end


