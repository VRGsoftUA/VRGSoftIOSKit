//
//  AutoresizeButton.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 6/30/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct
{
    int topCapHeight;
    int leftCapHeight;
} SMImageCapSize;

static inline SMImageCapSize SMImageCapSizeMake(int leftCapHeight, int topCapHeight)
{
    SMImageCapSize imageCapSize;
    imageCapSize.leftCapHeight = leftCapHeight;
    imageCapSize.topCapHeight = topCapHeight;
    return imageCapSize;
}

static inline SMImageCapSize SMImageCapSizeNone()
{
    SMImageCapSize imageCapSize;
    imageCapSize.leftCapHeight = -1;
    imageCapSize.topCapHeight = -1;
    return imageCapSize;
}

typedef struct
{
    int leftOffset;
    int rightOffset;
} SMTitleOffset;

static inline SMTitleOffset SMTitleOffsetMake(int leftOffset, int rightOffset)
{
    SMTitleOffset titleOffset;
    titleOffset.leftOffset = leftOffset;
    titleOffset.rightOffset = rightOffset;
    return titleOffset;
}

static inline SMTitleOffset SMTitleOffsetZero()
{
    SMTitleOffset titleOffset;
    titleOffset.leftOffset = 0;
    titleOffset.rightOffset = 0;
    return titleOffset;
}

static inline SMTitleOffset SMTitleOffsetDefault()
{
    SMTitleOffset titleOffset;
    titleOffset.leftOffset = 9;
    titleOffset.rightOffset = 9;
    return titleOffset;
}

static inline SMTitleOffset SMTitleOffsetForNavBack()
{
    SMTitleOffset titleOffset;
    titleOffset.leftOffset = 15;
    titleOffset.rightOffset = 9;
    return titleOffset;
}

/// Autoresized button
@interface SMAutoresizeButton : UIButton 
{
    NSString *title;
    UIImage *originalBGImage;
    SMImageCapSize imageCapSize;
    SMTitleOffset titleOffset;
    int maxWidth;
    int minWidth;
}

@property (nonatomic, assign) int maxWidth;
@property (nonatomic, assign) int minWidth;

+ (instancetype)buttonByImageName:(NSString*)imageName;

+ (instancetype)buttonByTitleName:(NSString*)titleName
             imageName:(NSString*)imageName;

+ (instancetype)buttonByTitleName:(NSString*)titleName
             imageName:(NSString*)imageName
          imageCapSize:(SMImageCapSize)imageCapSize;

+ (instancetype)buttonByTitleName:(NSString*)titleName
             imageName:(NSString*)imageName
           titleOffset:(SMTitleOffset)titleOffset;

+ (instancetype)buttonByTitleName:(NSString*)titleName
             imageName:(NSString*)imageName
          imageCapSize:(SMImageCapSize)imageCapSize
           titleOffset:(SMTitleOffset)titleOffset;

+ (instancetype)buttonForNavBackByTitleName:(NSString*)titleName
                       imageName:(NSString*)imageName;

- (void)setupFont:(UIFont *)aFont;
- (void)setAutoresizeTitle:(NSString*)aTitle;

@end
