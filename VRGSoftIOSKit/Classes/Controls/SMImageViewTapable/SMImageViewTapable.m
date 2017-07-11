//
//  SMImageViewTapable.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 3/14/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMImageViewTapable.h"
//#import "UIImageView+AFNetworking.h"

@interface SMImageViewTapable ()

- (void)initialize;
- (void)handleTap:(UITapGestureRecognizer*)aTapRecognizer;

@end


@implementation SMImageViewTapable

@synthesize enable;
@synthesize data;

- (instancetype)init
{
    if( (self = [super init]) )
    {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if( (self = [super initWithCoder:aDecoder]) )
    {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if(self)
    {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    self = [super initWithImage:image highlightedImage:highlightedImage];
    if(self)
    {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    enable = YES;
    targetActions = [NSMutableArray new];
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapRecognizer];
}

- (void)addTarget:(id)aTarget action:(SEL)anAction
{
    SMTargetAction* ta = [[SMTargetAction alloc] initWithTarget:aTarget action:anAction];
    [targetActions addObject:ta];
}

- (void)handleTap:(UITapGestureRecognizer*)aTapRecognizer
{
    if(!enable)
        return;
    
    if(aTapRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [targetActions makeObjectsPerformSelector:@selector(sendActionFrom:) withObject:self];
    }
}

@end
