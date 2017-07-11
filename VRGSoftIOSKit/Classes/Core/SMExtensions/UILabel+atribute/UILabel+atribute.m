//
//  UILabel+atribute.m
//  coolevents
//
//  Created by VRGSoft on 4/28/14.
//  Copyright (c) 2014 Caiguda. All rights reserved.
//

#import "UILabel+atribute.h"

@implementation UILabel (atribute)

- (NSString *)fontNameCurrentFromType:(NSString *)aType
{
    NSString *type = [NSString stringWithFormat:@"-%@",[aType lowercaseString]];
    
    UIFont *font = self.font;
    
    NSArray *fonts = [[NSArray alloc] initWithArray:
                      [UIFont fontNamesForFamilyName:
                       font.familyName]];
    
    NSString *fontName;
    for (NSString *f in fonts) {
        if([[f lowercaseString] hasSuffix:type])
        {
            fontName = f;
            break;
        }
    }
    
    if (!fontName) {
        if ([type isEqualToString:@"-regular"]) {
            for (NSString *f in fonts) {
                NSRange r = [f rangeOfString:@"-"];
                if (r.location == NSNotFound) {
                    fontName = f;
                    break;
                }
            }
        }
    }
    return fontName;
}
- (void)setAtrTypeFont:(NSString *)aType
{
    if (!self.text)
    {
        return;
    }

    NSMutableAttributedString *attributeString;
    if (self.attributedText) {
        attributeString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    }else
    {
        attributeString = [[NSMutableAttributedString alloc] initWithString:self.text];
    }
    
    
    NSString *fontName = [self fontNameCurrentFromType:aType];


    if (!fontName)
    {
        return;
    }
    
    NSRange rangeString = NSMakeRange(0, self.text.length);
    
    UIFont *willFont = [UIFont fontWithName:fontName size:self.font.pointSize];
    [attributeString addAttribute:NSFontAttributeName
                            value:willFont
                            range:rangeString];
    
    self.attributedText = [attributeString copy];
}

- (void)setTypeFont:(NSString *)aType
{
    NSString *fontName = [self fontNameCurrentFromType:aType];
    
    
    if (!fontName)
    {
        return;
    }
    
    UIFont *willFont = [UIFont fontWithName:fontName size:self.font.pointSize];
    if (!willFont)
    {
        return;
    }
    self.font = willFont;
}


- (void)setAtrTypeFontToString:(NSString *)aString type:(NSString *)aType
{
    if (!self.text)
    {
        return;
    }
    NSMutableAttributedString *attributeString;
    if (self.attributedText) {
        attributeString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    }else
    {
        attributeString = [[NSMutableAttributedString alloc] initWithString:self.text];
    }
    
    NSString *fontName = [self fontNameCurrentFromType:aType];

    NSRange rangeString = [self.text rangeOfString:aString];
    if (rangeString.location == NSNotFound) {
        return;
    }
    
    UIFont *willFont = [UIFont fontWithName:fontName size:self.font.pointSize];
    [attributeString addAttribute:NSFontAttributeName
                            value:willFont
                            range:rangeString];
    
    self.attributedText = [attributeString copy];
}

- (void)setAtrTypeFontToRange:(NSRange)aRange type:(NSString *)aType
{
    if (!self.text)
    {
        return;
    }

    NSMutableAttributedString *attributeString;
    if (self.attributedText) {
        attributeString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    }else
    {
        attributeString = [[NSMutableAttributedString alloc] initWithString:self.text];
    }
    
    NSString *fontName = [self fontNameCurrentFromType:aType];
    
    NSRange rangeString = aRange;
    if (rangeString.location == NSNotFound) {
        return;
    }
    
    UIFont *willFont = [UIFont fontWithName:fontName size:self.font.pointSize];
    [attributeString addAttribute:NSFontAttributeName
                            value:willFont
                            range:rangeString];
    
    self.attributedText = [attributeString copy];
}
- (void)setAtrColorToString:(NSString *)aString color:(UIColor *)aColor
{
    if (!self.text)
    {
        return;
    }

    NSMutableAttributedString *attributeString;
    if (self.attributedText) {
        attributeString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    }else
    {
        attributeString = [[NSMutableAttributedString alloc] initWithString:self.text];
    }
    
    NSRange rangeString = [self.text rangeOfString:aString];
    if (rangeString.location == NSNotFound) {
        return;
    }
    
    [attributeString addAttribute:NSForegroundColorAttributeName
                            value:aColor
                            range:rangeString];
    
    self.attributedText = [attributeString copy];
}

