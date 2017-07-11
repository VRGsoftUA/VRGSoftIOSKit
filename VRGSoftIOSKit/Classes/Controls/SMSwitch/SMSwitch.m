//
//  SMSwitch.m
//  VRGSoftIOSKit
//
//  Created by Alexander Burkhai on 11/22/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMSwitch.h"

#define kSMSwitchAnimationDuration 0.2

@interface SMSwitch ()
{
    UIView *_contentView;
    
    CALayer *_innerShadowLayer;
    UIImageView *_handlerImageView;
    UIImageView* _borderImageView;
    
    BOOL _isMoved;
    BOOL _isOn;
    
    float _switchOffset;
}

@end

@implementation SMSwitch

#pragma mark - Init

- (instancetype)initWithOrigin:(CGPoint)origin
          totalWidth:(CGFloat)totalWidth
   onBackgroundImage:(UIImage *)onBackgroundImage
  offBackgroundImage:(UIImage *)offBackgroundImage
        handlerImage:(UIImage *)handlerImage
           maskImage:(UIImage *)maskImage
         borderImage:(UIImage *)borderImage
{
    
    self = [super init];
    if (self)
    {
        NSAssert(onBackgroundImage, @"Nil image for parameter onBackgroundImage!!!");
        NSAssert(offBackgroundImage, @"Nil image for parameter offBackgroundImage!!!");
        NSAssert(handlerImage, @"Nil image for parameter handlerImage!!!");
        NSAssert(totalWidth > 0, @"Total width of switch is invalid!!!");
        
        _isMoved = NO;
        _isOn = YES;
        _switchOffset = 0.0;
        
        self.exclusiveTouch = YES;
        self.frame = CGRectMake(origin.x, origin.y, totalWidth, MAX(onBackgroundImage.size.height, offBackgroundImage.size.height));
        
        _contentView = [[UIView alloc] init];
        _contentView.userInteractionEnabled = NO;
        
        UIImageView *backgroundOnImageView = [[UIImageView alloc] initWithImage:onBackgroundImage];
        backgroundOnImageView.contentMode = UIViewContentModeLeft;
        UIImageView *backgroundOffImageView = [[UIImageView alloc] initWithImage:offBackgroundImage];
        backgroundOffImageView.contentMode = UIViewContentModeRight;
        _handlerImageView = [[UIImageView alloc] initWithImage:handlerImage];
        
        //width of background should be total minus half of handler width .. but height equal height of self.frame
        CGRect frame = backgroundOnImageView.frame;
        frame.size.width = (frame.size.width < totalWidth - self.frame.size.height/2) ? frame.size.width : totalWidth - handlerImage.size.width/2;
        frame.size.height = self.frame.size.height;
        backgroundOnImageView.frame = frame;
        
        frame = backgroundOffImageView.frame;
        frame.size.width = (frame.size.width < totalWidth - self.frame.size.height/2) ? frame.size.width : totalWidth - handlerImage.size.width/2;
        frame.size.height = self.frame.size.height;
        frame.origin.x = CGRectGetMaxX(backgroundOnImageView.frame);
        backgroundOffImageView.frame = frame;
        
        _contentView.frame = CGRectMake(0, 0, backgroundOnImageView.frame.size.width + backgroundOffImageView.frame.size.width, self.frame.size.height);
        
        _handlerImageView.frame = CGRectMake(ceilf(backgroundOnImageView.frame.size.width - handlerImage.size.width/2),
                                             ceilf(self.frame.size.height/2 - handlerImage.size.height/2),
                                             handlerImage.size.width, handlerImage.size.height);
        
        CALayer *maskLayer = [CALayer layer];
        if (!maskImage)
        {
            maskLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            maskLayer.backgroundColor = [UIColor blackColor].CGColor;
            maskLayer.cornerRadius = self.frame.size.height/2;
        }
        else
        {
            maskLayer.contents = (id)[maskImage CGImage];
            maskLayer.frame = CGRectMake(0, 0, maskImage.size.width, maskImage.size.height);
        }
        
        UIView* maskedView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:maskedView];
        maskedView.layer.mask = maskLayer;
        maskedView.exclusiveTouch = YES;
        
        [_contentView addSubview:backgroundOnImageView];
        [_contentView addSubview:backgroundOffImageView];
        
        [maskedView addSubview:_contentView];
        
        if (borderImage)
        {
            _borderImageView = [[UIImageView alloc] initWithImage:borderImage];
            [self addSubview:_borderImageView];
        }
        
        [self addSubview:_handlerImageView];
    }
    return self;
}

