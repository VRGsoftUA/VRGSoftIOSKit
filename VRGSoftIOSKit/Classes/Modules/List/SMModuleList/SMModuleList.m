//
//  SMModuleList.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 15.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMModuleList.h"
#import "SMCompoundModel.h"
#import "SMKitDefines.h"

@implementation SMModuleList

@synthesize delegate, lastUpdateDate,delegateSearch;
@synthesize pullToRefreshAdapter;
@synthesize moduleQueue;
@synthesize isSearchEnabled,minSearchStringLength;
@dynamic models;
@dynamic compoundModels;

#pragma mark - Init/Dealloc

- (instancetype)initWithTableDisposer:(SMTableDisposerModeled*)aTableDisposer
{
    self = [super init];
    if(self)
    {
        defaultTableDisposer = aTableDisposer;
        [defaultTableDisposer addModeledDelegate:self delegateQueue:dispatch_get_main_queue()];
        moduleQueue = dispatch_queue_create("com.caiguda.SMModuleList", NULL);
        minSearchStringLength = 0;
        self.isUseActivityAdapterWithPullToRefreshAdapter = YES;
        self.isUseActivityAdapterWithSearch = YES;
    }
    return self;
}

- (void)dealloc
{
    [self.dataFetcher cancelFetching];
#if SM_NEEDS_DISPATCH_RETAIN_RELEASE
    if (moduleQueue)
        dispatch_release(moduleQueue);
#endif
    moduleQueue = NULL;
}

#pragma mark - Properties

- (SMTableDisposerModeled *)tableDisposer
{
    if (self.isSearchEnabled && [self.searchStrategy isSearchActive])
        return self.searchStrategy.tableDisposer;
    
    return defaultTableDisposer;
}

- (void)setDataFetcher:(id<SMDataFetcher>)dataFetcher
{
    _dataFetcher = dataFetcher;
    _dataFetcher.callbackQueue = moduleQueue;
}

- (void)setSearchStrategy:(SMSearchListStrategy *)searchStrategy
{
    _searchStrategy = searchStrategy;
    _searchStrategy.delegate = self;
}

- (void)setPullToRefreshAdapter:(SMPullToRefreshAdapter *)aPullToRefreshAdapter
{
    __weak SMModuleList* __self = self;
    pullToRefreshAdapter = aPullToRefreshAdapter;
    pullToRefreshAdapter.refreshCallback = ^(SMPullToRefreshAdapter* aPullToRefreshAdapter)
    {
        if (!__self.isUseActivityAdapterWithPullToRefreshAdapter)
        {
            __self.isHideActivityAdapterForOneFetch = YES;
        }
        
        [__self reloadData];
    };
}

- (NSArray *)models
{
    return [NSArray arrayWithArray:models];
}

- (NSArray *)compoundModels
{
    return [NSArray arrayWithArray:compoundModels];
}

#pragma mark - Views

- (void)configureWithView:(UIView*)aView
{
    [pullToRefreshAdapter configureWithTableView:defaultTableDisposer.tableView];
    [_activityAdapter configureWithView:aView];
}

#pragma mark - Data fetching

- (void)fetchDataWithMessage:(SMFetcherMessage *)aMessage
{
    if([self.dataFetcher canFetchWithMessage:aMessage])
    {
        [self.dataFetcher cancelFetching];
        [self willFetchDataWithMessage:aMessage];
        
        __weak SMModuleList* __self = self;
        [self.dataFetcher fetchDataByMessage:aMessage withCallback:^(SMResponse *aResponse)
         {
             dispatch_sync(dispatch_get_main_queue(), ^ {
                 
                 [__self didFetchDataWithMessage:aMessage andResponse:aResponse];
                 if(aResponse.success)
                 {
                     NSArray* aModels = [__self processFetchedModelsInResponse:aResponse];
                     
                     [__self prepareSections];
                     
                     NSUInteger numberOfPrepareSections = 0;
                     if (aModels.count)
                     {
                         for (NSInteger i = 0; i < aModels.count; i++)
                         {
                             id obj = aModels[i];
                             
                             NSArray *ms;
                             if ([obj isKindOfClass:[NSArray class]])
                             {
                                 ms = obj;
                             } else
                             {
                                 NSMutableArray *mutMs = [NSMutableArray new];
                                 
                                 for (NSInteger j = i; j < aModels.count; j++)
                                 {
                                     i = j;
                                     if (![aModels[j] isKindOfClass:[NSArray class]])
                                     {
                                         [mutMs addObject:aModels[j]];
                                     } else
                                     {
                                         i--;
                                         break;
                                     }
                                 }
                                 ms = [NSArray arrayWithArray:mutMs];
                             }
                             
                             [__self updateSectionWithModels:ms sectionIndex:numberOfPrepareSections];
                             numberOfPrepareSections++;
                         }
                     } else
                     {
                         [__self updateSectionWithModels:aModels sectionIndex:numberOfPrepareSections];
                         numberOfPrepareSections++;
                     }
                     
                     [__self.tableDisposer reloadData];
                     if([__self.delegate respondsToSelector:@selector(moduleList:didReloadDataWithModels:)])
                         [__self.delegate moduleList:__self didReloadDataWithModels:aModels];
                 }
                 else if (!aResponse.requestCancelled)
                 {
                     if(__self.fetcherFailedCallback)
                         __self.fetcherFailedCallback(__self, aResponse);
                 }
             });
         }];
    }
    else
    {
        [self.pullToRefreshAdapter endPullToRefresh];
        
        if(self.fetcherCantFetchCallback)
            self.fetcherCantFetchCallback(self, aMessage);
    }
}

