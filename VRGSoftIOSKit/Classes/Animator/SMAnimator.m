//
//  SMAnimator.m
//  VRGSoftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 12/28/15.
//  Copyright © 2015 VRGSoft. All rights reserved.
//

#import "SMAnimator.h"
#import "SMKitDefines.h"

@implementation SMAnimatorCompletioNode

@end


@interface SMAnimator ()

@property (nonatomic, assign) NSInteger currentRepeatCount;
@property(nonatomic,assign) BOOL isInver;

@end


@implementation SMAnimator
@synthesize duration,delay,repeatCount,repeatForever,inverceRepeatBehavior,isInver;

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self setupDefault];
    }
    return self;
}

- (void)dealloc
{
    SMDeallocLog;
}

- (void)setupDefault
{
    _currentRepeatCount = 0;
    delay = 0.0f;
    duration = 0.2f;
    
    repeatCount = 0;
    repeatForever = NO;
    isInver = NO;
    inverceRepeatBehavior = YES;
}

- (void)applyBehavior
{
    
}

- (void)applyBehaviorInvert
{
    
}

- (void)start
{
    [self retainSelf];
    
    if (self.isAnimating)
    {
        [self stop];
    }
    
    self.isAnimating = YES;
    __weak typeof (&*self) __self = self;
    
    if (delay)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [__self beginAnimation];
        });
    } else
    {
        [__self beginAnimation];
    }
    
    self.currentRepeatCount++;
}

- (void)stop
{
    [self executeAllCallbacksWithCancel:YES];
}

- (void)beginAnimation
{
    if (self.isInver && self.inverceRepeatBehavior)
    {
        [self applyBehaviorInvert];
    } else
    {
        [self applyBehavior];
    }
}

- (void)addCallback:(SMAnimatorCompletionBlock)aCallBack;
{
    if (!completionNodes)
    {
        completionNodes = [NSMutableArray new];
    }
    NSAssert(aCallBack, @"SMAnimator - CallBack can't be nil");
    
    SMAnimatorCompletioNode *node = [SMAnimatorCompletioNode new];
    
    node.block = aCallBack;
    
    [completionNodes addObject:node];
}

- (void)removeAllCallbacks
{
    [completionNodes removeAllObjects];
}

- (void)executeAllCallbacksWithCancel:(BOOL)isCancel
{
    self.isAnimating = NO;
    
    if (!isCancel)
    {
        self.isInver = !self.isInver;
    }
    
    if ((self.repeatForever && !isCancel) || (self.currentRepeatCount < self.repeatCount && !isCancel))
    {
        [self start];
    } else
    {
        self.currentRepeatCount = 0;
        __weak SMAnimator *__self = self;
        NSMutableArray *willRemove = [NSMutableArray new];
        for (SMAnimatorCompletioNode *node in completionNodes)
        {
            if (node.block)
            {
                node.block(__self,isCancel);
                [willRemove addObject:node];
            }
        }
        
        [__self releaseSelf];
        
        [completionNodes removeObjectsInArray:willRemove];
    }
}

- (void)retainSelf
{
    strongSelf = self;
}

- (void)releaseSelf
{
    strongSelf = nil;
}

@end


@implementation SMAnimatorView
@synthesize view;

+ (instancetype)makeWithView:(UIView *)aView duration:(NSTimeInterval)aDuration comlition:(SMAnimatorCompletionBlock)aBlock
{
    id animator = [[[self class] alloc] initWithView:aView duration:aDuration comlition:aBlock];
    
    return animator;
}

- (instancetype)initWithView:(UIView *)aView
{
    self = [super init];
    
    if (self)
    {
        view = aView;
    }
    return self;
}

- (instancetype)initWithView:(UIView *)aView duration:(NSTimeInterval)aDuration comlition:(SMAnimatorCompletionBlock)block
{
    self = [super init];
    if (self)
    {
        view = aView;
        duration = aDuration;
        
        if (block)
        {
            [self addCallback:block];
        }
    }
    
    return self;
}

- (void)beginAnimation
{
    __weak SMAnimator *__self = self;
    
    if (self.view)
    {
        [UIView animateWithDuration:duration
                         animations:^{
                             if (__self.isInver && __self.inverceRepeatBehavior)
                             {
                                 [__self applyBehaviorInvert];
                             } else
                             {
                                 [__self applyBehavior];
                             }
                             
                         } completion:^(BOOL finished) {
                             [__self executeAllCallbacksWithCancel:!finished];
                         }];
    } else
    {
        [self executeAllCallbacksWithCancel:YES];
    }
}

- (void)stop
{
    [view.layer removeAllAnimations];
    [super stop];
}

@end


@implementation SMAnimatorCompound

+ (instancetype)makeWithAniamtions:(NSArray <SMAnimator *>*)aAnimations
{
    SMAnimatorCompound *animator = [[[self class] alloc] initWithAniamtions:aAnimations];
    return animator;
}

- (instancetype)initWithAniamtions:(NSArray <SMAnimator *>*)aAnimations
{
    self = [super init];
    
    if (self)
    {
        animators = [NSMutableArray new];
        if (aAnimations)
        {
            [animators addObjectsFromArray:aAnimations];
        }
    }
    return self;
}

- (void)stop
{
    for (SMAnimator *a in animators)
    {
        [a stop];
    }
}

@end

@implementation SMAnimatorSequence

- (void)applyBehavior
{
    if (self.isExcludeRepeatEdges && animators.count > 1 && self.currentRepeatCount != 0)
    {
        [self startAnimationWithIndex:0 + 1];
    } else
    {
        [self startAnimationWithIndex:0];
    }
}

