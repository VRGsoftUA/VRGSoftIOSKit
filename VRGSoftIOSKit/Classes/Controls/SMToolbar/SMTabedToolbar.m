//
//  SMTabBar.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 7/25/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import "SMTabedToolbar.h"


@interface SMTabedToolbar ()

- (void)setup;
- (void)itemPressed:(UIButton*)aSender;

@end

@implementation SMTabedToolbar

@synthesize smdelegate;
@synthesize buttons;
@synthesize enabled;

#pragma mark - Init/Dealloc

- (instancetype)init
{
    if( (self = [super init]) )
    {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)aFrame
{
	if( (self = [super initWithFrame:aFrame]) )
	{
        [self setup];
	}
	
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if( (self = [super initWithCoder:aDecoder]) )
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    buttons = [NSMutableArray new];
    self.backgroundColor = [UIColor clearColor];
    self.enabled = YES;
}

- (void)itemPressed:(UIButton*)aSender
{
	if(!enabled)
		return;
    
    BOOL canSelect = YES;
    if([smdelegate respondsToSelector:@selector(tabedToolbar:shouldSelectItemAtIndex:)])
        canSelect = [smdelegate tabedToolbar:self shouldSelectItemAtIndex:aSender.tag];

    if(canSelect)
    {
        NSUInteger prevIndex = (currentItem) ? (currentItem.tag) : (NSNotFound);
        [self switchToItemWithIndex:aSender.tag];
        
        if([smdelegate respondsToSelector:@selector(tabedToolbar:itemChangedTo:from:)])
            [smdelegate tabedToolbar:self itemChangedTo:aSender.tag from:prevIndex];
    }
}

/**
 * Programmaticaly switch to title by index
 * delegate method
 * - (void) tabBar:(MUTabBar*)aTabBar itemChangedTo:(int)aToIndex from:(int)aFromIndex;
 * WON'T be called
 */
- (void)switchToItemWithIndex:(NSUInteger)aIndex
{
    UIButton* selItem = nil;
    if(aIndex < [buttons count])
    {
        selItem = [buttons objectAtIndex:aIndex];
    }

    currentItem.enabled = YES;
    selItem.enabled = NO;
    currentItem = selItem;
}

- (void)setEnabled:(BOOL)aEnabled
{
	enabled = aEnabled;
	self.userInteractionEnabled = enabled;
}

- (void)setItems:(NSArray *)anItems
{
    [buttons removeAllObjects];
    
    UIButton* bt;
    
    int index = 0;
    for(UIBarButtonItem* bbi in anItems)
    {
        if([bbi.customView isKindOfClass:[UIButton class]])
        {
            bt = (UIButton*)bbi.customView;
            [buttons addObject:bt];
            
            bt.tag = index++;
            [bt addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    super.items = anItems;
}

@end
