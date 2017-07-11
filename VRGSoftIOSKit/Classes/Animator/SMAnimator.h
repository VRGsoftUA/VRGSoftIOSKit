//
//  SMAnimator.h
//  VRGSoftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 12/28/15.
//  Copyright © 2015 VRGSoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@class SMAnimator;
typedef void (^SMAnimatorCompletionBlock)(SMAnimator *aAnimator, BOOL aCanceled);


@interface SMAnimatorCompletioNode : NSObject

@property (nonatomic, copy) SMAnimatorCompletionBlock block;

@end

@interface SMAnimator : NSObject
{
    @public
    NSTimeInterval duration;
    NSTimeInterval delay;
    NSMutableArray *completionNodes;
    NSInteger repeatCount;
    BOOL repeatForever;
    BOOL isInver;
    
    id strongSelf;//Make retain self
}

@property (nonatomic, assign) NSTimeInterval duration;      //sec default 0.2f
@property (nonatomic, assign) NSTimeInterval delay;         //sec default 0.0f
@property (nonatomic, assign) NSInteger repeatCount;        //defaul 1

@property (nonatomic, assign) BOOL repeatForever;           //defaul NO
@property (nonatomic, assign) BOOL inverceRepeatBehavior;   //defaul YES

@property (nonatomic, assign) BOOL isAnimating;

- (void)start;
- (void)stop;

- (void)addCallback:(SMAnimatorCompletionBlock)aCallBack;

- (void)removeAllCallbacks;
- (void)executeAllCallbacksWithCancel:(BOOL)isCancel;

//For overriding
- (void)applyBehavior;
- (void)applyBehaviorInvert;

- (void)retainSelf;
- (void)releaseSelf;

@end

@interface SMAnimatorView : SMAnimator
{
    __weak UIView *view;
}
@property (nonatomic, readonly) UIView *view;

+ (instancetype)makeWithView:(UIView *)aView duration:(NSTimeInterval)aDuration comlition:(SMAnimatorCompletionBlock)aBlock;
- (instancetype)initWithView:(UIView *)aView duration:(NSTimeInterval)aDuration comlition:(SMAnimatorCompletionBlock)aBlock;
- (instancetype)initWithView:(UIView *)aView;

@end

@interface SMAnimatorCompound : SMAnimator
{
    NSMutableArray <SMAnimator *> *animators;
}

+ (instancetype)makeWithAniamtions:(NSArray <SMAnimator *>*)aAnimations;
- (instancetype)initWithAniamtions:(NSArray <SMAnimator *>*)aAnimations;

@end

@interface SMAnimatorGroup : SMAnimatorCompound

@end


@interface SMAnimatorSequence : SMAnimatorCompound

@property (nonatomic,assign) BOOL isExcludeRepeatEdges; // defoult NO

@end


@interface SMAnimatorViewFrame : SMAnimatorView

@property (nonatomic,assign) CGRect startFrame;
@property (nonatomic,assign) CGRect frame;

@end


@interface SMAnimatorViewCenter : SMAnimatorView

@property (nonatomic,assign) CGPoint startCenter;
@property (nonatomic,assign) CGPoint center;

@end


@interface SMAnimatorViewSize : SMAnimatorView

@property (nonatomic,assign) CGSize startSize;
@property (nonatomic,assign) CGSize size;

@end


@interface SMAnimatorViewAlpha : SMAnimatorView

@property (nonatomic,assign) CGFloat startAlpha;
@property (nonatomic,assign) CGFloat alpha;

@end


@interface SMAnimatorViewBackgroundColor : SMAnimatorView

@property (nonatomic,strong) UIColor *startBackgroundColor;
@property (nonatomic,strong) UIColor *backgroundColor;

@end


@interface SMAnimatorViewScale : SMAnimatorView

@property (nonatomic,assign) CGPoint startScale;
@property (nonatomic,assign) CGPoint scale;

@end


@interface SMAnimatorViewRotation : SMAnimatorView

@property (nonatomic,assign) CGFloat startAngle;
@property (nonatomic,assign) CGFloat angle;

@end


typedef void (^SMAnimatorViewBlockType)(SMAnimatorView *aAnimator);

@interface SMAnimatorViewBlock : SMAnimatorView

@property (nonatomic,copy) SMAnimatorViewBlockType behaviorBlock;
@property (nonatomic,copy) SMAnimatorViewBlockType behaviorInvertBlock;

@end