- (void)updateSectionWithModels:(NSArray *)aModels sectionIndex:(NSUInteger )aSectionIndex
{
    SMSectionReadonly* sectionForModels = nil;
    
    if([self.delegate respondsToSelector:@selector(moduleList:sectionForModels:indexOfSection:)])
        sectionForModels = [self.delegate moduleList:self sectionForModels:aModels indexOfSection:aSectionIndex];
    
    if(!sectionForModels && [self.tableDisposer sectionsCount] && [self.tableDisposer sectionsCount] > aSectionIndex)
        sectionForModels = [self.tableDisposer sectionByIndex:aSectionIndex];
    
    [self setupModels:aModels forSection:sectionForModels];
}

- (void)willFetchDataWithMessage:(SMFetcherMessage *)aMessage
{
    if (!self.isHideActivityAdapterForOneFetch)
    {
        if (!self.isSearchEnabled || (self.isSearchEnabled && self.isUseActivityAdapterWithSearch))
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.activityAdapter showActivity:YES];
            });
        }
    }
    
    if([self.delegate respondsToSelector:@selector(willFetchDataForModuleList:)])
        [self.delegate willFetchDataForModuleList:self];
    
    self.isHideActivityAdapterForOneFetch = NO;
}

- (void)didFetchDataWithMessage:(SMFetcherMessage *)aMessage andResponse:(SMResponse *)aResponse
{
    [self.activityAdapter hideActivity:YES];
    [self.pullToRefreshAdapter endPullToRefresh];
    
    if(aResponse.success)
        lastUpdateDate = [NSDate date];
    
    if([self.delegate respondsToSelector:@selector(didFetchDataForModuleList:)])
        [self.delegate didFetchDataForModuleList:self];
}

- (void)reloadData
{
    models = nil;
    if([self.delegate respondsToSelector:@selector(willReloadModuleList:)])
        [self.delegate willReloadModuleList:self];
    
    [self fetchDataWithMessage:[self fetcherMessage]];
}

#pragma mark - Message

- (Class)fetcherMessageClass
{
    return [SMFetcherMessage class];
}

- (SMFetcherMessage*)createFetcherMessage
{
    SMFetcherMessage* message = nil;
    if([self.delegate respondsToSelector:@selector(fetcherMessageForModuleList:)])
        message = [self.delegate fetcherMessageForModuleList:self];
    
    if(message)
    {
        if(![message isKindOfClass:self.fetcherMessageClass])
        {
            NSAssert(NO, @"Wrong fetcher message class!");
            return nil;
        }
    }
    else
        message = [self.fetcherMessageClass new];
    
    return message;
}

- (void)configureFetcherMessage:(SMFetcherMessage*)aMessage
{
    if (self.isSearchEnabled && [self.searchStrategy isSearchActive])
        aMessage.defaultParameters[kSMSearchListStrategySearchTextKey] = self.searchStrategy.currentSearchText;
}

- (SMFetcherMessage*)fetcherMessage
{
    SMFetcherMessage* message = [self createFetcherMessage];
    [self configureFetcherMessage:message];
    return message;
}

#pragma mark - Process Models

- (NSArray*)processFetchedModelsInResponse:(SMResponse *)aResponse
{
    NSArray* result = nil;
    if([self.delegate respondsToSelector:@selector(moduleList:processFetchedModelsInResponse:)])
        result = [self.delegate moduleList:self processFetchedModelsInResponse:aResponse];
    else
        result = aResponse.boArray;
    return result;
}

- (void)prepareSections
{
    if([self.delegate respondsToSelector:@selector(prepareSectionsForModuleList:)])
    {
        [self.delegate prepareSectionsForModuleList:self];
    } else if ([self.delegate respondsToSelector:@selector(moduleList:sectionForModels:indexOfSection:)])
    {
        [self.tableDisposer removeAllSections];
    } else
    {
        [self.tableDisposer removeAllSections];
        SMSectionReadonly* section = [SMSectionReadonly section];
        [self.tableDisposer addSection:section];
    }
}