- (void)setHandlerImage:(UIImage *)handlerImage
{
    _handlerImageView.image = handlerImage;
    [self setNeedsDisplay];
}

- (void)setBorderImage:(UIImage *)borderImage
{
    _borderImageView.image = borderImage;
    [self setNeedsDisplay];
}

#pragma mark - Getter/setter for On state

- (BOOL)isOn
{
    return _isOn;
}

- (void)setOn:(BOOL)on animated:(BOOL)animated sendEvent:(BOOL)sendEvent
{
    if (animated)
    {
        [UIView animateWithDuration:kSMSwitchAnimationDuration animations:^
        {
            [self switchVisual:on];
        } completion:^(BOOL finished)
        {
            if (finished)
            {
                if(sendEvent)
                    [self switchLatent:on];
            }
        }];
    }
    else
    {
        [self switchVisual:on];
        if(sendEvent)
            [self switchLatent:on];
    }
}

- (void)setOn:(BOOL)on
     animated:(BOOL)animated
{
    [self setOn:on animated:animated sendEvent:NO];
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    
    CGPoint position = [[touches anyObject] locationInView:self];
    _switchOffset = _contentView.center.x - position.x;
}

- (void)touchesMoved:(NSSet *)touches
           withEvent:(UIEvent *)event {
    
    [super touchesMoved:touches withEvent:event];
    CGPoint position = [[touches anyObject] locationInView:self];
    
    _contentView.center = CGPointMake(position.x + _switchOffset, _contentView.center.y);
    if (_contentView.frame.origin.x > 0) {
        _contentView.frame = CGRectMake(0, _contentView.frame.origin.y, _contentView.frame.size.width, _contentView.frame.size.height);
    }
    if (_contentView.frame.origin.x < -_contentView.frame.size.width/2  + _handlerImageView.frame.size.width/2) {
        _contentView.frame = CGRectMake(-_contentView.frame.size.width/2 + _handlerImageView.frame.size.width/2, _contentView.frame.origin.y, _contentView.frame.size.width, _contentView.frame.size.height);
    }
    _handlerImageView.center = _contentView.center;
    _isMoved = YES;
}

- (void)touchesEnded:(NSSet *)touches
           withEvent:(UIEvent *)event {
    
    [super touchesEnded:touches withEvent:event];    
    CGPoint position = [[touches anyObject] locationInView:self];
    
    if ([self hitTest:position withEvent:event])
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    if (_isMoved)
    {
        if (_contentView.center.x < (_contentView.frame.size.width/2 + _handlerImageView.frame.size.width/2) / 2)
            [self setOn:NO animated:YES sendEvent:YES];
        else
            [self setOn:YES animated:YES sendEvent:YES];
    }
    else
        [self switchState];
    
    _isMoved = NO;
}

- (void)touchesCancelled:(NSSet *)touches
               withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self setOn:_isOn animated:NO sendEvent:YES];
}

#pragma mark - Switch

- (void)switchVisual:(BOOL)finalState
{
    _isOn = finalState;
    if (finalState)
        _contentView.center = CGPointMake(_contentView.frame.size.width/2, _contentView.center.y);
    else
        _contentView.center = CGPointMake(0 + _handlerImageView.frame.size.width/2, _contentView.center.y);
    
    _handlerImageView.center = _contentView.center;
}

