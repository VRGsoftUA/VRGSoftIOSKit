//
//  SMSectionReadonly.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 29.03.12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMCell.h"
#import "SMCellData.h"

@class SMTableDisposer;

@interface SMSectionReadonly : NSObject
{
    NSMutableArray* cellDataSource;
    NSMutableArray* visibleCellDataSource;
    __weak SMTableDisposer* disposer;
}

@property (nonatomic, retain) NSString* headerTitle;
@property (nonatomic, retain) NSString* footerTitle;
@property (nonatomic, retain) UIView* headerView;
@property (nonatomic, retain) UIView* footerView;

#pragma mark - Init/Dealloc

+ (instancetype)section;

- (void)setTableDisposer:(SMTableDisposer*)aTableDisposer;

- (void)addCellData:(SMCellData*)aCellData;
- (void)addCellDataFromArray:(NSArray*)aCellDataArray;
- (void)insertCellData:(SMCellData*)aCellData atIndex:(NSUInteger)anIndex;
- (void)removeCellDataAtIndex:(NSUInteger)anIndex;
- (void)removeCellData:(SMCellData*)aCellData;
- (void)removeAllCellData;
- (NSUInteger)cellDataCount;
- (NSUInteger)visibleCellDataCount;

- (SMCellData*)cellDataAtIndex:(NSUInteger)anIndex;
- (SMCellData*)visibleCellDataAtIndex:(NSUInteger)anIndex;
- (NSUInteger)indexByCellData:(SMCellData*)aCellData;
- (NSUInteger)indexByVisibleCellData:(SMCellData*)aCellData;
- (SMCellData*)cellDataByTag:(NSUInteger)aTag;

- (void)updateCellDataVisibility;

- (SMCell*)cellForIndex:(NSUInteger)anIndex;

- (void)reloadWithAnimation:(UITableViewRowAnimation)anAnimation;
- (void)reloadRowsAtIndexes:(NSArray*)anIndexes withAnimation:(UITableViewRowAnimation)aRowAnimation;
- (void)deleteRowsAtIndexes:(NSArray*)anIndexes withAnimation:(UITableViewRowAnimation)aRowAnimation;

- (void)showCellByIndex:(NSUInteger)anIndex needUpdateTable:(BOOL)aNeedUpdateTable;
- (void)showCellByIndex:(NSUInteger)anIndex needUpdateTable:(BOOL)aNeedUpdateTable withAnimation:(UITableViewRowAnimation)aRowAnimation;
- (void)hideCellByIndex:(NSUInteger)anIndex needUpdateTable:(BOOL)aNeedUpdateTable;
- (void)hideCellByIndex:(NSUInteger)anIndex needUpdateTable:(BOOL)aNeedUpdateTable withAnimation:(UITableViewRowAnimation)aRowAnimation;

@end
