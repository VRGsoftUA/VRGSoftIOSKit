//
//  SMLabelCellData.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 3/30/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMCellDataMaped.h"

@interface SMCellDataStandart : SMCellDataMaped

@property (nonatomic, retain) UIImage* image;                                   ///< Use to setup image

@property (nonatomic, retain) NSURL* imageURL;                                  ///< Use to setup image asynchronous from URL
@property (nonatomic, retain) UIImage* imagePlaceholder;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, assign) NSTextAlignment titleTextAlignment;

@property (nonatomic, retain) NSString* subtitle;
@property (nonatomic, retain) UIColor *subtitleColor;
@property (nonatomic, strong) UIFont *subtitleFont;

- (instancetype)initWithObject:(NSObject *)aObject key:(NSString *)aKey;

@end
