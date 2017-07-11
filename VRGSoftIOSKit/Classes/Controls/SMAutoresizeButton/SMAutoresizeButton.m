//
//  AutoresizeButton.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 6/30/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import "SMAutoresizeButton.h"

@interface SMAutoresizeButton ()

- (void)setTitleName:(NSString*)titleName
            imageName:(NSString*)imageName
         imageCapSize:(SMImageCapSize)imageCapSize
          titleOffset:(SMTitleOffset)titleOffset;

- (void)setTitleName:(NSString*)titleName
                image:(UIImage*)image
         imageCapSize:(SMImageCapSize)imageCapSize
          titleOffset:(SMTitleOffset)titleOffset;

- (UIImage*)getAutoresizeImageByFont:(UIFont*)font;

@end

@implementation SMAutoresizeButton

@synthesize maxWidth;
@synthesize minWidth;

+ (instancetype)buttonByImageName:(NSString*)imageName
{
    SMAutoresizeButton *btn = [SMAutoresizeButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleName:nil imageName:imageName imageCapSize:SMImageCapSizeNone() titleOffset:SMTitleOffsetDefault()];
    return btn;
}

+ (instancetype)buttonByTitleName:(NSString*)titleName
             imageName:(NSString*)imageName
{
    SMAutoresizeButton *btn = [SMAutoresizeButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleName:titleName imageName:imageName imageCapSize:SMImageCapSizeNone() titleOffset:SMTitleOffsetDefault()];
    return btn;
}

+ (instancetype)buttonByTitleName:(NSString*)titleName
             imageName:(NSString*)imageName
          imageCapSize:(SMImageCapSize)imageCapSize
{
    SMAutoresizeButton *btn = [SMAutoresizeButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleName:titleName imageName:imageName imageCapSize:imageCapSize titleOffset:SMTitleOffsetDefault()];
    return btn;
}

+ (instancetype)buttonByTitleName:(NSString*)titleName
             imageName:(NSString*)imageName
           titleOffset:(SMTitleOffset)titleOffset
{
    SMAutoresizeButton *btn = [SMAutoresizeButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleName:titleName imageName:imageName imageCapSize:SMImageCapSizeNone() titleOffset:titleOffset];
    return btn;
}

+ (instancetype)buttonByTitleName:(NSString*)titleName
             imageName:(NSString*)imageName
          imageCapSize:(SMImageCapSize)imageCapSize
           titleOffset:(SMTitleOffset)titleOffset
{
    SMAutoresizeButton *btn = [SMAutoresizeButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleName:titleName imageName:imageName imageCapSize:imageCapSize titleOffset:titleOffset];
    return btn;
}

+ (instancetype)buttonForNavBackByTitleName:(NSString*)titleName
                       imageName:(NSString*)imageName
{
    SMAutoresizeButton *btn = [SMAutoresizeButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleName:titleName imageName:imageName imageCapSize:SMImageCapSizeNone() titleOffset:SMTitleOffsetForNavBack()];
    return btn;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if( (self = [super initWithCoder:aDecoder]) )
    {
        NSString* titleName = [self titleForState:UIControlStateNormal];
        UIImage* bgImage = [self backgroundImageForState:UIControlStateNormal];

        UIFont* font = self.titleLabel.font;
        [self setTitleName:titleName image:bgImage imageCapSize:SMImageCapSizeNone() titleOffset:SMTitleOffsetDefault()];
        [self setupFont:font];
    }
    return self;
}

- (void)setTitleName:(NSString *)titleName
            imageName:(NSString *)imageName 
         imageCapSize:(SMImageCapSize)anImageCapSize
          titleOffset:(SMTitleOffset)aTitleOffset
{
    [self setTitleName:titleName image:[UIImage imageNamed:imageName] imageCapSize:anImageCapSize titleOffset:aTitleOffset];
}

- (void)setTitleName:(NSString*)titleName
                image:(UIImage*)image
         imageCapSize:(SMImageCapSize)anImageCapSize
          titleOffset:(SMTitleOffset)aTitleOffset
{
    title = [titleName copy];
    originalBGImage = image;
    imageCapSize = anImageCapSize;
    titleOffset = aTitleOffset;
    maxWidth = 0;
    
    [self setupFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
}

- (void)setupFont:(UIFont *)font
{
    UIImage *image = [self getAutoresizeImageByFont:font];
    
    if (image)
        [self setBackgroundImage:image forState:UIControlStateNormal];
    
    if (title)
    {
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = font;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.shadowOffset = CGSizeMake(0,-1);
        self.titleLabel.shadowColor = [UIColor darkGrayColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
}

- (UIImage *)getAutoresizeImageByFont:(UIFont*)font
{
    UIImage *image = originalBGImage;   //[UIImage imageNamed:_imageName];
    if (!image)
        return nil;
    
    CGSize sizeButton = image.size;
    
    if (title)
    {
        CGSize sizeImage = image.size;
        //CGSize sizeTitle = [title sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, sizeButton.height)];
        CGSize sizeTitle = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, sizeButton.height)
                             options:NSStringDrawingUsesLineFragmentOrigin
                          attributes:@{NSFontAttributeName:font}
                             context:nil].size;

        if (sizeTitle.width > sizeImage.width - titleOffset.leftOffset - titleOffset.rightOffset)
        {               
            self.titleEdgeInsets = UIEdgeInsetsMake(self.titleEdgeInsets.top, 
                                                    titleOffset.leftOffset,
                                                    self.titleEdgeInsets.bottom, 
                                                    titleOffset.rightOffset);
        }
        
        if (imageCapSize.leftCapHeight >= 0 && imageCapSize.topCapHeight >= 0) 
            image = [image stretchableImageWithLeftCapWidth:imageCapSize.leftCapHeight topCapHeight:imageCapSize.topCapHeight];
        else
            image = [image stretchableImageWithLeftCapWidth:sizeImage.width/2 topCapHeight:sizeImage.height/2];
        
        float width = sizeImage.width > sizeTitle.width + titleOffset.leftOffset + titleOffset.rightOffset ? sizeImage.width : sizeTitle.width + titleOffset.leftOffset + titleOffset.rightOffset;
        sizeButton = CGSizeMake(width, image.size.height);
    }
    
    if (maxWidth > 0 && maxWidth < sizeButton.width)
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, maxWidth, sizeButton.height);
    else
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, sizeButton.width, sizeButton.height);
    return image;
}

- (void)setMaxWidth:(int)aMaxWidth
{
    if (aMaxWidth < self.frame.size.width)
    {
        maxWidth = aMaxWidth;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, maxWidth, self.frame.size.height);
    }
}

- (void)setMinWidth:(int)aMinWidth
{
    if (aMinWidth > self.frame.size.width)
    {
        minWidth = aMinWidth;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, minWidth, self.frame.size.height);
    }
}

- (void)setAutoresizeTitle:(NSString*)aTitle
{
	title = [aTitle copy];
    [self setupFont:[UIFont boldSystemFontOfSize:14]];
}

@end
