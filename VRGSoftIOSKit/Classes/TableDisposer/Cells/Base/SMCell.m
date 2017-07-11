//
//  SMCell.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 30.03.12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMCell.h"
#import "SMCellData.h"
#import <QuartzCore/CALayer.h>
#import "SMKitDefines.h"

#define kSMCellTopSeparatorTag    113344
#define kSMCellBottomSeparatorTag 223344

@implementation SMCell

@synthesize cellData;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - Setup

- (void)setupCellData:(SMCellData *)aCellData
{
    if (cellData != aCellData)
    {
        cellData = aCellData;
    }
    
    if (aCellData.cellWidth > 0)
    {
        CGRect frame = self.frame;
        frame.size.width = cellData.cellWidth;
        self.frame = frame;
        if (!self.superview)
        {
            self.contentView.frame = self.bounds;
        }
    }
    
    self.selectionStyle = cellData.cellSelectionStyle;
    self.accessoryType = cellData.cellAccessoryType;
    self.tag = cellData.tag;
    
    [self configureSeparators];
}

- (NSArray*)inputTraits
{
    return nil;
}

- (NSString*)reuseIdentifier
{
    return self.cellData.cellIdentifier;
}

#pragma mark - Separators

- (void)configureSeparators
{
    UIView *topSeparator = [self viewWithTag:kSMCellTopSeparatorTag];    
    if ((self.cellData.cellSeparatorStyle & SMCellSeparatorStyleTop) && self.cellData.cellTopSeparatorColor)
    {
        if (!topSeparator)
        {
            topSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, kSMCellSeparatorHeight)];
            topSeparator.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
            topSeparator.layer.borderWidth = kSMCellSeparatorHeight;
            topSeparator.tag = kSMCellTopSeparatorTag;
            [self addSubview:topSeparator];
        }
        
        topSeparator.layer.borderColor = self.cellData.cellTopSeparatorColor.CGColor;
        [self bringSubviewToFront:topSeparator];
    }
    else
        [topSeparator removeFromSuperview];
    
    UIView *bottomSeparator = [self viewWithTag:kSMCellBottomSeparatorTag];
    if ((self.cellData.cellSeparatorStyle & SMCellSeparatorStyleBottom) && self.cellData.cellBottomSeparatorColor)
    {
        if (!bottomSeparator)
        {
            bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - kSMCellSeparatorHeight, self.bounds.size.width, kSMCellSeparatorHeight)];
            bottomSeparator.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
            bottomSeparator.layer.borderWidth = kSMCellSeparatorHeight;
            bottomSeparator.tag = kSMCellBottomSeparatorTag;
            [self addSubview:bottomSeparator];
        }
        
        bottomSeparator.layer.borderColor = self.cellData.cellBottomSeparatorColor.CGColor;
        [self bringSubviewToFront:bottomSeparator];
    }
    else
        [bottomSeparator removeFromSuperview];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!SM_IS_IOS8)
    {
        CGRect frame = self.contentView.frame;
        frame.size.height = self.frame.size.height;
        if ((self.cellData.cellSeparatorStyle & SMCellSeparatorStyleTop) && self.cellData.cellTopSeparatorColor)
        {
            frame.origin.y += kSMCellSeparatorHeight;
            frame.size.height -= kSMCellSeparatorHeight;
        }
        
        if ((self.cellData.cellSeparatorStyle & SMCellSeparatorStyleBottom) && self.cellData.cellBottomSeparatorColor)
        {
            frame.size.height -= kSMCellSeparatorHeight;
        }
        
        self.contentView.frame = frame;
    }
}

@end