- (void)setupModels:(NSArray*)aModels forSection:(SMSectionReadonly *)aSection
{
    if (models)
    {
        [models addObjectsFromArray:aModels];
    } else
    {
        models = [NSMutableArray arrayWithArray:aModels];
    }
    
    if(self.tableDisposer.useCompoundCells)
        compoundModels = [NSMutableArray arrayWithArray:[SMCompoundModel compoundModelsFromModels:aModels
                                                                                   groupedByCount:self.defaultCompoundMaxModelsCount]];
    
    [self.tableDisposer setupModels:(self.tableDisposer.useCompoundCells) ? (compoundModels) : (aModels)
                         forSection:aSection];
}

#pragma mark - SMTableDisposerModeledMulticastDelegate

- (void)tableDisposer:(SMTableDisposerModeled*)aTableDisposer didCreateCellData:(SMCellData*)aCellData
{
    if(aTableDisposer != self.tableDisposer)
        return;
}

#pragma mark - CTSearchListStrategyDelegate

- (SMTableDisposerModeled *)moduleListTableDisposerForSearchStrategy:(SMSearchListStrategy *)searchStrategy
{
    return nil; // it can't be original tableDisposer - it will cause wrong reloading behavior
}

- (void)configureLoadedTableView:(UITableView *)aTableView forSearchStrategy:(SMSearchListStrategy *)searchStrategy
{
    if ([self.delegate respondsToSelector:@selector(configureLoadedTableView:forSearchStrategy:)])
        [self.delegate configureLoadedTableView:aTableView forSearchStrategy:searchStrategy];
    else
    {
        // default approach
        aTableView.autoresizingMask = defaultTableDisposer.tableView.autoresizingMask;
        aTableView.backgroundColor = defaultTableDisposer.tableView.backgroundColor;
        aTableView.separatorColor = defaultTableDisposer.tableView.separatorColor;
        aTableView.separatorStyle = defaultTableDisposer.tableView.separatorStyle;
    }
}

#pragma mark - SMModuleListSearchDelegate

- (void)searchListStrategyWillBeginSearch:(SMSearchListStrategy *)searchStrategy
{
    if (delegateSearch && [delegateSearch respondsToSelector:@selector(searchListStrategyWillBeginSearch:)])
    {
        [delegateSearch searchListStrategyWillBeginSearch:self];
    }
}
- (void)searchListStrategyDidBeginSearch:(SMSearchListStrategy *)searchStrategy
{
    if (delegateSearch && [delegateSearch respondsToSelector:@selector(searchListStrategyDidBeginSearch:)])
    {
        [delegateSearch searchListStrategyDidBeginSearch:self];
    }
}

- (void)searchListStrategyWillEndSearch:(SMSearchListStrategy *)searchStrategy
{
    if (delegateSearch && [delegateSearch respondsToSelector:@selector(searchListStrategyWillEndSearch:)])
    {
        [delegateSearch searchListStrategyWillEndSearch:self];
    }
    defaultTableDisposer.tableView.userInteractionEnabled = NO;
}

- (void)searchListStrategyDidEndSearch:(SMSearchListStrategy *)searchStrategy
{
    if (delegateSearch && [delegateSearch respondsToSelector:@selector(searchListStrategyDidEndSearch:)])
    {
        [delegateSearch searchListStrategyDidEndSearch:self];
    }
    [self.dataFetcher cancelFetching];
    defaultTableDisposer.tableView.userInteractionEnabled = YES;
}

- (void)searchBarSearchButtonClicked:(SMSearchBar *)aSearchBar
{
    if ([self.delegateSearch respondsToSelector:@selector(searchBarSearchButtonClicked:)])
    {
        [self.delegateSearch searchBarSearchButtonClicked:self];
    }
}

- (void)searchBarCancelButtonClicked:(SMSearchBar *)aSearchBar
{
    if ([self.delegateSearch respondsToSelector:@selector(searchBarCancelButtonClicked:)])
    {
        [self.delegateSearch searchBarCancelButtonClicked:self];
    }
}

- (BOOL)searchListStrategy:(SMSearchListStrategy *)searchStrategy shouldReloadTableForSearchString:(NSString *)searchString andSearchScope:(NSInteger)searchOption
{
    [self.tableDisposer removeAllSections];
    [self.tableDisposer reloadData];
    
    if ([searchString length] >= minSearchStringLength)
    {
        [self reloadData];
    }
    
    return NO;
}

@end
