//
//  SMCellDataTextPair.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 04.04.12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMCellDataMaped.h"

@interface SMCellDataTextPair : SMCellDataMaped

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;

@end
