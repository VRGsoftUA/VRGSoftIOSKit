//
//  SMCellData.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 3/29/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMCellData.h"
#import "SMTargetAction.h"

@implementation SMCellData

@synthesize cellNibName;
@synthesize cellClass;
@dynamic cellIdentifier;
@synthesize cellSelectionStyle;
@synthesize cellSeparatorStyle;
@synthesize cellStyle;
@synthesize cellAccessoryType;
@synthesize autoDeselect;
@synthesize visible;
@synthesize enableEdit;
@synthesize disableInputTraits;
@synthesize cellHeight,cellWidth;
@synthesize tag;
@synthesize userData;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        visible = YES;
        autoDeselect = YES;
        enableEdit = YES;
        cellSelectionStyle = UITableViewCellSelectionStyleBlue;
        cellStyle = UITableViewCellStyleDefault;
        cellAccessoryType = UITableViewCellAccessoryNone;
        
        cellSelectedHandlers = [NSMutableArray new];
        cellDeselectedHandler = [NSMutableArray new];
        
        cellHeight = 44.f;
        cellWidth = 0.0f;
        cellSeparatorStyle = SMCellSeparatorStyleNone;
    }
    return self;
}

- (CGFloat)cellHeightForWidth:(CGFloat) aWidth
{
    return cellHeight;
}

- (NSString *)cellIdentifier
{
    return NSStringFromClass([self class]);
}

#pragma mark - Handlers

- (void)addCellSelectedTarget:(id)aTarget action:(SEL)anAction
{
    [cellSelectedHandlers addObject:[SMTargetAction targetActionWithTarget:aTarget action:anAction]];
}

- (void)addCellDeselectedTarget:(id)aTarget action:(SEL)anAction
{
    [cellDeselectedHandler addObject:[SMTargetAction targetActionWithTarget:aTarget action:anAction]];
}

- (void)performSelectedHandlers
{
    for(SMTargetAction* handler in cellSelectedHandlers)
    {
        [handler sendActionFrom:self];
    }
}

- (void)performDeselectedHandlers
{
    for(SMTargetAction* handler in cellDeselectedHandler)
    {
        [handler sendActionFrom:self];
    }
}

#pragma mark - Create cell

- (SMCell*)createCell
{
    SMCell* cell = nil;
    
    if(cellNibName)
        cell = (SMCell*)[[[NSBundle mainBundle] loadNibNamed:cellNibName owner:self options:nil] lastObject];
    else
        cell = [[self.cellClass alloc] initWithStyle:self.cellStyle reuseIdentifier:self.cellIdentifier];
    
    return cell;
}

@end
