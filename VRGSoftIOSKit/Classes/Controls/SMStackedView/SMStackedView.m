//
//  SMStackedView.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 10/6/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import "SMStackedView.h"


@interface SMStackedView ()

- (void)setup;
- (void)switchToStackedSubview:(UIView*)aStackedSubview;

@end


@implementation SMStackedView

@synthesize delegate;
@synthesize currentIndex;
@dynamic currentStackedSubview;
@dynamic countStackedSubviews;

#pragma mark - Init/Dealloc

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( (self = [super initWithFrame:frame]) )
    {
        [self setup];
    }

    return self;
}

- (instancetype)init
{
    if( (self = [super init]) )
    {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.clipsToBounds = YES;
    stackedSubviews = [NSMutableArray new];
}

#pragma mark - Add/Remove stacked subviews

- (void)addStackedSubview:(UIView *)aView
{
    NSParameterAssert(aView);
    [stackedSubviews addObject:aView];
}

- (void)insertStackedSubview:(UIView *)aView atIndex:(NSUInteger)aIndex
{
    NSParameterAssert(aView);
    [stackedSubviews insertObject:aView atIndex:aIndex];
}

- (void)removeStackedSubviewAtIndex:(NSUInteger)aIndex
{
    UIView* view = [stackedSubviews objectAtIndex:aIndex];
    if(view == currentView)
    {
        [currentView removeFromSuperview];
        currentView = nil;
    }
    [stackedSubviews removeObjectAtIndex:aIndex];
}

- (void)removeStackedSubview:(UIView *)aView
{
    NSParameterAssert(aView);
    NSUInteger index = [stackedSubviews indexOfObject:aView];
    [self removeStackedSubviewAtIndex:index];
}

- (void)removeAllStackedSubviews
{
    [stackedSubviews removeAllObjects];
    [currentView removeFromSuperview];
    currentView = nil;
}

- (NSUInteger)countStackedSubviews
{
    return [stackedSubviews count];
}

#pragma mark - Switch between stacked subviews

- (void)setCurrentIndex:(NSUInteger)aCurrentIndex
{
    if(aCurrentIndex < [stackedSubviews count])
    {
        [self switchToStackedSubview:[stackedSubviews objectAtIndex:aCurrentIndex]];
    }
}

- (void)setCurrentStackedSubview:(UIView *)aCurrentStackedSubview
{
    NSUInteger index = [stackedSubviews indexOfObject:aCurrentStackedSubview];
    [self setCurrentIndex:index];
}

- (UIView*)currentStackedSubview
{
    return currentView;
}

- (void)switchToStackedSubview:(UIView*)aStackedSubview
{
    NSUInteger fromIndex = (currentView) ? ([stackedSubviews indexOfObject:currentView]) : (NSNotFound);
    NSUInteger toIndex = [stackedSubviews indexOfObject:aStackedSubview];
    
    if(delegate && [delegate respondsToSelector:@selector(stackedView:willChangeFromIndex:toIndex:)])
        [delegate stackedView:self willChangeFromIndex:fromIndex toIndex:toIndex];

//    currentView.hidden = YES;
    [currentView removeFromSuperview];
    currentView = aStackedSubview;
    currentView.hidden = NO;
    [self addSubview:currentView];
    currentView.frame = self.bounds;

    currentIndex = toIndex;

    if(delegate && [delegate respondsToSelector:@selector(stackedView:didChangedFromIndex:toIndex:)])
        [delegate stackedView:self didChangedFromIndex:fromIndex toIndex:toIndex];
}

@end
