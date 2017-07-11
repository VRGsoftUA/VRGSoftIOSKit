//
//  SMSearchListStrategy.m
//  VRGSoftIOSKit
//
//  Created by Alexander Burkhai on 6/14/13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMSearchListStrategy.h"

@interface SMTableDisposer (CustomTableView)

- (void)setupCustomTableView:(UITableView *)aTableView;

@end

@implementation SMTableDisposer (CustomTableView)

- (void)setupCustomTableView:(UITableView *)aTableView
{
    tableView = aTableView;
}

@end

@interface SMSearchListStrategy ()
{
    CGFloat keyBoardHeight;
}
@end

@implementation SMSearchListStrategy

@synthesize searchBar, searchDisplayController;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.searchBarPresentationStyle = SMSearchBarPresentationStyleInContentView;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    searchDisplayController.delegate = nil;
    searchDisplayController.searchResultsDataSource = nil;
    searchDisplayController.searchResultsDelegate = nil;
}

#pragma mark - Configure

- (void)configureWithSearchBar:(SMSearchBar *)aSearchBar contentsController:(UIViewController *)aContentsController
{
    [self configureWithSearchBar:aSearchBar
              contentsController:aContentsController
             searchTableDisposer:nil];
}

- (void)configureWithSearchBar:(SMSearchBar *)aSearchBar
            contentsController:(UIViewController *)aContentsController
           searchTableDisposer:(SMTableDisposerModeled *)aSearchTableDisposer
{
    NSAssert(aSearchBar, @"searchBar for searchStrategy cannot be nil");
    NSAssert(aContentsController, @"contentsController for searchStrategy cannot be nil");
    
    searchBar = aSearchBar;
    //    searchBar.text = ([self.preFilledSearchText length]) ? self.preFilledSearchText : @"";
    
    searchBar.smdelegate = self;
    
    searchDisplayController = [[SMSearchDisplayController alloc] initWithSearchBar:searchBar contentsController:aContentsController];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    searchTableDisposer = aSearchTableDisposer;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark -

- (SMTableDisposerModeled *)tableDisposer
{
    if (searchTableDisposer)
        return searchTableDisposer;
    
    if ([self.delegate respondsToSelector:@selector(moduleListTableDisposerForSearchStrategy:)])
        return [self.delegate moduleListTableDisposerForSearchStrategy:self];
    
    return nil;
}

- (BOOL)isSearchActive
{
    return searchDisplayController.isActive;
}

- (void)setSearchActive:(BOOL)active animated:(BOOL)animated
{
    [searchDisplayController setActive:active animated:animated];
}

- (NSString *)currentSearchText
{
    if (!self.isSearchActive)
        return nil;
    
    return [self prepareFormattedTextForSearchWithString:searchBar.text];
}

#pragma mark - Actions

- (void)cancelSearch
{
    [self cancelSearchAnimated:YES];
}

- (void)cancelSearchAnimated:(BOOL)anAnimated
{
    if (self.isSearchActive)
    {
        [self saveLastSearchText];
        
        //        _isSearchCurrentlyActive = NO;
        [searchDisplayController setActive:NO animated:anAnimated];
    }
}

- (void)saveLastSearchText
{
    lastSearchText = (self.savesLastSearchText) ? [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]: nil;
}

- (NSString*)prepareFormattedTextForSearchWithString:(NSString*)inputString
{
    NSString *result = [inputString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([self.preFilledSearchText length])
    {
        NSString *prefilledText = [self.preFilledSearchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        result = [result stringByReplacingCharactersInRange:NSMakeRange(0, prefilledText.length) withString:@""];
    }
    
    if ([self.delegate respondsToSelector:@selector(formatPreparedTextForSearchWithString:forSearchStrategy:)])
        result = [self.delegate formatPreparedTextForSearchWithString:result forSearchStrategy:self];
    
    return result;
}

//#pragma mark - KVO
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if (object == self.tableDisposer.tableView && [keyPath isEqualToString:@"contentOffset"])
//    {
//        if (searchBarShouldObserveTableContentOffset)
//        {
//            CGPoint contentOffset = self.tableDisposer.tableView.contentOffset;
//            CGRect frame = searchBar.frame;
//            frame.origin.y = (contentOffset.y < 0) ? CGRectGetMaxY(navigationBar.frame) : CGRectGetMaxY(navigationBar.frame) - contentOffset.y;
//            searchBar.frame = frame;
//        }
//    }
//    else if (object == self.tableDisposer.tableView && [keyPath isEqualToString:@"contentSize"])
//    {
//        CGFloat contentSizeHeight = self.tableDisposer.tableView.contentSize.height;
//        CGFloat minExpectedContentSizeHeight = self.tableDisposer.tableView.frame.size.height + searchBar.frame.size.height;
//        if (contentSizeHeight < minExpectedContentSizeHeight)
//            self.tableDisposer.tableView.contentSize = CGSizeMake(self.tableDisposer.tableView.contentSize.width, minExpectedContentSizeHeight);
//    }
//    else
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//}

#pragma mark - UISearchDisplayDelegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    if ([self.preFilledSearchText length])
        searchBar.text = self.preFilledSearchText;
    else if (self.savesLastSearchText)
        searchBar.text = lastSearchText;
    
    if ([self.delegate respondsToSelector:@selector(searchListStrategyWillBeginSearch:)])
        [self.delegate searchListStrategyWillBeginSearch:self];
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    //    _isSearchCurrentlyActive = YES;
    if ([self.delegate respondsToSelector:@selector(searchListStrategyDidBeginSearch:)])
        [self.delegate searchListStrategyDidBeginSearch:self];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [self saveLastSearchText];
    
    //    _isSearchCurrentlyActive = NO;
    
    if ([self.delegate respondsToSelector:@selector(searchListStrategyWillEndSearch:)])
        [self.delegate searchListStrategyWillEndSearch:self];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    if ([self.delegate respondsToSelector:@selector(searchListStrategyDidEndSearch:)])
        [self.delegate searchListStrategyDidEndSearch:self];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if (self.usesManualSearchStrategy || !self.isSearchActive)
        return NO;
    
    BOOL shouldReloadTable = YES;
    if ([self.delegate respondsToSelector:@selector(searchListStrategy:shouldReloadTableForSearchString:andSearchScope:)])
        shouldReloadTable = [self.delegate searchListStrategy:self
                             shouldReloadTableForSearchString:[self prepareFormattedTextForSearchWithString:searchString]
                                               andSearchScope:controller.searchBar.selectedScopeButtonIndex];
    return shouldReloadTable;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    if (self.usesManualSearchStrategy || !self.isSearchActive)
    {
        return NO;
    }
    
    BOOL shouldReloadTable = YES;
    if ([self.delegate respondsToSelector:@selector(searchListStrategy:shouldReloadTableForSearchString:andSearchScope:)])
        shouldReloadTable = [self.delegate searchListStrategy:self
                             shouldReloadTableForSearchString:[self prepareFormattedTextForSearchWithString:controller.searchBar.text]
                                               andSearchScope:searchOption];
    return shouldReloadTable;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)aTableView
{
    if ([self.delegate respondsToSelector:@selector(configureLoadedTableView:forSearchStrategy:)])
        [self.delegate configureLoadedTableView:aTableView forSearchStrategy:self];
    
    [self.tableDisposer setupCustomTableView:aTableView];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView
{
    if (self.tableDisposer.tableView == tableView)
    {
        [self.tableDisposer removeAllSections];
        [self.tableDisposer setupCustomTableView:nil];
    }
}

#pragma mark - UITableViewDataSource (for searchDisplayController)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableDisposer numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableDisposer tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.tableDisposer tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.tableDisposer tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableDisposer tableView:tableView didSelectRowAtIndexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableDisposer tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(SMSearchBar *)aSearchBar
{
    if (self.usesManualSearchStrategy && [self.delegate respondsToSelector:@selector(searchListStrategy:shouldReloadTableForSearchString:andSearchScope:)])
        [self.delegate searchListStrategy:self shouldReloadTableForSearchString:self.currentSearchText andSearchScope:aSearchBar.selectedScopeButtonIndex];
    
    if ([self.delegate respondsToSelector:@selector(searchBarSearchButtonClicked:)])
    {
        [self.delegate searchBarSearchButtonClicked:self];
    }
}

- (void)searchBar:(UISearchBar *)aSearchBar textDidChange:(NSString *)searchText
{
    if ([self.preFilledSearchText length] && self.isSearchActive && ![searchText length])
        aSearchBar.text = self.preFilledSearchText;
}

- (void)searchBarCancelButtonClicked:(SMSearchBar *)aSearchBar
{
    if ([self.delegate respondsToSelector:@selector(searchBarCancelButtonClicked:)])
    {
        [self.delegate searchBarCancelButtonClicked:self];
    }
}

#pragma mark - NSNotification
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    CGRect keyboardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyBoardHeight = keyboardFrame.size.height;
    CGFloat topInset = 0;
    switch (self.searchBarPresentationStyle) {
        case SMSearchBarPresentationStyleInContentView:
            
            break;
        case SMSearchBarPresentationStyleInTableHeaderView:
            topInset = searchBar.frame.size.height;
            break;
        default:
            break;
    }
    self.tableDisposer.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(topInset, 0, keyBoardHeight, 0);
    self.tableDisposer.tableView.contentInset =  UIEdgeInsetsMake(topInset,0,keyBoardHeight,0);
    
}


@end
