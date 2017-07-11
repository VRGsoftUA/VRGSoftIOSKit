//
//  UIView+More.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 2/12/15.
//  Copyright (c) 2015 VRGSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+PSSizes.h"

typedef void (^UIViewCompletionAniamtion)(UIView *aView, BOOL finished);

@interface UIView (More)

- (void)showWithDuration:(NSTimeInterval)aDuration completion:(UIViewCompletionAniamtion)completion;
- (void)hideWithDuration:(NSTimeInterval)aDuration completion:(UIViewCompletionAniamtion)completion;

- (void)hideWithAnimation:(BOOL)animation;
- (void)showWithAnimation:(BOOL)animation;
- (void)showWithDuration:(NSTimeInterval)aDuration;
- (void)hideWithDuration:(NSTimeInterval)aDuration;

- (void)setFrame:(CGRect)aFrame withDuration:(NSTimeInterval)aDuration completion:(UIViewCompletionAniamtion)completion;
- (void)setFrame:(CGRect)aFrame withDuration:(NSTimeInterval)aDuration;

- (void)setCenter:(CGPoint)aCenter withDuration:(NSTimeInterval)aDuration completion:(UIViewCompletionAniamtion)completion;
- (void)setCenter:(CGPoint)aCenter withDuration:(NSTimeInterval)aDuration;

- (void)setScale:(CGFloat)aScale withDuration:(NSTimeInterval)aDuration completion:(UIViewCompletionAniamtion)completion;
- (void)setScale:(CGFloat)aScale withDuration:(NSTimeInterval)aDuration;

- (void)setBackgroundColor:(UIColor *)aBackgroundColor withDuration:(NSTimeInterval)aDuration completion:(UIViewCompletionAniamtion)completion;
- (void)setBackgroundColor:(UIColor *)aBackgroundColor withDuration:(NSTimeInterval)aDuration;

- (void)setSize:(CGSize)aSize withDuration:(NSTimeInterval)aDuration completion:(UIViewCompletionAniamtion)completion;
- (void)setSize:(CGSize)aSize withDuration:(NSTimeInterval)aDuration;

- (void)setRotation:(CGFloat)aRadian withDuration:(NSTimeInterval)aDuration completion:(UIViewCompletionAniamtion)completion;
- (void)setRotation:(CGFloat)aRadian withDuration:(NSTimeInterval)aDuration;

- (void)setCenterLeftView:(UIView *)aView offSet:(CGFloat)aOffSet;
- (void)setCenterRightView:(UIView *)aView offSet:(CGFloat)aOffSet;
- (void)setCenterTopView:(UIView *)aView offSet:(CGFloat)aOffSet;
- (void)setCenterBottomView:(UIView *)aView offSet:(CGFloat)aOffSet;


- (void)setTopLeftView:(UIView *)aView offSet:(CGFloat)aOffSet;
- (void)setTopRightView:(UIView *)aView offSet:(CGFloat)aOffSet;
- (void)setBottomLeftView:(UIView *)aView offSet:(CGFloat)aOffSet;
- (void)setBottomRightView:(UIView *)aView offSet:(CGFloat)aOffSet;



- (void) setConstrainHeight:(CGFloat)aHeight;
- (void) setConstrainWidth:(CGFloat)aWidth;
- (void) setConstrainLeft:(CGFloat)aLeft;
- (void) setConstrainLeading:(CGFloat)aLeading;

+ (instancetype)loadFromNib;

- (UIImage *)imageCreate;

- (void)roundBorder;

@end
