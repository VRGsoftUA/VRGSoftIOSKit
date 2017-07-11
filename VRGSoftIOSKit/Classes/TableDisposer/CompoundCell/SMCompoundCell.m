//
//  SMCompoundCell.m
//  
//
//  Created by VRGSoft on 11.02.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMCompoundCell.h"
#import "SMTableDisposerModeled.h"
//#import "NSObject+BlocksKit.h"
#import "NSObject+BKBlockExecution.h"


static NSMutableDictionary *globalReusableCells;

@implementation SMCompoundCell

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        globalReusableCells = [NSMutableDictionary dictionary];
    });
}

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        verticalSeparatorLines = [NSMutableArray new];
        self.exclusiveTouch = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - Setup

- (void)setupCellData:(SMCompoundCellData*)aCellData
{
    [super setupCellData:aCellData];

    reusableCells = globalReusableCells;    
    subCells = [NSMutableArray array];
    
    CGFloat width = [aCellData subCellWidthForCompoundCellWidth:self.bounds.size.width];
    CGFloat x = aCellData.itemInsets.left;
    
    SMCell* cell;
    for(SMCellDataModeled* cellData in aCellData.cellDatas)
    {
        // subcells
        BOOL isNewCell = NO;
        cell = [self createSubCellWithCellData:cellData isNewCell:&isNewCell];
        [subCells addObject:cell];
        
        cell.frame = CGRectMake(x, aCellData.itemInsets.top, width, [cellData cellHeightForWidth:width]);
        [self.contentView addSubview:cell];
        x += width + aCellData.itemSpacing;

        if(isNewCell && [aCellData.tableDisposer.delegate respondsToSelector:@selector(tableDisposer:didCreateCell:)])
            [aCellData.tableDisposer.delegate tableDisposer:aCellData.tableDisposer
                                              didCreateCell:cell];
    }

    if (!aCellData.showsVerticalSeparatorLines)
        return;

    // separators
    CGFloat sWidth = 1.0f;
    CGFloat sHeight = self.bounds.size.height - aCellData.itemInsets.top - aCellData.itemInsets.bottom;
    if (aCellData.itemInsets.left > 0)
        [self addSeparatorLineAtIndex:0 withFrame:CGRectMake(floorf((aCellData.itemInsets.left - sWidth)/2), aCellData.itemInsets.top,
                                                             sWidth, sHeight)];
    
    if (aCellData.itemSpacing > 0)
    {
        CGRect verticalSeparatorFrame = CGRectMake(aCellData.itemInsets.left, aCellData.itemInsets.top, sWidth, sHeight);
        for (NSUInteger index = 1; index < subCells.count - 1; index++)
        {
            CGFloat dif = floorf((aCellData.itemSpacing - sWidth)/2);
            verticalSeparatorFrame.origin.x += width + dif;
            [self addSeparatorLineAtIndex:index withFrame:verticalSeparatorFrame];
            
            verticalSeparatorFrame.origin.x += aCellData.itemSpacing - dif;
        }
    }
    
    if (aCellData.itemInsets.right > 0)
        [self addSeparatorLineAtIndex:[verticalSeparatorLines count]
                            withFrame:CGRectMake(aCellData.itemInsets.left + subCells.count * width + aCellData.itemSpacing * (subCells.count - 1) + floorf((aCellData.itemInsets.right - sWidth)/2), aCellData.itemInsets.top, sWidth, sHeight)];
}

- (SMCell *)createSubCellWithCellData:(SMCellDataModeled *)cellData isNewCell:(BOOL *)isNewCell
{
    SMCell* cell = nil;
    *isNewCell = NO;
    
    NSString *identifier = cellData.cellIdentifier;
    cell = [self dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        *isNewCell = YES;
        cell = [cellData createCell];
    }
    
    [cell setupCellData:cellData];
    return cell;
}

- (void)addSeparatorLineAtIndex:(NSUInteger)index withFrame:(CGRect)frame
{
    UIView* verticalSeparatorLine = [self verticalSeparatorLineAtIndex:index];
    if (verticalSeparatorLine)
    {
        verticalSeparatorLine.frame = frame;
        [self.contentView addSubview:verticalSeparatorLine];
        [verticalSeparatorLines insertObject:verticalSeparatorLine atIndex:index];
    }
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];

    SMCompoundCellData* aCellData = (SMCompoundCellData*)self.cellData;
    CGFloat width = [aCellData subCellWidthForCompoundCellWidth:self.bounds.size.width];
    
    CGFloat x = aCellData.itemInsets.left;
    for(SMCell* cell in subCells)
    {
        cell.frame = CGRectMake(x, aCellData.itemInsets.top, width, [cell.cellData cellHeightForWidth:width]);
        x += width + aCellData.itemSpacing;
    }
}

#pragma mark - Reusing subcells

- (SMCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    if (!identifier) return nil;
    
    NSMutableSet *reusableCellsForIdentifier = [reusableCells objectForKey:identifier];
    
    if ([reusableCellsForIdentifier count] == 0)
        return nil;
    
    SMCell *reusableCell = [reusableCellsForIdentifier anyObject];
    [reusableCellsForIdentifier removeObject:reusableCell];
    [reusableCell prepareForReuse];
    
    return reusableCell;
}

