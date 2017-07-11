//
//  SMTabBar.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 7/25/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMToolbar.h"

@class SMTabedToolbar;

@protocol SMTabedToolbarDelegate <NSObject>

@optional
- (BOOL)tabedToolbar:(SMTabedToolbar*)aTabBar shouldSelectItemAtIndex:(NSUInteger)anIndex;
- (void)tabedToolbar:(SMTabedToolbar*)aTabBar itemChangedTo:(NSUInteger)aToIndex from:(NSUInteger)aFromIndex;

@end


@interface SMTabedToolbar : SMToolbar
{
    UIButton* currentItem;
    NSMutableArray* buttons;
	BOOL enabled;
}

@property (nonatomic, weak) id<SMTabedToolbarDelegate> smdelegate;
@property (nonatomic, readonly) NSArray* buttons;
@property (nonatomic, assign) BOOL enabled;

- (void)switchToItemWithIndex:(NSUInteger)aIndex;        ///< programmaticaly switch to title by index

@end
