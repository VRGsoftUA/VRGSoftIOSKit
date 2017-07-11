//
//  SMTableDisposer.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 30.03.12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMSectionWritable.h"
#import "SMCellData.h"
#import "SMMulticastDelegate.h"

@protocol SMTableDisposerDelegate;
@protocol SMTableDisposerMulticastDelegate;

@interface SMTableDisposer : NSObject <UITableViewDataSource, UITableViewDelegate, NSCopying>
{
@protected
    UITableView* tableView;
    NSMutableArray* sections;
}

@property (nonatomic, assign) Class tableClass;
@property (nonatomic, assign) UITableViewStyle tableStyle;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, weak) id<SMTableDisposerDelegate> delegate;
@property (nonatomic, readonly) SMMulticastDelegate<SMTableDisposerMulticastDelegate>* multicastDelegate;

#pragma mark - Multicast Delegates
- (void)addDelegate:(id)aDelegate delegateQueue:(dispatch_queue_t)aDelegateQueue;
- (void)removeDelegate:(id)aDelegate delegateQueue:(dispatch_queue_t)aDelegateQueue;

#pragma mark - Sections
- (void)addSection:(SMSectionReadonly*)aSection;
- (void)insertSection:(SMSectionReadonly*)aSection atIndex:(NSUInteger)anIndex needUpdateTable:(BOOL)aNeedUpdateTable;
- (void)removeSectionAtIndex:(NSUInteger)anIndex needUpdateTable:(BOOL)aNeedUpdateTable;
- (void)removeSection:(SMSectionReadonly*)aSection needUpdateTable:(BOOL)aNeedUpdateTable;
- (void)removeAllSections;
- (SMSectionReadonly*)sectionByIndex:(NSUInteger)anIndex;
- (NSUInteger)indexBySection:(SMSectionReadonly*)aSection;
- (NSUInteger)sectionsCount;
- (NSArray <SMSectionReadonly *>*)sections;
#pragma mark - Search CellData & IndexPath
- (NSIndexPath*)indexPathByCellData:(SMCellData*)aCellData;
- (NSIndexPath*)indexPathByVisibleCellData:(SMCellData*)aCellData;
- (SMCellData*)cellDataByIndexPath:(NSIndexPath*)anIndexPath;
- (SMCellData*)visibleCellDataByIndexPath:(NSIndexPath*)anIndexPath;
- (SMCellData*)cellDataByTag:(NSUInteger)aTag;

#pragma mark - Show/Hide cellData
- (void)showCellByIndexPath:(NSIndexPath*)anIndexPath needUpdateTable:(BOOL)aNeedUpdateTable;
- (void)hideCellByIndexPath:(NSIndexPath*)anIndexPath needUpdateTable:(BOOL)aNeedUpdateTable;

- (void)showCellByIndexPath:(NSIndexPath*)anIndexPath
            needUpdateTable:(BOOL)aNeedUpdateTable
           withRowAnimation:(UITableViewRowAnimation)aTableViewRowAnimation;

- (void)hideCellByIndexPath:(NSIndexPath*)anIndexPath
            needUpdateTable:(BOOL)aNeedUpdateTable
           withRowAnimation:(UITableViewRowAnimation)aTableViewRowAnimation;


#pragma mark - Deletions
- (void)deleteRowsAtIndexPaths:(NSArray*)anIndexPaths withRowAnimation:(UITableViewRowAnimation)aTableViewRowAnimation;

#pragma mark - Data reloading
- (void)reloadData;
- (void)reloadSectionsWithAnimation:(UITableViewRowAnimation)anAnimation;

#pragma mark -
- (void)scrollToBottom:(BOOL)anAnimated;

#pragma mark -
- (void)didCreateCell:(SMCell*)aCell;

@end



@protocol SMTableDisposerDelegate <UITableViewDelegate>

@optional

- (BOOL)tableView:(UITableView *)aTableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableView:(UITableView *)aTableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)aTableView;
- (NSInteger)tableView:(UITableView *)aTableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)aTableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;

- (void)tableDisposer:(SMTableDisposer*)aTableDisposer didCreateCell:(SMCell*)aCell;

@end


@protocol SMTableDisposerMulticastDelegate <NSObject>

@optional
- (void)tableDisposer:(SMTableDisposer*)aTableDisposer didCreateCell:(SMCell*)aCell;
- (void)tableView:(UITableView *)aTableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end
