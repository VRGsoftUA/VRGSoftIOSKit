//
//  SMSwitch.h
//  VRGSoftIOSKit
//
//  Created by Alexander Burkhai on 11/22/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SMSwitch : UIControl

@property (nonatomic, readonly) UILabel *onLabel;
@property (nonatomic, readonly) UILabel *offLabel;

- (instancetype)initWithOrigin:(CGPoint)origin
          totalWidth:(CGFloat)totalWidth
   onBackgroundImage:(UIImage *)onBackgroundImage
  offBackgroundImage:(UIImage *)offBackgroundImage
        handlerImage:(UIImage *)handlerImage
           maskImage:(UIImage *)maskImage
         borderImage:(UIImage *)borderImage;

- (void)showInnerShadow:(BOOL)yesOrNO;
- (void)showShadowOnHandler:(BOOL)yesOrNo;

- (void)setupLabelsWithFont:(UIFont *)font
                     onText:(NSString *)onText
                    offText:(NSString *)offText
                onTextColor:(UIColor *)onTextColor
               offTextColor:(UIColor *)offTextColor;

- (BOOL)isOn;
- (void)setOn:(BOOL)on
     animated:(BOOL)animated;

- (void)setHandlerImage:(UIImage *)handlerImage;
- (void)setBorderImage:(UIImage *)borderImage;

@end