- (void)switchLatent:(BOOL)finalState
{
//    if (_isOn != finalState) // call only when value really changed
//    {
//        _isOn = finalState;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
//    }
}

- (void)switchState
{
    if (_isOn)
    {
        [UIView animateWithDuration:kSMSwitchAnimationDuration animations:^{
            _contentView.center = CGPointMake(0 + _handlerImageView.frame.size.width/2, _contentView.center.y);
            _handlerImageView.center = _contentView.center;
        }completion:^(BOOL finished) {
            if (finished) {
                _isOn = NO;
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
        }];
    }
    else
    {
        [UIView animateWithDuration:kSMSwitchAnimationDuration animations:^{
            
            _contentView.center = CGPointMake(_contentView.frame.size.width/2, _contentView.center.y);
            _handlerImageView.center = _contentView.center;
            
        }completion:^(BOOL finished) {
            if (finished)
            {
                _isOn = YES;
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
        }];
    }
}

#pragma mark - Shadows

- (void)showInnerShadow:(BOOL)yesOrNO
{
    [_innerShadowLayer removeFromSuperlayer];
    _innerShadowLayer = nil;
    
    if (yesOrNO)
    {
        _innerShadowLayer = [CALayer layer];
        [_innerShadowLayer setCornerRadius:self.frame.size.height/2];
        [_innerShadowLayer setMasksToBounds:YES];
        [_innerShadowLayer setBorderColor:[UIColor blackColor].CGColor];
        [_innerShadowLayer setBorderWidth:1.05];
        [_innerShadowLayer setShadowColor:[UIColor blackColor].CGColor];
        [_innerShadowLayer setShadowOffset:CGSizeMake(0, 0)];
        [_innerShadowLayer setShadowOpacity:0.75];
        [_innerShadowLayer setShadowRadius:2.5];
        _innerShadowLayer.frame = CGRectMake(-1, -1, self.frame.size.width + 2, self.frame.size.height+20);
        [self.layer addSublayer:_innerShadowLayer];
    }
}

- (void)showShadowOnHandler:(BOOL)yesOrNo
{
    if (yesOrNo)
    {
        [_handlerImageView.layer setShadowOpacity:0.5];
        [_handlerImageView.layer setShadowOffset:CGSizeMake(0, 1)];
        [_handlerImageView.layer setShadowRadius:1.0];
    }
    else
    {
        [_handlerImageView.layer setShadowOpacity:0];
        [_handlerImageView.layer setShadowOffset:CGSizeMake(0, 0)];
        [_handlerImageView.layer setShadowRadius:0];
    }
}

#pragma mark - Setup labels

- (void)setupLabelsWithFont:(UIFont *)font
                     onText:(NSString *)onText
                    offText:(NSString *)offText
                onTextColor:(UIColor *)onTextColor
               offTextColor:(UIColor *)offTextColor
{
    if (!_onLabel)
    {
        _onLabel = [[UILabel alloc] init];
        _onLabel.backgroundColor = [UIColor clearColor];
        _onLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _onLabel.textAlignment = NSTextAlignmentCenter;
        [_contentView addSubview:_onLabel];
    }

    if (!_offLabel)
    {
        _offLabel = [[UILabel alloc] init];
        _offLabel.backgroundColor = [UIColor clearColor];
        _offLabel.textAlignment = NSTextAlignmentCenter;
        _offLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [_contentView addSubview:_offLabel];
    }
    
    _onLabel.text = onText;
    _onLabel.textColor = onTextColor;
    _onLabel.font = font;
    
    _offLabel.text = offText;
    _offLabel.textColor = offTextColor;
    _offLabel.font = font;
    
    _onLabel.frame = CGRectMake(2, 0, self.frame.size.width - _handlerImageView.frame.size.width - 4, self.frame.size.height);
    _offLabel.frame = CGRectMake(CGRectGetMaxX(_handlerImageView.frame) + 2, 0, _contentView.frame.size.width - CGRectGetMaxX(_handlerImageView.frame) - 4, self.frame.size.height);
}

@end
