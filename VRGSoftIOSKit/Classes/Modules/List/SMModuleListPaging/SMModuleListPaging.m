//
//  SMModuleListPaging.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 15.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMModuleListPaging.h"
#import "SMModuleListPaging+Private.h"
#import "SMCompoundModel.h"

@implementation SMModuleListPaging

@synthesize itemsAsPage;
@synthesize initialPageOffset;
@synthesize pageSize, pageOffset;
@synthesize loadMoreDataType;

@synthesize reloading, loadingMore;

- (instancetype)initWithTableDisposer:(SMTableDisposerModeled *)aTableDisposer
{
    return [self initWithTableDisposer:aTableDisposer initialPageOffset:0 itemsAsPage:NO];
}

- (instancetype)initWithTableDisposer:(SMTableDisposerModeled *)aTableDisposer
                    initialPageOffset:(NSUInteger)anInitialPageOffset
                          itemsAsPage:(BOOL)anItemsAsPage
{
    self = [super initWithTableDisposer:aTableDisposer];
    if(self)
    {
        itemsAsPage = anItemsAsPage;
        initialPageOffset = anInitialPageOffset;
        
        pageSize = 20;
        loadMoreDataType = SMLoadMoreDataTypeAuto;
        pageOffset = initialPageOffset;
        
        models = [NSMutableArray new];
        compoundModels = [NSMutableArray new];
        [defaultTableDisposer addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}

- (void)setDelegate:(id<SMModuleListDelegate>)aDelegate
{
    NSAssert([aDelegate conformsToProtocol:@protocol(SMModuleListPagingDelegate)],
             @"SMModuleListPaging delegate should conform SMModuleListPagingDelegate protocol");
    delegate = aDelegate;
}

#pragma mark - Reload

- (void)reloadData
{
    SMFetcherMessagePaging *nextMessage = (SMFetcherMessagePaging*)[self fetcherMessage];
    nextMessage.pagingOffset = initialPageOffset;
    nextMessage.reloading = YES;
    nextMessage.loadingMore = NO;
    
    //    SMLog(@"---reloaddata---, %d  %d", reloading, loadingMore);
    
    if([self.dataFetcher canFetchWithMessage:nextMessage])
    {
        //        SMLog(@"---reloaddata---, %d  %d", reloading, loadingMore);
        pageOffset = nextMessage.pagingOffset;
        reloading = nextMessage.reloading;
        loadingMore = nextMessage.loadingMore;
        //        SMLog(@"---reloaddata---, %d  %d", reloading, loadingMore);
    }
    if([self.delegate respondsToSelector:@selector(willReloadModuleList:)])
        [self.delegate willReloadModuleList:self];
    
    [self fetchDataWithMessage:nextMessage];
    //    SMLog(@"---reloaddata---, %d  %d", reloading, loadingMore);
}

#pragma mark - Load more

- (void)loadMoreData
{
    if (reloading)
        return;
    
    if([self.delegate respondsToSelector:@selector(willLoadMoreModuleList:)])
        [(id<SMModuleListPagingDelegate>)self.delegate willLoadMoreModuleList:self];

    if(itemsAsPage)
        pageOffset += 1;
    else
        pageOffset += pageSize;
    
    loadingMore = YES;
    
    [self fetchDataWithMessage:[self fetcherMessage]];
}

- (void)willFetchDataWithMessage:(SMFetcherMessagePaging *)aMessage
{
    if (!self.isHideActivityAdapterForOneFetch)
    {
        if (reloading && (!self.isSearchEnabled || (self.isSearchEnabled && self.isUseActivityAdapterWithSearch)))
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.activityAdapter showActivity:YES];
            });
        }
    }
    
    if(aMessage.loadingMore)
        [moreCell didBeginDataLoading];
    else
    {
        if (!self.isHideActivityAdapterForOneFetch)
        {
            if (reloading && (!self.isSearchEnabled || (self.isSearchEnabled && self.isUseActivityAdapterWithSearch)))
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.activityAdapter showActivity:YES];
                });
            }
        }
    }
    
    if([self.delegate respondsToSelector:@selector(willFetchDataForModuleList:)])
        [self.delegate willFetchDataForModuleList:self];
    
    self.isHideActivityAdapterForOneFetch = NO;
}

- (void)didFetchDataWithMessage:(SMFetcherMessagePaging *)aMessage andResponse:(SMResponse *)aResponse
{
    [super didFetchDataWithMessage:aMessage andResponse:aResponse];
    
    BOOL success = aResponse.success;
    //    CTLog(@"did fetch modulelistpaging with success----- %d --- cancelled -- %d reloading -- %d loadingmore -- %d", success, aResponse.isRequestCancelled, aMessage.reloading, aMessage.loadingMore);
    
    if(success)
    {
        if(aMessage.reloading)
        {
            //            CTLog(@"remove all objects from models with count -- %d", models.count);
            [models removeAllObjects];
            [compoundModels removeAllObjects];
        }
        else if (aMessage.loadingMore)
        {
            [moreCell didEndDataLoading];
        }
    }
    
    if (aMessage.reloading)
        reloading = NO;
    else if (aMessage.loadingMore)
        loadingMore = NO;
}

#pragma mark - Message

- (Class)fetcherMessageClass
{
    return [SMFetcherMessagePaging class];
}

- (void)configureFetcherMessage:(SMFetcherMessagePaging*)aMessage
{
    [super configureFetcherMessage:aMessage];
    aMessage.pagingOffset = pageOffset;
    aMessage.pagingSize = pageSize;
    aMessage.reloading = reloading;
    aMessage.loadingMore = loadingMore;
}

#pragma mark - Setup

- (void)setupModels:(NSArray*)aModels forSection:(SMSectionReadonly *)aSection
{
    [models addObjectsFromArray:aModels];
    if (self.tableDisposer.useCompoundCells)
        [compoundModels addObjectsFromArray:[SMCompoundModel compoundModelsFromModels:aModels
                                                                       groupedByCount:self.defaultCompoundMaxModelsCount]];
    
    [self.tableDisposer setupModels:(self.tableDisposer.useCompoundCells) ? (compoundModels) : (models)
                         forSection:aSection];
    
    [self setupMoreCellDataForSection:aSection withPagedModelsCount:aModels.count];
}

- (BOOL)setupMoreCellDataForSection:(SMSectionReadonly*)section withPagedModelsCount:(NSUInteger)modelsCount
{
    moreCell = nil;
    if ((modelsCount == self.pageSize && self.pageSize) && section && [self.delegate respondsToSelector:@selector(moreCellDataForPagingModule:)])
    {
        SMCellData<SMPagingMoreCellDataProtocol>* moreCellData = [(id<SMModuleListPagingDelegate>)self.delegate moreCellDataForPagingModule:self];
        if (moreCellData)
        {
            if ([moreCellData respondsToSelector:@selector(addTarget:action:)])
                [moreCellData addTarget:self action:@selector(loadMoreDataPressed:)];
            [section addCellData:moreCellData];
            return YES;
        }
    }
    return NO;
}

#pragma mark - SMTableDisposerMulticastDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(self.tableDisposer.tableView != tableView)
        return;
    
    if([cell conformsToProtocol:@protocol(SMPagingMoreCellProtocol)])
    {
        moreCell = (SMCell<SMPagingMoreCellProtocol>*)cell;
        if(loadMoreDataType == SMLoadMoreDataTypeAuto)
            [self loadMoreData];
    }
}

#pragma mark - Actions

- (void)loadMoreDataPressed:(id)aSender
{
    [self loadMoreData];
}

@end
