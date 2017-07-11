//
//  SMStackedView.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 10/6/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import <UIKit/UIKit.h>

@class SMStackedView;

@protocol SMStackedViewDelegate <NSObject>

@optional
- (void)stackedView:(SMStackedView*)aStackedView willChangeFromIndex:(NSUInteger)aFromIndex toIndex:(NSUInteger)aToIndex;
- (void)stackedView:(SMStackedView*)aStackedView didChangedFromIndex:(NSUInteger)aFromIndex toIndex:(NSUInteger)aToIndex;

@end


@interface SMStackedView : UIView
{
    NSMutableArray* stackedSubviews;
    UIView* currentView;
}

@property (nonatomic, weak) id<SMStackedViewDelegate> delegate;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, assign) UIView* currentStackedSubview;
@property (nonatomic, readonly) NSUInteger countStackedSubviews;

- (void)addStackedSubview:(UIView *)aView;
- (void)insertStackedSubview:(UIView *)aView atIndex:(NSUInteger)aIndex;
- (void)removeStackedSubviewAtIndex:(NSUInteger)aIndex;
- (void)removeStackedSubview:(UIView *)aView;
- (void)removeAllStackedSubviews;

@end