- (void)applyBehaviorInvert
{
    if (self.isExcludeRepeatEdges && animators.count > 1)
    {
        [self startAnimationWithIndex:animators.count - 1 - 1];
    } else
    {
        [self startAnimationWithIndex:animators.count - 1];
    }
}

- (void)startAnimationWithIndex:(NSInteger)aIndex
{
    __weak typeof (&*self) __self = self;
    
    if ((aIndex >= animators.count && !self.isInver) || (aIndex < 0 && self.isInver))
    {
        [self executeAllCallbacksWithCancel:NO];
    } else
    {
        SMAnimator *animator = animators[aIndex];
        
        [animator addCallback:^(SMAnimator *aAnimator, BOOL aCanceled) {
            if (aCanceled)
            {
                [__self executeAllCallbacksWithCancel:YES];
            } else
            {
                [__self startAnimationWithIndex:aIndex+((__self.isInver)?-1:1)];
            }
        }];
        
        [animator start];
    }
}

@end


@implementation SMAnimatorGroup

- (void)beginAnimation
{
    __weak typeof (&*self) __self = self;
    
    for (SMAnimator *a in animators)
    {
        if (self.repeatCount)
        {
            a.repeatCount = self.repeatCount;
        }
        
        if (self.repeatForever)
        {
            a.repeatForever = self.repeatForever;
        }
        
        [a addCallback:^(SMAnimator *aAnimator, BOOL aCanceled) {
            [__self executeAllCallbacksWithCancel:aCanceled];
        }];
        
        [a start];
        //        if (a.delay)
        //        {
        //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //                [a beginAnimation];
        //            });
        //        } else
        //        {
        //            [a beginAnimation];
        //        }
    }
}

- (void)executeAllCallbacksWithCancel:(BOOL)isCancel
{
    BOOL canPerfomBlocks = YES;
    
    for (SMAnimator *animator in animators)
    {
        if (animator.isAnimating)
        {
            canPerfomBlocks = NO;
            break;
        }
    }
    
    if (canPerfomBlocks)
    {
        [super executeAllCallbacksWithCancel:isCancel];
    }
}

@end

//Simle animations

@implementation SMAnimatorViewFrame

- (void)applyBehavior
{
    self.startFrame = view.frame;
    view.frame = self.frame;
}

- (void)applyBehaviorInvert
{
    view.frame = self.startFrame;
}

@end


@implementation SMAnimatorViewCenter

- (void)applyBehavior
{
    self.startCenter = view.center;
    view.center = self.center;
}

- (void)applyBehaviorInvert
{
    view.center = self.startCenter;
}

@end


@implementation SMAnimatorViewSize

- (void)applyBehavior
{
    self.startSize = view.frame.size;
    
    CGFloat dx = self.size.width - view.frame.size.width;
    CGFloat dy = self.size.height - view.frame.size.height;
    
    CGFloat x0 = view.frame.origin.x - dx/2.0f;
    CGFloat y0 = view.frame.origin.y - dy/2.0f;
    
    view.frame = CGRectMake(x0, y0, self.size.width, self.size.height);
}

- (void)applyBehaviorInvert
{
    CGFloat dx = self.startSize.width - view.frame.size.width;
    CGFloat dy = self.startSize.height - view.frame.size.height;
    
    CGFloat x0 = view.frame.origin.x - dx/2.0f;
    CGFloat y0 = view.frame.origin.y - dy/2.0f;
    
    view.frame = CGRectMake(x0, y0, self.startSize.width, self.startSize.height);
}

@end


@implementation SMAnimatorViewAlpha

- (void)applyBehavior
{
    self.startAlpha = view.alpha;
    view.alpha = self.alpha;
}

- (void)applyBehaviorInvert
{
    view.alpha = self.startAlpha;
}

@end


@implementation SMAnimatorViewBackgroundColor

- (void)applyBehavior
{
    self.startBackgroundColor = view.backgroundColor;
    view.backgroundColor = self.backgroundColor;
}

- (void)applyBehaviorInvert
{
    view.backgroundColor = self.startBackgroundColor;
}

@end


@implementation SMAnimatorViewScale

- (CGFloat)xscale
{
    CGAffineTransform t = view.transform;
    return sqrt(t.a * t.a + t.c * t.c);
}

- (CGFloat)yscale
{
    CGAffineTransform t = view.transform;
    return sqrt(t.b * t.b + t.d * t.d);
}

- (void)applyBehavior
{
    CGPoint scale = CGPointMake([self xscale]/self.scale.x, [self yscale]/self.scale.y);
    self.startScale = scale;
    
    view.transform = CGAffineTransformConcat(view.transform, CGAffineTransformMakeScale(self.scale.x, self.scale.y));
}

- (void)applyBehaviorInvert
{
    view.transform = CGAffineTransformConcat(view.transform, CGAffineTransformScale(CGAffineTransformIdentity, self.startScale.x, self.startScale.y));
}

@end


@implementation SMAnimatorViewRotation

- (void)applyBehavior
{
    CGFloat angle = [[view valueForKeyPath:@"layer.transform.rotation.z"] floatValue] - self.angle;
    self.startAngle = angle;
    
    view.transform = CGAffineTransformConcat(view.transform, CGAffineTransformMakeRotation(self.angle));
}

- (void)applyBehaviorInvert
{
    view.transform = CGAffineTransformConcat(view.transform, CGAffineTransformMakeRotation(self.startAngle));
}

@end


@implementation SMAnimatorViewBlock

- (void)applyBehavior
{
    if (self.behaviorBlock)
    {
        self.behaviorBlock(self);
    }
}

- (void)applyBehaviorInvert
{
    if (self.behaviorInvertBlock)
    {
        self.behaviorInvertBlock(self);
    }
}

@end


