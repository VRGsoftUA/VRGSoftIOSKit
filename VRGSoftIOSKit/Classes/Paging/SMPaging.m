//
//  SMPaging.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 19.02.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMPaging.h"
#import "SMCompoundModel.h"

@interface SMPaging ()

@property (nonatomic, strong) SMGatewayRequest* fetchRequest;
@property (nonatomic, strong) SMCell<SMPagingMoreCellProtocol>* moreCell;

- (void)loadMoreDataPressed:(id)aSender;

@end

@implementation SMPaging

@synthesize needFetch;
@synthesize pagingConfig;
@synthesize tableDisposer;
@synthesize delegate;

@synthesize moreCell;
@synthesize reloading;
@synthesize loadingMore;
@synthesize lastUpdate;

@synthesize pageOffset;
@synthesize models;
@synthesize compoundModels;

#pragma mark - Init/Dealloc

- (instancetype)initWithConfig:(SMPagingConfig*)aPagingConfig
       tableDisposer:(SMTableDisposerModeled*)aTableDisposer
{
    self = [super init];
    if(self)
    {
        pagingConfig = aPagingConfig;
        tableDisposer = aTableDisposer;
        [tableDisposer addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [tableDisposer addModeledDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        // defaults
        needFetch = YES;
        pageOffset = 0;
        reloading = YES;
        loadingMore = NO;
        lastUpdate = nil;

        //
        models = [NSMutableArray new];
        compoundModels = [NSMutableArray new];
        
        //
        reachability = [AFNetworkReachabilityManager sharedManager];
        [reachability startMonitoring];
    
        //
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChangedNotification:)
                                                     name:AFNetworkingReachabilityDidChangeNotification object:nil];

        if(pagingConfig.useCompoundCells)
        {
            [tableDisposer registerCellData:[SMCompoundCellData class] forModel:[SMCompoundModel class]];
        }
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Load/Reload data

- (void)reloadData
{
    [self.fetchRequest cancel];
    pageOffset = 0;
    [models removeAllObjects];
    [compoundModels removeAllObjects];
    reloading = YES;
    self.needFetch = YES;
    [self fetchData];
}

- (void)loadMoreData
{
    if(pagingConfig.enablePaging)
    {
        pageOffset += pagingConfig.pageSize;
        loadingMore = YES;
        self.needFetch = YES;
        [self fetchData];
    }
}

- (NSArray*)didFetchData:(NSArray*)aData
{
    return aData;   // override if you need
}

- (void)setupModels:(NSArray*)aModels
{
    [tableDisposer removeAllSections];
    SMSectionReadonly* section = [SMSectionReadonly section];
    [tableDisposer addSection:section];
    
    [models addObjectsFromArray:aModels];
    tableDisposer.tableView.hidden = models.count == 0;
    
    if(pagingConfig.useCompoundCells)
    {
        NSArray* compoundModelsNew = [SMCompoundModel compoundModelsFromModels:aModels
                                                                groupedByCount:pagingConfig.compoundCellsGroupByCount];
        [compoundModels addObjectsFromArray:compoundModelsNew];
        [tableDisposer setupModels:compoundModels forSection:section];
    }
    else
    {
        [tableDisposer setupModels:models forSection:section];
    }
    
    if(pagingConfig.enablePaging)
    {
        if(aModels.count == pagingConfig.pageSize)
        {
            SMCellData<SMPagingMoreCellDataProtocol>* moreCellData = [delegate moreCellDataForPaging:self];
            if([moreCellData respondsToSelector:@selector(addTarget:action:)])
                [moreCellData addTarget:self action:@selector(loadMoreDataPressed:)];
            [section addCellData:moreCellData];
        }
        else
        {
            moreCell = nil;
        }
    }
    [tableDisposer reloadData];
}

#pragma mark - SMFetchable

- (void)fetchData
{
    if(!self.needFetch)
        return;
    
    if([delegate respondsToSelector:@selector(shouldFetchForPaging:)])
    {
        if(![delegate shouldFetchForPaging:self])
            return;
    }
    
    self.needFetch = NO;
    
    if(loadingMore)
        [moreCell didBeginDataLoading];
    
    if([delegate respondsToSelector:@selector(willBeginFetchingForPaging:)])
        [delegate willBeginFetchingForPaging:self];

    [self.fetchRequest cancel];
    __weak SMPaging* __self = self;
    self.fetchRequest = [delegate fetchRequestForPaging:self];
    [self.fetchRequest addResponseBlock:^(SMResponse *aResponse)
    {
        __self.fetchRequest = nil;
        __self.needFetch = aResponse.boArray.count == 0;
        if(__self.reloading)
        {
            if(aResponse.success)
                __self.lastUpdate = [NSDate date];
        }
        
        if([__self.delegate respondsToSelector:@selector(didCompleteFetchingForPaging:)])
            [__self.delegate didCompleteFetchingForPaging:__self];
        
        if(aResponse.success)
        {
            NSArray* fetchedModels = [__self didFetchData:aResponse.boArray];
            
            if([__self.delegate respondsToSelector:@selector(paging:didFetchedDataWithSuccess:)])
                fetchedModels = [__self.delegate paging:__self didFetchedDataWithSuccess:fetchedModels];
            
            [__self setupModels:fetchedModels];
        }
        else
        {
            [__self.moreCell didEndDataLoading];
            
            if([__self.delegate respondsToSelector:@selector(paging:didFetchedDataWithFailure:)])
                [__self.delegate paging:__self didFetchedDataWithFailure:aResponse];
        }
        
        __self.reloading = NO;
        __self.loadingMore = NO;
    } responseQueue:dispatch_get_main_queue()];
    [self.fetchRequest start];
}

#pragma mark - Actions

- (void)loadMoreDataPressed:(id)aSender
{
    [self loadMoreData];
}

#pragma mark - Notifications

- (void)reachabilityChangedNotification:(NSNotification*)aNotification
{
    if([reachability isReachable])
        [self reloadData];
}

#pragma mark - SMTableDisposerMulticastDelegate

- (void)tableDisposer:(SMTableDisposer*)aTableDisposer didCreateCell:(SMCell*)aCell
{
    if(aTableDisposer != tableDisposer)
        return;
    
//    if([aCell.cellData conformsToProtocol:@protocol(SMPagingMoreCellDataProtocol)])
//    {
//        moreCell = (SMCell<SMPagingMoreCellProtocol>*)aCell;
//    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(tableDisposer.tableView != tableView)
        return;
    
    if([cell conformsToProtocol:@protocol(SMPagingMoreCellProtocol)])
    {
        moreCell = (SMCell<SMPagingMoreCellProtocol>*)cell;
        if(pagingConfig.loadMoreDataType == SMLoadMoreDataTypeAuto)
            [self loadMoreData];
    }

//    if(pagingConfig.loadMoreDataType == SMLoadMoreDataTypeAuto)
//    {
//        if(cell == moreCell)
//        {
//            [self loadMoreData];
//        }
//    }
}

#pragma mark - SMTableDisposerModeledMulticastDelegate

- (void)tableDisposer:(SMTableDisposerModeled*)aTableDisposer didCreateCellData:(SMCellData*)aCellData
{
    if(aTableDisposer != tableDisposer)
        return;
    
    if(pagingConfig.useCompoundCells)
    {
        if([aCellData isKindOfClass:[SMCompoundCellData class]])
        {
            [(SMCompoundCellData*)aCellData setTableDisposer:tableDisposer];
        }
    }
}

@end
