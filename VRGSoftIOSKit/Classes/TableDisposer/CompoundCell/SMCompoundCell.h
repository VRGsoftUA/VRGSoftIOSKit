//
//  SMCompoundCell.h
//
//
//  Created by VRGSoft on 11.02.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMCell.h"
#import "SMCellDataModeled.h"
#import "SMCompoundModel.h"

@class SMTableDisposerModeled;

@interface SMCompoundCell : SMCell
{
    NSMutableArray* subCells;
    NSMutableArray* verticalSeparatorLines;
    
    // for dequeue cells
    NSMutableDictionary *reusableCells;
}

- (UIView*)verticalSeparatorLineAtIndex:(NSUInteger)index;

@end


@interface SMCompoundCellData : SMCellDataModeled

@property (nonatomic, weak) SMTableDisposerModeled* tableDisposer;
@property (nonatomic, readonly) NSMutableArray* cellDatas;

/*
 * spacing between cells
 * by default eq 0
 */
@property (nonatomic, assign) NSUInteger itemSpacing;

/*
 * insets for rectangle which cells will occupy inside CompoundCell
 * UIEdgeInsetsZero by default
 */
@property (nonatomic, assign) UIEdgeInsets itemInsets;

@property (nonatomic, strong) UIColor* verticalSeparatorLinesColor;
@property (nonatomic, assign) BOOL showsVerticalSeparatorLines;     // by default is NO

- (CGFloat)subCellWidthForCompoundCellWidth:(CGFloat)aWidth;

@end
