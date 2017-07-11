//
//  SMTabBar.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 7/25/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import "SMToolbar.h"

@interface SMToolbar()

- (void)setup;

@end

@implementation SMToolbar

#pragma mark - Init/Dealloc

- (instancetype)init
{
    self = [super init];
    if(self)
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
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self setup];
    }
    return self;
}

#pragma mark - Setup

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.drawsColor = NO;
}

- (void)drawRect:(CGRect)aRect
{
    if(self.backgroundImage)
    {
        [self.backgroundImage drawInRect:self.bounds blendMode:kCGBlendModeNormal alpha:1.0f];
    }
    else if(self.drawsColor)
    {
        CGContextRef context = UIGraphicsGetCurrentContext(); 
        CGColorRef colorRef = self.backgroundColor.CGColor;
        const CGFloat* components = CGColorGetComponents(colorRef);
        CGContextSetRGBFillColor(context, components[0], components[1], components[2], components[3]);
        CGContextFillRect(context, self.bounds);
    }
    else
        [super drawRect:aRect];
}

@end