- (void)setAtrColorToRange:(NSRange )aRange color:(UIColor *)aColor
{
    if (!self.text)
    {
        return;
    }

    NSMutableAttributedString *attributeString;
    if (self.attributedText) {
        attributeString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    }else
    {
        attributeString = [[NSMutableAttributedString alloc] initWithString:self.text];
    }
    
    if (aRange.location == NSNotFound) {
        return;
    }
    
    [attributeString addAttribute:NSForegroundColorAttributeName
                            value:aColor
                            range:aRange];
    
    self.attributedText = [attributeString copy];
}

- (void)setAtrStrikethroughColorToRange:(NSRange )aRange
{
    if (!self.text)
    {
        return;
    }

    NSMutableAttributedString *attributeString;
    if (self.attributedText) {
        attributeString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    }else
    {
        attributeString = [[NSMutableAttributedString alloc] initWithString:self.text];
    }
    
    if (aRange.location == NSNotFound) {
        return;
    }
    
    [attributeString addAttribute:NSStrikethroughStyleAttributeName
                            value:@2
                            range:aRange];
    
    self.attributedText = [attributeString copy];
}


- (void)setAtrFontToString:(NSString *)aString fontName:(NSString *)aFontName size:(CGFloat)aSize
{
    if (!self.text)
    {
        return;
    }

    UIFont *font = [UIFont fontWithName:aFontName size:aSize];
    NSMutableAttributedString *attributeString;
    if (self.attributedText) {
        attributeString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    }else
    {
        attributeString = [[NSMutableAttributedString alloc] initWithString:self.text];
    }
    
    NSRange rangeString = [self.text rangeOfString:aString];
    if (rangeString.location == NSNotFound) {
        return;
    }
    
    [attributeString addAttribute:NSFontAttributeName
                            value:font
                            range:rangeString];
    
    self.attributedText = [attributeString copy];
}

- (void)setAtrFontToRange:(NSRange)aRange fontName:(NSString *)aFontName size:(CGFloat)aSize
{
    if (!self.text)
    {
        return;
    }
    
    UIFont *font = [UIFont fontWithName:aFontName size:aSize];
    NSMutableAttributedString *attributeString;
    if (self.attributedText) {
        attributeString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    }else
    {
        attributeString = [[NSMutableAttributedString alloc] initWithString:self.text];
    }
    
    if (aRange.location == NSNotFound) {
        return;
    }
    
    [attributeString addAttribute:NSFontAttributeName
                            value:font
                            range:aRange];
    
    self.attributedText = [attributeString copy];
}

- (void)setAtrFontSizeToString:(NSString *)aString size:(CGFloat)aSize
{
    NSRange rangeString = [self.text rangeOfString:aString];
    if (rangeString.location == NSNotFound)
    {
        return;
    }
    [self setAtrFontSizeToRange:rangeString size:aSize];
}
- (void)setAtrFontSizeToRange:(NSRange)aRange size:(CGFloat)aSize
{
    if (!self.text)
    {
        return;
    }
    
    UIFont *font = [UIFont fontWithName:self.font.fontName size:aSize];
    NSMutableAttributedString *attributeString;
    if (self.attributedText) {
        attributeString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    }else
    {
        attributeString = [[NSMutableAttributedString alloc] initWithString:self.text];
    }
    
    if (aRange.location == NSNotFound) {
        return;
    }
    
    [attributeString addAttribute:NSFontAttributeName
                            value:font
                            range:aRange];
    
    self.attributedText = [attributeString copy];

}

