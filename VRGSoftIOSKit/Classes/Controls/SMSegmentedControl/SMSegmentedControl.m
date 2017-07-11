//
//  SMSegmentedControl.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 7/13/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import "SMSegmentedControl.h"


@interface SMSegmentedControl ()

- (void)itemPressed:(UIButton*)aSender;

@end

@implementation SMSegmentedControl

@synthesize backgroundImageView = bgImageView;
@dynamic currentIndex;

- (instancetype)init
{
    if( (self = [super init]) )
    {
        bgImageView = [[UIImageView alloc] init];
        [self addSubview:bgImageView];
        buttons = [NSMutableArray new];
    }
    
    return self;
}

- (void)setBackgroundImage:(UIImage*)aBackgroundImage
{
    [bgImageView setImage:aBackgroundImage];
}

- (void)addButton:(UIButton*)aButton
{
    if(aButton)
    {
        [self addSubview:aButton];
        [buttons addObject:aButton];
        [aButton addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)itemPressed:(UIButton*)aSender
{
	if(self.enabled)
    {
        NSUInteger index = [buttons indexOfObject:aSender];
        [self switchToItemWithIndex:index];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

// programmaticaly switch by index
- (void)switchToItemWithIndex:(NSUInteger)aIndex
{
    if(aIndex < [buttons count])
    {
        UIButton* selItem = [buttons objectAtIndex:aIndex];
        if(selItem && selItem != currentItem)
        {
            currentItem.enabled = YES;
            selItem.enabled = NO;
            currentItem = selItem;
        }
    }
}

- (NSUInteger)currentIndex
{
    return [buttons indexOfObject:currentItem];
}

@end
