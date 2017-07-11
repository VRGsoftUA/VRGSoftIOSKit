//
//  SMSearchListStrategy.h
//  VRGSoftIOSKit
//
//  Created by Alexander Burkhai on 6/14/13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMTableDisposerModeled.h"
#import "SMDataFetcher.h"
#import "SMSearchBar.h"
#import "SMSearchDisplayController.h"

#define kSMSearchListStrategySearchTextKey @"searchTextKey"

typedef enum _SMSearchBarPresentationStyle
{
    SMSearchBarPresentationStyleInContentView = 0, // default style
    SMSearchBarPresentationStyleInTableHeaderView,
} SMSearchBarPresentationStyle;

@protocol CTSearchListStrategyDelegate;

@interface SMSearchListStrategy : NSObject <UISearchDisplayDelegate, UISearchBarDelegate, SMTableDisposerDelegate, UITableViewDataSource>
{
    SMSearchBar *searchBar;
    SMSearchDisplayController *searchDisplayController;
    SMTableDisposerModeled *searchTableDisposer;        // if searchTableDisposer eq nil than strategy will use tabledisposer returned by delegate
    
    NSString *lastSearchText;
}

@property (nonatomic, readonly) SMTableDisposerModeled *tableDisposer;

@property (nonatomic, readonly) SMSearchBar *searchBar;
@property (nonatomic, readonly) SMSearchDisplayController *searchDisplayController;
@property (nonatomic, readonly) BOOL isSearchActive;

- (void)setSearchActive:(BOOL)active animated:(BOOL)animated;

/*
 * default is nil. If not empty then searchbar will be prefilled with this text every time on begin/end search
 * Note: this property conflicts with savesLastSearchText - priority for prefilled text
 */
@property (nonatomic, strong) NSString *preFilledSearchText;

/*
 * correct formatted current text (based on searchbar text) for search operation
 * Note: better user this value than searchbar.text
 */
@property (nonatomic, readonly) NSString *currentSearchText;

/*
 * by default is NO - if YES last search text will be setuped again on next willbeginsearch
 */
@property (nonatomic, assign) BOOL savesLastSearchText;

/*
 * default is NO. If YES search requests for reloading table will be sent at search button clicked action
 */
@property (nonatomic, assign) BOOL usesManualSearchStrategy;

@property (nonatomic, assign) SMSearchBarPresentationStyle searchBarPresentationStyle; // not implemented yet
@property (nonatomic, weak) id<CTSearchListStrategyDelegate> delegate;

- (void)configureWithSearchBar:(SMSearchBar *)aSearchBar
            contentsController:(UIViewController *)aContentsController;

- (void)configureWithSearchBar:(SMSearchBar *)aSearchBar
            contentsController:(UIViewController *)aContentsController
           searchTableDisposer:(SMTableDisposerModeled *)aSearchTableDisposer;

- (void)cancelSearch;

@end

@protocol CTSearchListStrategyDelegate <NSObject>

@optional

- (SMTableDisposerModeled*)moduleListTableDisposerForSearchStrategy:(SMSearchListStrategy *)searchStrategy;
- (void)configureLoadedTableView:(UITableView*)aTableView forSearchStrategy:(SMSearchListStrategy *)searchStrategy;
- (NSString*)formatPreparedTextForSearchWithString:(NSString*)preparedString forSearchStrategy:(SMSearchListStrategy *)searchStrategy;

- (void)searchListStrategyWillBeginSearch:(SMSearchListStrategy *)searchStrategy;
- (void)searchListStrategyDidBeginSearch:(SMSearchListStrategy *)searchStrategy;

- (void)searchListStrategyWillEndSearch:(SMSearchListStrategy *)searchStrategy;
- (void)searchListStrategyDidEndSearch:(SMSearchListStrategy *)searchStrategy;

- (BOOL)searchListStrategy:(SMSearchListStrategy *)searchStrategy
shouldReloadTableForSearchString:(NSString *)searchString
            andSearchScope:(NSInteger)searchOption;

- (void)searchBarCancelButtonClicked:(SMSearchListStrategy *)aSearchStrategy;
- (void)searchBarSearchButtonClicked:(SMSearchListStrategy *)aSearchStrategy;

@end