- (void)setAtrUnderLine
{
    if (!self.text)
    {
        return;
    }

    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    
    
    self.attributedText = [attributeString copy];
}

- (void)setAtrUnderLineToString:(NSString *)aString color:(UIColor *)aColor
{
    if (!self.text)
    {
        return;
    }

    NSMutableAttributedString *attributeString;
    if (self.attributedText) {
        attributeString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    }else
    {
        attributeString = [[NSMutableAttributedString alloc] initWithString:self.text];
    }
    
    NSRange rangeString = [self.text rangeOfString:aString];
    if (rangeString.location == NSNotFound) {
        return;
    }
    
    [attributeString addAttribute:NSForegroundColorAttributeName
                            value:aColor
                            range:rangeString];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:rangeString];
    self.attributedText = [attributeString copy];
}

- (void)setAtrInterval:(CGFloat)aInterval
{
    if (!self.text)
    {
        return;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    
    paragraphStyle.lineSpacing = aInterval;
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [attributeString addAttribute:NSParagraphStyleAttributeName
                            value:paragraphStyle
                            range:(NSRange){0,[attributeString length]}];
    
    NSTextAlignment textAligment = self.textAlignment;
    self.attributedText = [attributeString copy];
    self.textAlignment = textAligment;
}

- (void)setAtrParagraphInterval:(CGFloat)aInterval
{
    if (!self.text)
    {
        return;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    
    paragraphStyle.paragraphSpacing = aInterval;
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [attributeString addAttribute:NSParagraphStyleAttributeName
                            value:paragraphStyle
                            range:(NSRange){0,[attributeString length]}];
    
    NSTextAlignment textAligment = self.textAlignment;
    self.attributedText = [attributeString copy];
    self.textAlignment = textAligment;
}

    //attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
- (void)setFontSize:(CGFloat)aFontSize
{
    UIFont *font = [UIFont fontWithName:self.font.fontName size:aFontSize];
    self.font = font;
}

- (void)setFontName:(NSString *)aFontName
{
    UIFont *font = [UIFont fontWithName:aFontName size:self.font.pointSize];
    self.font = font;
}

- (void)setTextWithReplaceableImageNames:(NSString *)aText //#~test.png~#; #~test.png{{10, 15}, {20, 25}}~#
{
    self.text = aText;

    while (YES)
    {
        NSRange rAttachmentStart = [self.text rangeOfString:@"#~"];
        NSRange rAttachmentEnd = [self.text rangeOfString:@"~#"];
        
        if (rAttachmentStart.location == NSNotFound || rAttachmentEnd.location == NSNotFound)
        {
            break;
        }
    
        NSRange rFull = NSMakeRange(rAttachmentStart.location, rAttachmentEnd.location + rAttachmentEnd.length - rAttachmentStart.location);
        NSRange rSubString = NSMakeRange(rAttachmentStart.location + rAttachmentStart.length, rAttachmentEnd.location - (rAttachmentStart.location + rAttachmentStart.length));
        
        NSString *subString = [self.text substringWithRange:rSubString];
        
        
        NSRange rFrameStart = [subString rangeOfString:@"{{"];
        CGRect fImage = CGRectZero;
        NSString *imageName = subString;
        
        if (rFrameStart.location != NSNotFound)
        {
            imageName = [subString substringToIndex:rFrameStart.location];
            NSString *frameStr = [subString substringFromIndex:rFrameStart.location];
            fImage = CGRectFromString(frameStr);
        }
        
        UIImage *image = [UIImage imageNamed:imageName];
        NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        NSAttributedString *attachmentAttributedString = [NSAttributedString attributedStringWithAttachment:attachment];
        attachment.image = image;
        attachment.bounds = fImage;
        [atr replaceCharactersInRange:rFull withAttributedString:attachmentAttributedString];
        self.attributedText = atr;
    }
}

@end
