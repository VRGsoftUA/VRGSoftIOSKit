//
//  SMExpandableInputPanel.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 18.06.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMTextView.h"
#import "SMTargetAction.h"

@protocol SMExpandableInputPanelDelegate;

@interface SMExpandableInputPanel : UIView <UITextViewDelegate, UIGestureRecognizerDelegate>
{
    CGFloat lineDiff;
    __weak UIView *overlayView;
    BOOL showOverlayView;
}

@property (nonatomic, weak) UIView* linkedView;
@property (nonatomic, weak) id<SMExpandableInputPanelDelegate> delegate;

@property (nonatomic, assign) NSUInteger maxLines;
@property (nonatomic, assign) CGFloat minHeight;

@property (nonatomic, assign) BOOL hideKeyboardOnTapOutside; // by default is YES
@property (nonatomic, assign) BOOL showOverlayView;         // by default is NO - show or not under panel dark transparent view

@property (nonatomic, strong) IBOutlet SMTextView *textView;
@property (nonatomic, strong) SMTargetAction *sendTargetAction; // default targetaction to use in subclasses for main action button


- (void)attachToOwnerView:(UIView*)anOwnerView
           withLinkedView:(UIView*)aLinkedView;
- (void)resizeOnOwnerView;
- (void)removeFromOwnerView;

- (void)insertText:(NSString*)text atCursorPositionWithWhiteSpaces:(BOOL)shouldInsertWhiteSpaces;
- (void)insertText:(NSString*)text atPosition:(NSUInteger)position withWhiteSpaces:(BOOL)shouldInsertWhiteSpaces;

- (void)clearText;

#pragma mark - Private
- (void)setup;

@end

@protocol SMExpandableInputPanelDelegate <UITextViewDelegate>

@optional
- (void)inputPanel:(SMExpandableInputPanel*)anInputPanel didChangeHeight:(float)aHeight;

@end