- (void)enqueueCell:(SMCell *)cell withIdentifier:(NSString *)identifier
{
    [[self reusableCellSetForIdentifier:identifier] addObject:cell];
}

- (NSMutableSet *)reusableCellSetForIdentifier:(NSString *)identifier
{
    NSMutableSet *set = [reusableCells objectForKey:identifier];
    if (!set)
    {
        set = [NSMutableSet set];
        [reusableCells setObject:set forKey:identifier];
    }
    return set;
}

#pragma mark - 

- (void)prepareForReuse
{
    [super prepareForReuse];
    for (SMCell* cell in subCells)
    {
        [cell removeFromSuperview];
        [self enqueueCell:cell withIdentifier:cell.cellData.cellIdentifier];
    }
    
    [verticalSeparatorLines makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [verticalSeparatorLines removeAllObjects];
}

#pragma mark - Touches

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitTestedView = [super hitTest:point withEvent:event];
    if (!hitTestedView || [hitTestedView isKindOfClass:[UIControl class]])
        return hitTestedView;
        
    for (UITableViewCell* subCell in subCells)
    {
        if(subCell == hitTestedView || subCell.contentView == hitTestedView)
        {
            hitTestedView = self;
            break;
        }
    }
    
    return hitTestedView;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch* touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan)
    {
        CGPoint location = [touch locationInView:self];
        CGPoint cellLocation;
        
        for(SMCell* cell in subCells)
        {
            cellLocation = [self convertPoint:location toView:cell];
            if([cell pointInside:cellLocation withEvent:event])
            {
                [cell setSelected:YES animated:NO];
                [self bk_performBlock:^(id sender)
                 {
                     [cell.cellData performSelectedHandlers];
                     
                 } afterDelay:0.05];
                
                break;
            }
        }
        
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
 
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    BOOL isSelectedCellFound = NO;
    
    for(SMCell* cell in subCells)
    {
        if(cell.selected)
        {
            if (!isSelectedCellFound && [cell pointInside:[self convertPoint:location toView:cell] withEvent:event])
            {
                isSelectedCellFound = YES;
                [self bk_performBlock:^(id sender)
                {
                    [cell.cellData performDeselectedHandlers];
                } afterDelay:0.05];
            }
            
            [cell setSelected:NO animated:YES];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    for(SMCell* cell in subCells)
    {
        [cell setSelected:NO animated:NO];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGPoint cellLocation;
 
    for(SMCell* cell in subCells)
    {
        cellLocation = [self convertPoint:location toView:cell];
        if([cell pointInside:cellLocation withEvent:event])
        {
            [cell setSelected:NO animated:NO];
            break;
        }
    }
}


#pragma mark - Separator lines

- (UIView*)verticalSeparatorLineAtIndex:(NSUInteger)index
{
    SMCompoundCellData* cellData = (SMCompoundCellData*)self.cellData;

    UIView* separatorLine = [[UIView alloc] initWithFrame:CGRectZero];
    separatorLine.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    separatorLine.backgroundColor = cellData.verticalSeparatorLinesColor;
    return separatorLine;
}

@end


@implementation SMCompoundCellData

- (instancetype)initWithModel:(SMCompoundModel*)aCompoundModel
{
    self = [super initWithModel:aCompoundModel];
    if(self)
    {
        self.cellClass = [SMCompoundCell class];
        self.cellAccessoryType = UITableViewCellAccessoryNone;
        self.cellSelectionStyle = UITableViewCellSelectionStyleNone;
        self.verticalSeparatorLinesColor = [UIColor whiteColor];
        
        self.itemSpacing = 0;
        self.itemInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (void)setTableDisposer:(SMTableDisposerModeled *)tableDisposer
{
    _tableDisposer = tableDisposer;

    _cellDatas = [NSMutableArray array];
    
    SMCompoundModel* compoundModel = (SMCompoundModel*)self.model;
    for(id model in compoundModel.models)
    {
        SMCellDataModeled* cellData = [(SMTableDisposerModeled*)self.tableDisposer cellDataFromModel:model];
        if(cellData)
        {
            [self.cellDatas addObject:cellData];
            
            if([self.tableDisposer.modeledDelegate respondsToSelector:@selector(tableDisposer:didCreateCellData:)])
                [self.tableDisposer.modeledDelegate tableDisposer:self.tableDisposer didCreateCellData:cellData];
        }
    }
}

- (CGFloat)cellHeightForWidth:(CGFloat)aWidth
{
    CGFloat newCellHeight = 0.0f;
    for(SMCellDataModeled* cellData in self.cellDatas)
        newCellHeight = MAX([cellData cellHeightForWidth:[self subCellWidthForCompoundCellWidth:aWidth]], newCellHeight);

    self.cellHeight = newCellHeight + self.itemInsets.top + self.itemInsets.bottom;
    return self.cellHeight;
}

- (CGFloat)subCellWidthForCompoundCellWidth:(CGFloat)aWidth
{
    NSUInteger maxCount = [(SMCompoundModel*)self.model maxModelsCount];
    CGFloat width = aWidth - self.itemInsets.left - self.itemInsets.right - self.itemSpacing * (maxCount - 1);
    return floorf(width / maxCount);
}

@end
