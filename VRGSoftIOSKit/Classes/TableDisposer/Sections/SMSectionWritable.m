//
//  SMSectionReadonly.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 29.03.12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMSectionWritable.h"
#import "SMCellDataMaped.h"
#import "SMCellData.h"
#import "SMCellProtocol.h"
#import "SMTableDisposer.h"
#import "SMKeyboardAvoidingTableView.h"
#import "SMKeyboardAvoidingProtocol.h"

@interface SMSectionWritable ()

- (SMCell*)createCellAtIndex:(NSUInteger)anIndex;

@end


@implementation SMSectionWritable

#pragma mark - Init/Dealloc

- (instancetype)init
{
    if( (self = [super init]) )
    {
        cells = [NSMutableArray new];
    }
    return self;
}

#pragma mark - Cells

- (void)createCells
{
    // remove old cells
    [cells removeAllObjects];
    
    [self updateCellDataVisibility];

    SMCell* cell;
    for (NSUInteger index = 0; index < visibleCellDataSource.count; ++index)
    {
        cell = [self createCellAtIndex:index];
        [cells addObject:cell];
    }
}

- (UITableViewCell<SMCellProtocol>*)cellForIndex:(NSUInteger)anIndex
{
    UITableViewCell<SMCellProtocol>* cell = [cells objectAtIndex:anIndex];
    // ...
    return cell;
}

- (void)reloadWithAnimation:(UITableViewRowAnimation)anAnimation
{
    if ([disposer.tableView conformsToProtocol:@protocol(SMKeyboardAvoidingProtocol)])
    {
        for (SMCell *cell in cells)
        {
            [(id<SMKeyboardAvoidingProtocol>)disposer.tableView removeObjectsForKeyboard:[cell inputTraits]];
        }
    }

    [self mapFromObject];
    
    [super reloadWithAnimation:anAnimation];
}

- (void)reloadRowsAtIndexes:(NSArray *)anIndexes withAnimation:(UITableViewRowAnimation)aRowAnimation
{
    NSMutableArray* indexPaths = [NSMutableArray array];
    NSIndexPath* indexPath;
    NSInteger sectionIndex = [disposer indexBySection:self];
    
    SMCellData* cellData;
    SMCell* cell;
    for(NSNumber* index in anIndexes)
    {
        cellData = [self visibleCellDataAtIndex:[index integerValue]];
        if([cellData isKindOfClass:[SMCellDataMaped class]])
        {
            [(SMCellDataMaped*)cellData mapFromObject];
        }
        
        cell = [self cellForIndex:[index integerValue]];
        [cell setupCellData:cellData];

        indexPath = [NSIndexPath indexPathForRow:[index integerValue] inSection:sectionIndex];
        [indexPaths addObject:indexPath];
    }
    
    [disposer.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:aRowAnimation];
}


#pragma mark - Show/Hide cels

- (void)hideCellByIndex:(NSUInteger)anIndex needUpdateTable:(BOOL)aNeedUpdateTable withAnimation:(UITableViewRowAnimation)aRowAnimation
{
    SMCellData* cellData = [self cellDataAtIndex:anIndex];
    if(!cellData.visible)
        return;
    
    NSUInteger index = [self indexByVisibleCellData:cellData];
    
    SMCell* cell = [self cellForIndex:index];
    if ([disposer.tableView conformsToProtocol:@protocol(SMKeyboardAvoidingProtocol)])
    {
        [((id<SMKeyboardAvoidingProtocol>)disposer.tableView) removeObjectsForKeyboard:[cell inputTraits]];
    }
    
    [visibleCellDataSource removeObjectAtIndex:index];
    [cells removeObjectAtIndex:index];
    cellData.visible = NO;
    
    if(aNeedUpdateTable)
    {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:[disposer indexBySection:self]];
        [disposer.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:aRowAnimation];
    }
}

- (void)showCellByIndex:(NSUInteger)anIndex needUpdateTable:(BOOL)aNeedUpdateTable withAnimation:(UITableViewRowAnimation)aRowAnimation
{
    SMCellData* cellData = [self cellDataAtIndex:anIndex];
    if(cellData.visible)
        return;

    cellData.visible = YES;
    [self updateCellDataVisibility];
    
    NSUInteger index = [self indexByVisibleCellData:cellData];
    SMCell* cell = [self createCellAtIndex:index];
    [cells insertObject:cell atIndex:index];

    if(aNeedUpdateTable)
    {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:[disposer indexBySection:self]];
        [disposer.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:aRowAnimation];
    }
}

#pragma mark - Maping

- (void)mapFromObject
{
    for (SMCellData* cellData in cellDataSource)
    {
        if ([cellData isKindOfClass:[SMCellDataMaped class]])
            [(SMCellDataMaped*)cellData mapFromObject];
    }
    [self createCells];
}

- (void)mapToObject
{
    for (SMCellData* cellData in cellDataSource)
    {
        if ([cellData isKindOfClass:[SMCellDataMaped class]])
            [(SMCellDataMaped*)cellData mapToObject];
    }
}

- (void)deleteRowsAtIndexes:(NSArray*)anIndexes withAnimation:(UITableViewRowAnimation)aRowAnimation
{
    [super deleteRowsAtIndexes:anIndexes withAnimation:aRowAnimation];
    
    NSMutableIndexSet* set = [NSMutableIndexSet new];
    for(NSNumber* index in anIndexes)
    {
        [set addIndex:[index unsignedIntegerValue]];
    }
    [cells removeObjectsAtIndexes:set];
}

#pragma mark - Private

- (SMCell *)createCellAtIndex:(NSUInteger)anIndex
{
    SMCellData* cellData = [self visibleCellDataAtIndex:anIndex];
    
    SMCell *cell;
    if (cellData.cellNibName || cellData.cellClass)
    {
        cell = [cellData createCell];
    } else
    {
        cell = [disposer.tableView dequeueReusableCellWithIdentifier:cellData.cellIdentifier];//Stroryboard
    }
    
    [cell setupCellData:cellData];
    
    if ([disposer.tableView conformsToProtocol:@protocol(SMKeyboardAvoidingProtocol)])
    {
        [((id<SMKeyboardAvoidingProtocol>)disposer.tableView) addObjectsForKeyboard:[cell inputTraits]];
        [((SMKeyboardAvoidingTableView*)disposer.tableView) sordetInputTraits:[cell inputTraits] byIndexPath:[NSIndexPath indexPathForRow:anIndex inSection:[disposer indexBySection:self]]];
    }
    
    [disposer didCreateCell:cell];
    
    return cell;
}

@end
