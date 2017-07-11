//
//  UIView+More.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 2/12/15.
//  Copyright (c) 2015 VRGSoft. All rights reserved.
//

#import "UIView+More.h"

@implementation UIView (More)


- (void)showWithDuration:(NSTimeInterval)aDuration completion:(UIViewCompletionAniamtion)completion
{
    self.hidden = NO;
    __weak UIView *view = self;
    [UIView animateWithDuration:aDuration animations:^{
        view.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            view.alpha = 1;
        }
        completion(view,finished);
    }];
}

- (void)hideWithDuration:(NSTimeInterval)aDuration completion:(UIViewCompletionAniamtion)completion
{
    self.hidden = NO;
    __weak UIView *view = self;
    
    [UIView animateWithDuration:aDuration animations:^{
        view.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            view.alpha = 0;
            view.hidden = YES;
            completion(view,finished);
        }
    }];
}

- (void)hideWithAnimation:(BOOL)animation
{
    if (animation) {
        __weak UIView *view = self;
        
        [UIView animateWithDuration:0.2 animations:^{
            view.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                view.alpha = 0;
                view.hidden = YES;
            }
        }];
    }else
    {
        self.alpha = 0;
        self.hidden = YES;
    }
}

- (void)showWithAnimation:(BOOL)animation
{
    if (animation) {
        self.hidden = NO;
        __weak UIView *view = self;
        [UIView animateWithDuration:0.2 animations:^{
            view.alpha = 1;
        } completion:^(BOOL finished) {
            if (finished) {
                view.alpha = 1;
            }
        }];
    }else
    {
        self.alpha = 1;
        self.hidden = NO;
    }
}

- (void)showWithDuration:(NSTimeInterval)aDuration
{
    self.hidden = NO;
    
    __weak UIView *view = self;
    
    [UIView animateWithDuration:aDuration animations:^{
        view.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            view.alpha = 1;
        }
    }];
}

- (void)hideWithDuration:(NSTimeInterval)aDuration
{
    self.hidden = NO;
    
    __weak UIView *view = self;
    
    [UIView animateWithDuration:aDuration animations:^{
        view.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            view.alpha = 0;
            view.hidden = YES;
        }
    }];
}

