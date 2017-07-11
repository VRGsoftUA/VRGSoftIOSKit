//
//  SMRadioGroup.h
//
//
//  Created by Alexander on 6/10/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

@class SMRadioGroup;

@protocol SMRadioItem <NSObject>

@required
@property (nonatomic, weak) SMRadioGroup *radioGroup;
@property (nonatomic, readonly) BOOL radioItemSelected;

- (void)setRadioItemSelected:(BOOL)selected animated:(BOOL)animated;

@optional
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end


@protocol SMRadioGroupDelegate <NSObject>

@optional
- (BOOL)radioGroup:(SMRadioGroup *)radioGroup shouldSelectItem:(id<SMRadioItem>)item atIndex:(NSUInteger)index;
/**
 * If isMultiSelectionEnabled YES fromIndex will return NSNotFound
 **/
- (void)radioGroup:(SMRadioGroup *)radioGroup selectedItemIndexChangedTo:(NSUInteger)toIndex from:(NSUInteger)fromIndex;

@end

@interface SMRadioGroup : NSObject
{
    NSUInteger selectedIndex; // can be NSNotFound
    
    NSMutableArray *radioItems;
}

@property (nonatomic, weak) id<SMRadioGroupDelegate> delegate;

@property (nonatomic, assign) BOOL isMultiSelectionEnabled; /// by default is NO
@property (nonatomic, assign) BOOL isEnabled;               /// by default is YES

@property (nonatomic, readonly) NSArray *items;
@property (nonatomic, readonly) NSUInteger itemsCount;
@property (nonatomic, readonly) NSArray *selectedItemIndexes; /// array of index NSNumbers

- (instancetype)initWithItems:(NSArray *)items;

- (void)setupItems:(NSArray *)items;
- (void)addItem:(id<SMRadioItem>)item;
- (void)removeItemAtIndex:(NSUInteger)index;

- (void)selectItemAtIndex:(NSUInteger)index animated:(BOOL)animated; /// programmaticaly switch to item at index
- (void)selectItem:(id<SMRadioItem>)item animated:(BOOL)animated;

- (id<SMRadioItem>)selectedItem;                /// will return nil if isMultiSelectionEnabled is YES
- (NSUInteger)selectedItemIndex;                /// will return NSNotFound if isMultiSelectionEnabled is YES

- (void)unselectAllItemsAnimated:(BOOL)animated; // selectedItemIndexes will return empty array

@end
