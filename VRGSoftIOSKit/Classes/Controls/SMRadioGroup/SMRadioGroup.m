//
//  SMRadioGroup.m
//  VRGSoftIOSKit
//
//  Created by Alexander on 6/10/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMRadioGroup.h"

@interface SMRadioGroup ()

- (void)setup;

@end

@implementation SMRadioGroup

#pragma mark - Init/setup

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        radioItems = [NSMutableArray new];
        [self setup];
    }
    return self;
}

- (instancetype)initWithItems:(NSArray *)anItems
{
    self = [super init];
    if (self)
    {
        [self setup];
        
        [self setupItems:anItems];
    }
    return self;
}

- (void)setup
{
    selectedIndex = NSNotFound;
    
    _isEnabled = YES;
    _isMultiSelectionEnabled = NO;
}

- (void)setupItems:(NSArray *)anItems
{
    selectedIndex = NSNotFound;
    radioItems = [NSMutableArray new];
    
    NSUInteger index = 0;
    for (id<SMRadioItem> radioItem in anItems)
    {
        NSAssert([radioItem conformsToProtocol:@protocol(SMRadioItem)], @"RadioItem won't be added because it doesnt conform to protocol SMRadioItem");
        
        radioItem.radioGroup = nil;
        if (!self.isMultiSelectionEnabled && radioItem.radioItemSelected)
        {
            if (selectedIndex != NSNotFound)
            {
                [[radioItems objectAtIndex:selectedIndex] setRadioItemSelected:NO animated:NO];
            }
            selectedIndex = index;
        }
        
        [radioItems addObject:radioItem];
        radioItem.radioGroup = self;
        
        index++;
    }
}

#pragma mark - Add/remove

- (void)addItem:(id<SMRadioItem>)item
{
    NSAssert([item conformsToProtocol:@protocol(SMRadioItem)], @"RadioItem won't be added because it doesnt conform to protocol SMRadioItem");
    item.radioGroup = nil;
    if (!self.isMultiSelectionEnabled && item.radioItemSelected)
    {
        [item setRadioItemSelected:NO animated:NO];
    }
    [radioItems addObject:item];
    item.radioGroup = self;
}

- (void)removeItemAtIndex:(NSUInteger)index
{
    if (index < radioItems.count)
    {
        if (selectedIndex == index)
            selectedIndex = NSNotFound;
        
        id<SMRadioItem> radioItem = [radioItems objectAtIndex:index];
        if (radioItem.radioGroup == self)
            radioItem.radioGroup = nil;
        
        [radioItems removeObject:radioItem];
    }
}

#pragma mark - Setters/getters

- (NSUInteger)itemsCount
{
    return radioItems.count;
}

- (NSArray *)items
{
    return [NSArray arrayWithArray:radioItems];
}

- (void)setIsMultiSelectionEnabled:(BOOL)isMultiSelectionEnabled
{
    if (_isMultiSelectionEnabled != isMultiSelectionEnabled)
    {
        if (isMultiSelectionEnabled)
        {
            selectedIndex = NSNotFound;
        }
        else
        {
            NSMutableArray *selectedIndexes = [NSMutableArray arrayWithArray:[self selectedItemIndexes]];
            if ([selectedIndexes count] > 0)
            {
                [selectedIndexes removeObjectAtIndex:0]; // leave first item
                for (NSNumber *indexNumber in selectedIndexes)
                    [[radioItems objectAtIndex:[indexNumber unsignedIntegerValue]] setRadioItemSelected:NO animated:NO];
            }
        }
    }
    
    _isMultiSelectionEnabled = isMultiSelectionEnabled;
}

#pragma mark - Selected items

- (NSUInteger)selectedItemIndex
{
    return (selectedIndex != NSNotFound && selectedIndex < radioItems.count && !self.isMultiSelectionEnabled) ? selectedIndex : NSNotFound;
}

- (id<SMRadioItem>)selectedItem
{
    selectedIndex = [self selectedItemIndex]; // refresh
    if (selectedIndex != NSNotFound)
    {
        return [radioItems objectAtIndex:selectedIndex];
    }
        
    return nil;
}

- (NSArray *)selectedItemIndexes
{
    NSMutableArray *result = [NSMutableArray array];
    [radioItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        if ([obj radioItemSelected])
        {
            [result addObject:@(idx)];
            if (!self.isMultiSelectionEnabled)
                *stop = YES;
        }
    }];
    return result;
}

#pragma mark - Selection

- (void)selectItemAtIndex:(NSUInteger)index animated:(BOOL)animated
{
    if (!self.isEnabled)
        return;
    
    if (index < radioItems.count && selectedIndex != index)
    {
        id<SMRadioItem> radioItem = [radioItems objectAtIndex:index];
        
        BOOL shouldSelect = YES;
        if ([self.delegate respondsToSelector:@selector(radioGroup:shouldSelectItem:atIndex:)])
            shouldSelect = [self.delegate radioGroup:self shouldSelectItem:radioItem atIndex:index];
        
        if (!shouldSelect)
            return;
        
        NSUInteger fromIndex = NSNotFound;
        if (!self.isMultiSelectionEnabled)
        {
            if (selectedIndex < radioItems.count)
                [[radioItems objectAtIndex:selectedIndex] setRadioItemSelected:NO animated:animated];
            
            fromIndex = selectedIndex;
            selectedIndex = index;
        }
        
        [radioItem setRadioItemSelected:YES animated:animated];
        if ([self.delegate respondsToSelector:@selector(radioGroup:selectedItemIndexChangedTo:from:)])
            [self.delegate radioGroup:self selectedItemIndexChangedTo:index from:fromIndex];
    }
}

- (void)selectItem:(id<SMRadioItem>)item animated:(BOOL)animated
{
    if (!self.isEnabled)
        return;

    [self selectItemAtIndex:[radioItems indexOfObject:item] animated:animated];
}

- (void)unselectAllItemsAnimated:(BOOL)animated
{
    if (!self.isEnabled)
        return;

    selectedIndex = NSNotFound;
    for (id<SMRadioItem> radioItem in radioItems)
    {
        if ([radioItem radioItemSelected])
            [radioItem setRadioItemSelected:NO animated:animated];
    }
}

@end
