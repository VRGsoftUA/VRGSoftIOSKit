//
//  SMTextViewAutosize.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 11/8/11.
//  Copyright (c) 2011 VRGSoft. all rights reserved.
//

#import "SMTextViewAutosize.h"

@implementation SMTextViewAutosize

- (void)setText:(NSString *)aText
{
    [super setText:aText];
    [self adjustSizeToContent];
}

- (void)adjustSizeToContent
{
    CGRect frame = self.frame;
    frame.size.height = self.contentSize.height;
    self.frame = frame;
}

@end
