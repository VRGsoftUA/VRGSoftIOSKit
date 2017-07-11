//
//  SMSegmentedControl.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 7/13/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>


@interface SMSegmentedControl : UIControl
{
    UIImageView* bgImageView;
    NSMutableArray* buttons;
    UIButton* currentItem;
}

@property (nonatomic, readonly) UIImageView* backgroundImageView;
@property (nonatomic, readonly) NSUInteger currentIndex;

- (void)setBackgroundImage:(UIImage*)aBackgroundImage;
- (void)addButton:(UIButton*)aButton;
- (void)switchToItemWithIndex:(NSUInteger)aIndex;                              ///< programmaticaly switch to title by index

@end
