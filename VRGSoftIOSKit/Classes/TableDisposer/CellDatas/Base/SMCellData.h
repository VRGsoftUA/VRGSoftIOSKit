//
//  SMCellData.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 3/29/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>

@class SMCell;

typedef enum _SMCellSeparatorStyle
{
    SMCellSeparatorStyleNone = 0,
    SMCellSeparatorStyleTop = 1 << 0,
    SMCellSeparatorStyleBottom = 1 << 1,
} SMCellSeparatorStyle;

@interface SMCellData : NSObject
{
    @private
    NSMutableArray *cellSelectedHandlers;
    NSMutableArray *cellDeselectedHandler;
}

@property (nonatomic, retain) NSString* cellNibName;

@property (nonatomic, assign) Class cellClass;
@property (nonatomic, readonly) NSString* cellIdentifier;

@property (nonatomic, assign) UITableViewCellStyle cellStyle;
@property (nonatomic, assign) UITableViewCellSelectionStyle cellSelectionStyle;
@property (nonatomic, assign) UITableViewCellAccessoryType cellAccessoryType;
@property (nonatomic, assign) BOOL autoDeselect;
@property (nonatomic, assign) BOOL visible;
@property (nonatomic, assign) BOOL enableEdit;
@property (nonatomic, assign) BOOL disableInputTraits;
@property (nonatomic, assign) NSUInteger tag;
@property (nonatomic, strong) NSDictionary* userData;
@property (nonatomic, assign) BOOL cellHeightAutomaticDimension;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat cellWidth;

@property (nonatomic, assign) SMCellSeparatorStyle cellSeparatorStyle;  // by default is SMCellSeparatorStyleNone
@property (nonatomic, retain) UIColor* cellTopSeparatorColor;           // by default is nil
@property (nonatomic, retain) UIColor* cellBottomSeparatorColor;        // by default is nil

- (instancetype)init;
- (CGFloat)cellHeightForWidth:(CGFloat) aWidth;

- (void)addCellSelectedTarget:(id)aTarget action:(SEL)anAction;
- (void)addCellDeselectedTarget:(id)aTarget action:(SEL)anAction;

- (void)performSelectedHandlers;
- (void)performDeselectedHandlers;

- (SMCell*)createCell;

@end