- (void)setFrame:(CGRect)aFrame withDuration:(NSTimeInterval)aDuration completion:(UIViewCompletionAniamtion)completion
{
    __weak UIView *view = self;
    
    [UIView animateWithDuration:aDuration animations:^{
        
        view.frame = aFrame;
        [view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        if (finished) {
            view.frame = aFrame;
            if (completion)
            {
                completion(view,finished);
            }
        }
    }];
}

- (void)setFrame:(CGRect)aFrame withDuration:(NSTimeInterval)aDuration
{
    [self setFrame:aFrame withDuration:aDuration completion:nil];
}

- (void)setCenter:(CGPoint)aCenter withDuration:(NSTimeInterval)aDuration completion:(UIViewCompletionAniamtion)completion
{
    __weak UIView *view = self;
    
    [UIView animateWithDuration:aDuration animations:^{
        
        view.center = aCenter;
        [view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        if (finished) {
            view.center = aCenter;
            if (completion)
            {
                completion(view,finished);
            }
        }
    }];
    
}
- (void)setCenter:(CGPoint)aCenter withDuration:(NSTimeInterval)aDuration
{
    [self setCenter:aCenter withDuration:aDuration completion:nil];
}

- (void)setScale:(CGFloat)aScale withDuration:(NSTimeInterval)aDuration completion:(UIViewCompletionAniamtion)completion
{
    __weak UIView *view = self;
    
    [UIView animateWithDuration:aDuration
                     animations:^{
                         CGAffineTransform transform =
                         CGAffineTransformScale(CGAffineTransformIdentity, aScale, aScale);
                         view.transform = transform;
                     } completion:^(BOOL finished) {
                         if (completion)
                         {
                             completion(view,finished);
                         }
                     }];
}

- (void)setScale:(CGFloat)aScale withDuration:(NSTimeInterval)aDuration
{
    [self setScale:aScale withDuration:aDuration completion:nil];
}

- (void)setBackgroundColor:(UIColor *)aBackgroundColor withDuration:(NSTimeInterval)aDuration completion:(UIViewCompletionAniamtion)completion
{
    __weak UIView *view = self;
    
    [UIView animateWithDuration:aDuration
                     animations:^{
                         view.backgroundColor = aBackgroundColor;
                     } completion:^(BOOL finished) {
                         if (completion)
                         {
                             completion(view,finished);
                         }
                     }];
}

- (void)setBackgroundColor:(UIColor *)aBackgroundColor withDuration:(NSTimeInterval)aDuration
{
    [self setBackgroundColor:aBackgroundColor withDuration:aDuration completion:nil];
}

- (void)setSize:(CGSize)aSize withDuration:(NSTimeInterval)aDuration completion:(UIViewCompletionAniamtion)completion
{
    __weak UIView *view = self;
    
    CGFloat dx = aSize.width - self.size.width;
    CGFloat dy = aSize.height - self.size.height;
    
    CGFloat x0 = self.origin.x - dx/2.0f;
    CGFloat y0 = self.origin.y - dy/2.0f;
    
    [UIView animateWithDuration:aDuration animations:^{
        
        view.frame = CGRectMake(x0, y0, aSize.width, aSize.height);
        [view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        if (finished) {
            view.frame = CGRectMake(x0, y0, aSize.width, aSize.height);
            if (completion)
            {
                completion(view,finished);
            }
        }
    }];
}

- (void)setSize:(CGSize)aSize withDuration:(NSTimeInterval)aDuration
{
    [self setSize:aSize withDuration:aDuration completion:nil];
}

- (void)setRotation:(CGFloat)aRadian withDuration:(NSTimeInterval)aDuration completion:(UIViewCompletionAniamtion)completion
{
    __weak UIView *view = self;
    
    [UIView animateWithDuration:aDuration animations:^{
        
        [view layoutIfNeeded];
        view.transform = CGAffineTransformMakeRotation(aRadian);
        
    } completion:^(BOOL finished) {
        if (finished) {
            view.transform = CGAffineTransformMakeRotation(aRadian);
            if (completion)
            {
                completion(view,finished);
            }
        }
    }];
}

- (void)setRotation:(CGFloat)aRadian withDuration:(NSTimeInterval)aDuration
{
    [self setRotation:aRadian withDuration:aDuration completion:nil];
}

- (void)setCenterLeftView:(UIView *)aView offSet:(CGFloat)aOffSet
{
    aView.center = CGPointMake(self.left - aOffSet - aView.width/2.0f, self.center.y);
    
}
- (void)setCenterRightView:(UIView *)aView offSet:(CGFloat)aOffSet
{
    aView.center = CGPointMake(self.right + aOffSet + aView.width/2.0f, self.center.y);
}
- (void)setCenterTopView:(UIView *)aView offSet:(CGFloat)aOffSet
{
    aView.center = CGPointMake(self.center.x, self.top - aOffSet - aView.height/2.0f);
}
- (void)setCenterBottomView:(UIView *)aView offSet:(CGFloat)aOffSet
{
    aView.center = CGPointMake(self.center.x, self.bottom + aOffSet + aView.height/2.0f);
}



- (void)setTopLeftView:(UIView *)aView offSet:(CGFloat)aOffSet
{
    aView.center = CGPointMake(self.left - aOffSet - aView.width/2.0f, self.top + aView.height/2.0f);
    
}
- (void)setTopRightView:(UIView *)aView offSet:(CGFloat)aOffSet
{
    aView.center = CGPointMake(self.right + aOffSet + aView.width/2.0f, self.top + aView.height/2.0f);
}


- (void)setBottomLeftView:(UIView *)aView offSet:(CGFloat)aOffSet
{
    aView.center = CGPointMake(self.left - aOffSet - aView.width/2.0f, self.bottom - aView.height/2.0f);
}
- (void)setBottomRightView:(UIView *)aView offSet:(CGFloat)aOffSet
{
    aView.center = CGPointMake(self.right + aOffSet + aView.width/2.0f, self.bottom - aView.height/2.0f);
}


- (void) setConstrainHeight:(CGFloat)aHeight
{
    [self.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = aHeight;
            *stop = YES;
        }
    }];
}

- (void) setConstrainWidth:(CGFloat)aWidth
{
    [self.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if (constraint.firstAttribute == NSLayoutAttributeWidth) {
            constraint.constant = aWidth;
            *stop = YES;
        }
    }];
}

- (void) setConstrainLeft:(CGFloat)aLeft
{
    [self.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        //        NSLayoutAttribute a = constraint.firstAttribute;
        if (constraint.firstAttribute == NSLayoutAttributeLeft) {
            constraint.constant = aLeft;
            *stop = YES;
        }
    }];
}

- (void) setConstrainLeading:(CGFloat)aLeading
{
    [self.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        //        NSLayoutAttribute a = constraint.firstAttribute;
        
        if (constraint.firstAttribute == NSLayoutAttributeLeading) {
            constraint.constant = aLeading;
            *stop = YES;
        }
    }];
}


+ (instancetype)loadFromNib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil].lastObject;
}

- (UIImage *)imageCreate
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)roundBorder
{
    self.layer.cornerRadius = self.frame.size.height/2.0f;
    self.layer.masksToBounds = YES;
}

@end
