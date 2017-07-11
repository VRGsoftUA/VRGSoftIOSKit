//
//  UILabel+atribute.h
//  coolevents
//
//  Created by VRGSoft on 4/28/14.
//  Copyright (c) 2014 Caiguda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (atribute)

- (void)setTypeFont:(NSString *)aType;

- (void)setAtrTypeFont:(NSString *)aType;
- (void)setAtrTypeFontToString:(NSString *)aString type:(NSString *)aType;
- (void)setAtrTypeFontToRange:(NSRange)aRange type:(NSString *)aType;


- (void)setAtrColorToString:(NSString *)aString color:(UIColor *)aColor;
- (void)setAtrColorToRange:(NSRange )aRange color:(UIColor *)aColor;

- (void)setAtrFontToString:(NSString *)aString fontName:(NSString *)aFontName size:(CGFloat)aSize;
- (void)setAtrFontToRange:(NSRange)aRange fontName:(NSString *)aFontName size:(CGFloat)aSize;
- (void)setAtrFontSizeToString:(NSString *)aString size:(CGFloat)aSize;
- (void)setAtrFontSizeToRange:(NSRange)aRange size:(CGFloat)aSize;

- (void)setAtrUnderLine;
- (void)setAtrParagraphInterval:(CGFloat)aInterval;

- (void)setAtrUnderLineToString:(NSString *)aString color:(UIColor *)aColor;

- (void)setAtrStrikethroughColorToRange:(NSRange )aRange;
- (void)setAtrInterval:(CGFloat)aInterval;

- (void)setFontSize:(CGFloat)aFontSize;
- (void)setFontName:(NSString *)aFontName;

- (void)setTextWithReplaceableImageNames:(NSString *)aText; //#~test.png~#; #~test.png{{10, 15}, {20, 25}}~#

@end
