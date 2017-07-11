//
//  SMModuleList.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 15.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMTableDisposerModeled.h"

#import "SMPullToRefreshAdapter.h"
#import "SMActivityAdapter.h"
#import "SMDataFetcher.h"
#import "SMSearchListStrategy.h"

@class SMModuleList;
@protocol SMModuleListDelegate;
@protocol SMModuleListSearchDelegate;

typedef void (^SMModuleListFetcherFailedCallback) (SMModuleList* aModule, SMResponse* aResponse);
typedef void (^SMModuleListFetcherCantFetch) (SMModuleList* aModule, SMFetcherMessage *aMessage);

/**
 * GUI layer
 * This module just receive and show data (in one table section, by default).
 * Can use pull-to-refresh and activity Adapters.
 * You can use Compound cells with this module.
 **/
@interface SMModuleList : NSObject <SMTableDisposerModeledMulticastDelegate, CTSearchListStrategyDelegate>
{
    SMTableDisposerModeled* defaultTableDisposer;
    
    NSDate* lastUpdateDate;
    NSMutableArray* models;
    NSMutableArray* compoundModels;
    SMPullToRefreshAdapter* pullToRefreshAdapter;
    __weak id<SMModuleListDelegate> delegate;
}

@property (nonatomic, readonly) SMTableDisposerModeled* tableDisposer; // currently active datasourced tabledisposer

@property (nonatomic, strong) SMPullToRefreshAdapter* pullToRefreshAdapter;
@property (nonatomic, strong) SMActivityAdapter* activityAdapter;
@property (nonatomic, assign) BOOL isUseActivityAdapterWithPullToRefreshAdapter;//default YES
@property (nonatomic, assign) BOOL isUseActivityAdapterWithSearch;//default YES
@property (nonatomic, assign) BOOL isHideActivityAdapterForOneFetch;//this property set YES in didFetchDataWithMessage:
@property (nonatomic, assign) NSUInteger defaultCompoundMaxModelsCount;

@property (nonatomic, strong) SMSearchListStrategy* searchStrategy;
@property (nonatomic, assign) BOOL isSearchEnabled;
@property (nonatomic, assign) NSInteger minSearchStringLength;;

@property (nonatomic, strong) id<SMDataFetcher> dataFetcher;

@property (nonatomic, weak) id<SMModuleListDelegate> delegate;
@property (nonatomic, weak) id<SMModuleListSearchDelegate> delegateSearch;

@property (nonatomic, copy) SMModuleListFetcherFailedCallback fetcherFailedCallback;
@property (nonatomic, copy) SMModuleListFetcherCantFetch fetcherCantFetchCallback;

@property (nonatomic, readonly) NSDate* lastUpdateDate;

@property (nonatomic, readonly) dispatch_queue_t moduleQueue;

@property (nonatomic, readonly) NSArray* models;
@property (nonatomic, readonly) NSArray* compoundModels;

- (instancetype)initWithTableDisposer:(SMTableDisposerModeled*)aTableDisposer;

/**
 * Call it in -(void)viewDidLoad method of controller
 **/
- (void)configureWithView:(UIView*)aView;

#pragma mark - Data fetching
- (void)reloadData;

#pragma mark - For overriding
- (void)fetchDataWithMessage:(SMFetcherMessage*)aMessage;
- (void)willFetchDataWithMessage:(SMFetcherMessage*)aMessage;
- (void)didFetchDataWithMessage:(SMFetcherMessage*)aMessage andResponse:(SMResponse*)aResponse;

- (Class)fetcherMessageClass;
- (SMFetcherMessage*)fetcherMessage;
- (void)configureFetcherMessage:(SMFetcherMessage*)aMessage;

/**
 * You can here change array of received models.
 /// * By default this method process compound models (if useCompoundCells = YES)
 **/
- (NSArray*)processFetchedModelsInResponse:(SMResponse*)aResponse;
- (void)prepareSections;
- (void)setupModels:(NSArray*)aModels forSection:(SMSectionReadonly *)aSection;

@end

@protocol SMModuleListDelegate <NSObject>

@optional
- (SMFetcherMessage*)fetcherMessageForModuleList:(SMModuleList *)aModule;
- (void)willFetchDataForModuleList:(SMModuleList *)aModuleList;
- (void)willReloadModuleList:(SMModuleList *)aModuleList;
- (void)didFetchDataForModuleList:(SMModuleList *)aModuleList;
- (NSArray*)moduleList:(SMModuleList *)aModule processFetchedModelsInResponse:(SMResponse*)aResponse;
- (void)prepareSectionsForModuleList:(SMModuleList *)aModule;
- (SMSectionReadonly *)moduleList:(SMModuleList *)aModule sectionForModels:(NSArray *)aModels indexOfSection:(NSUInteger)aIndex;

- (void)moduleList:(SMModuleList*)aModule didReloadDataWithModels:(NSArray*)aModels;

- (void)configureLoadedTableView:(UITableView*)aTableView forSearchStrategy:(SMSearchListStrategy *)searchStrategy;

@end

@protocol SMModuleListSearchDelegate <NSObject>

@optional
- (void)searchListStrategyWillBeginSearch:(SMModuleList*)aModuleList;
- (void)searchListStrategyDidBeginSearch:(SMModuleList*)aModuleList;

- (void)searchListStrategyWillEndSearch:(SMModuleList*)aModuleList;
- (void)searchListStrategyDidEndSearch:(SMModuleList*)aModuleList;

- (void)searchBarCancelButtonClicked:(SMModuleList *)aModuleList;
- (void)searchBarSearchButtonClicked:(SMModuleList *)aModuleList;


@end
