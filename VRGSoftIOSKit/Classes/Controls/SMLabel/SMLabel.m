//
//  SMLabel.m
//  BRCKS
//
//  Created by VRGSoft on 5/7/15.
//  Copyright (c) 2015 brothersmedia. All rights reserved.
//

#import "SMLabel.h"
@interface SMLabel ()
{
    CGFloat topT;
    CGFloat leftT;
    CGFloat bottomT;
    CGFloat rightT;
}

@end

@implementation SMLabel
@synthesize topT;
@synthesize bottomT;
@synthesize leftT;
@synthesize rightT;

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(topT,leftT,bottomT,rightT))];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    CGRect rect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    
    rect.origin.x -= leftT;
    rect.origin.y -= topT;
    rect.size.width += (leftT + rightT);
    rect.size.height += (topT + bottomT);
    
    return rect;
}

@end
