//
//  SMSearchBar.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 7/19/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import "SMSearchBar.h"

@interface SMSearchBarDelegateHolder : NSObject <UISearchBarDelegate>

@property (nonatomic, weak) SMSearchBar* holdedSearchBar;

@end

@interface SMSearchBar()

- (void)setup;

@end

@implementation SMSearchBar

@synthesize validatableText, smdelegate, filter;

#pragma mark - Init/Setup

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    delegateHolder = [SMSearchBarDelegateHolder new];
    delegateHolder.self.holdedSearchBar = self;
    super.delegate = delegateHolder;
}

#pragma mark - CTValidationProtocol

- (void)setValidator:(SMValidator*)aValidator
{
    validator = aValidator;
    validator.validatableObject = self;
}

- (NSString*)validatableText
{
    return self.text;
}

- (void)setValidatableText:(NSString*)aValidatableText
{
    self.text = aValidatableText;
}

- (SMValidator*)validator
{
    return validator;
}

- (BOOL)validate
{
    return (validator) ? ([validator validate]) : (YES);
}

#pragma mark - SMFormatterProtocol

- (void)setFormatter:(SMFormatter*)aFormatter
{
    formatter = aFormatter;
    formatter.formattableObject = self;
}

- (SMFormatter*)formatter
{
    return formatter;
}

- (NSString *)formattingText
{
    return self.text;
}

#pragma mark - UISearchBarDelegate

- (void)setDelegate:(id<UISearchBarDelegate>)aDelegate
{
    smdelegate = aDelegate;
}

- (id<UISearchBarDelegate>)delegate
{
    return smdelegate;
}

@end


@implementation SMSearchBarDelegateHolder

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    BOOL result = YES;
    
    if([self.holdedSearchBar.smdelegate respondsToSelector:@selector(searchBarShouldBeginEditing:)])
        result = [self.holdedSearchBar.smdelegate searchBarShouldBeginEditing:searchBar];
    
    return result;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
//    [self.holdedSearchBar.keyboardAvoiding adjustOffset];
    
    if([self.holdedSearchBar.smdelegate respondsToSelector:@selector(searchBarTextDidBeginEditing:)])
        [self.holdedSearchBar.smdelegate searchBarTextDidBeginEditing:searchBar];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    BOOL result = YES;
    
    if([self.holdedSearchBar.smdelegate respondsToSelector:@selector(searchBarShouldEndEditing:)])
        result = [self.holdedSearchBar.smdelegate searchBarShouldEndEditing:searchBar];
    
    return result;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if([self.holdedSearchBar.smdelegate respondsToSelector:@selector(searchBarTextDidEndEditing:)])
        [self.holdedSearchBar.smdelegate searchBarTextDidEndEditing:searchBar];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([self.holdedSearchBar.smdelegate respondsToSelector:@selector(searchBar:textDidChange:)])
        [self.holdedSearchBar.smdelegate searchBar:searchBar textDidChange:searchText];
}

- (BOOL)searchBar:(SMSearchBar*)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL result = YES;
    if (searchBar.filter)
        result = [searchBar.filter textInField:searchBar shouldChangeCharactersInRange:range replacementString:text];
    
    if(result && [searchBar formatter])
        result = [[searchBar formatter] formatWithNewCharactersInRange:range replacementString:text];
    
    if(result && [self.holdedSearchBar.smdelegate respondsToSelector:@selector(searchBar:shouldChangeTextInRange:replacementText:)])
        result = [self.holdedSearchBar.smdelegate searchBar:searchBar shouldChangeTextInRange:range replacementText:text];
    
    return result;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if([self.holdedSearchBar.smdelegate respondsToSelector:@selector(searchBarSearchButtonClicked:)])
        [self.holdedSearchBar.smdelegate searchBarSearchButtonClicked:searchBar];
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    if([self.holdedSearchBar.smdelegate respondsToSelector:@selector(searchBarBookmarkButtonClicked:)])
        [self.holdedSearchBar.smdelegate searchBarBookmarkButtonClicked:searchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if([self.holdedSearchBar.smdelegate respondsToSelector:@selector(searchBarCancelButtonClicked:)])
        [self.holdedSearchBar.smdelegate searchBarCancelButtonClicked:searchBar];
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar
{
    if([self.holdedSearchBar.smdelegate respondsToSelector:@selector(searchBarResultsListButtonClicked:)])
        [self.holdedSearchBar.smdelegate searchBarResultsListButtonClicked:searchBar];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    if([self.holdedSearchBar.smdelegate respondsToSelector:@selector(searchBar:selectedScopeButtonIndexDidChange:)])
        [self.holdedSearchBar.smdelegate searchBar:searchBar selectedScopeButtonIndexDidChange:selectedScope];
}

@end
