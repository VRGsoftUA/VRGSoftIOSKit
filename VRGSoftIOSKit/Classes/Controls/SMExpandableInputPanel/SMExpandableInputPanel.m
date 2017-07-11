//
//  SMExpandableInputPanel.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 18.06.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMExpandableInputPanel.h"
#import "SMKitDefines.h"

@interface SMExpandableInputPanel ()
{
    BOOL setuped;
    __weak UITapGestureRecognizer *tapRecognizer;
    CGFloat maxHeight;
    BOOL isNeedScrollToBottom;
}

- (void)keyboardWillShow:(NSNotification*)aNotification;
- (void)keyboardWillHide:(NSNotification*)aNotification;

- (void)resizeViewWithOptions:(NSDictionary*)anOptions keyBoardShowing:(BOOL)aShowing;
- (void)resizeLinkedView;

- (void)handleTapGesture:(UIGestureRecognizer*)gestureRecognizer;

@end

@implementation SMExpandableInputPanel

#pragma mark - Init/Dealloc

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        if(!setuped)
        {
            [self setup];
            setuped = YES;
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if(!setuped)
        {
            [self setup];
            setuped = YES;
        }
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        if(!setuped)
        {
            [self setup];
            setuped = YES;
        }
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Setup

- (void)setup
{
    self.maxLines = 5;
    self.minHeight = 44;
    _hideKeyboardOnTapOutside = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self layoutIfNeeded];

    lineDiff = self.textView.contentSize.height - self.textView.font.lineHeight;
    self.textView.smdelegate = self;
    self.minHeight = self.textView.frame.size.height;
    
    [self calculateMaxHeight];
}

- (void)setMaxLines:(NSUInteger)maxLines
{
    _maxLines = maxLines;
    
    [self calculateMaxHeight];
}

- (void)calculateMaxHeight
{
    NSString *tmpText = @"";
    for (int i = 0; i < self.maxLines; i++)
        tmpText = [tmpText stringByAppendingString:@"\n"];
    self.textView.text = tmpText;
    CGSize tmpSize = [self.textView sizeThatFits:CGSizeMake(320, FLT_MAX)];
    maxHeight = tmpSize.height;
    self.textView.text = @"";
}

#pragma mark - Attach/remove

- (void)attachToOwnerView:(UIView*)anOwnerView withLinkedView:(UIView*)aLinkedView
{
    NSParameterAssert(anOwnerView);
    
    if(self.superview == anOwnerView)
        return;
    
    self.linkedView = aLinkedView;
    [anOwnerView addSubview:self];
    [self resizeOnOwnerView];
    
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    recognizer.delegate = self;
    recognizer.enabled = self.hideKeyboardOnTapOutside;
    recognizer.cancelsTouchesInView = NO;
    tapRecognizer = recognizer;
    
    if (!self.showOverlayView)
        [anOwnerView addGestureRecognizer:tapRecognizer];
}

- (void)resizeOnOwnerView
{
    CGRect frame = self.frame;
    frame.origin.x = 0;
    frame.origin.y = self.superview.frame.size.height - frame.size.height;
    self.frame = frame;
    
    [self resizeLinkedView];
}

- (void)removeFromOwnerView
{
    if (self.superview)
    {
        if (overlayView) // remove overlay view from old ownerview
        {
            [overlayView removeFromSuperview];
            overlayView = nil;
        }
        [self.superview removeGestureRecognizer:tapRecognizer];
        tapRecognizer = nil;
    }
    self.linkedView = nil;
    [self removeFromSuperview];
}

#pragma mark -

- (void)setHideKeyboardOnTapOutside:(BOOL)hideKeyboardOnTapOutside
{
    if (_hideKeyboardOnTapOutside != hideKeyboardOnTapOutside)
    {
        _hideKeyboardOnTapOutside = hideKeyboardOnTapOutside;
        tapRecognizer.enabled = hideKeyboardOnTapOutside;
    }
}

- (BOOL)showOverlayView
{
    if (showOverlayView && !overlayView)
    {
        if (self.superview)
        {
            UIView *view = [[UIView alloc] initWithFrame:self.superview.bounds];
            view.backgroundColor = [UIColor blackColor];
            view.alpha = 0.0;
            view.autoresizingMask = SMViewAutoresizingFlexibleSize;
            if (tapRecognizer)
            {
                tapRecognizer.enabled = NO;
                [view addGestureRecognizer:tapRecognizer];
                [self.superview removeGestureRecognizer:tapRecognizer];
                tapRecognizer.enabled = self.hideKeyboardOnTapOutside;
            }
            [self.superview insertSubview:view belowSubview:self];
            overlayView = view;
        }
    }
    return showOverlayView;
}

- (void)setShowOverlayView:(BOOL)aShowOverlayView
{
    showOverlayView = aShowOverlayView;
    if (!showOverlayView && overlayView)
    {
        overlayView.alpha = 0.0f;
        [overlayView removeFromSuperview];
        overlayView = nil;
    }
}


#pragma mark - Insert

- (void)insertText:(NSString *)text atCursorPositionWithWhiteSpaces:(BOOL)shouldInsertWhiteSpaces
{
    NSRange range = self.textView.selectedRange;
    NSUInteger position = range.location != NSNotFound ? range.location : self.textView.text.length;
    [self insertText:text atPosition:position withWhiteSpaces:shouldInsertWhiteSpaces];
}

- (void)insertText:(NSString *)text atPosition:(NSUInteger)position withWhiteSpaces:(BOOL)shouldInsertWhiteSpaces
{
    if (position != NSNotFound && [text length])
    {
        NSString *firstHalfString = [self.textView.text substringToIndex:position];
        NSString *secondHalfString = [self.textView.text substringFromIndex:position];
        
        BOOL scrollEnabled = self.textView.scrollEnabled;
        self.textView.scrollEnabled = NO;
        
        NSMutableString *insertString = [NSMutableString stringWithString:text];
        if (shouldInsertWhiteSpaces)
        {
            if ([firstHalfString length] && [firstHalfString characterAtIndex:firstHalfString.length - 1] != ' ')
                [insertString insertString:@" " atIndex:0];
            
            if ([secondHalfString length] && [secondHalfString characterAtIndex:0] != ' ')
                [insertString appendString:@" "];
        }
        
        NSRange selectedRange = self.textView.selectedRange;
        if ((position == selectedRange.location && selectedRange.length == 0) || NSLocationInRange(position, selectedRange))
        {
            if (position == selectedRange.location) // position is at the start of selectedRange
                selectedRange.location += [insertString length];
            else
                selectedRange.length += [insertString length];
        }
        
        self.textView.text = [NSString stringWithFormat:@"%@%@%@", firstHalfString, insertString, secondHalfString];
        self.textView.selectedRange = selectedRange;
        [self.textView setContentOffset:self.textView.contentOffset animated:NO]; // magic to correctly setup contentoffset after inserting
        
        self.textView.scrollEnabled = scrollEnabled;
        [self textViewDidChange:self.textView];
        [self scrollToBottom];
    }
}

- (CGRect)frameOfTextRange:(NSRange)range inTextView:(UITextView *)textView
{
    UITextPosition *beginning = textView.beginningOfDocument;
    UITextPosition *start = [textView positionFromPosition:beginning offset:range.location];
    UITextPosition *end = [textView positionFromPosition:start offset:range.length];
    UITextRange *textRange = [textView textRangeFromPosition:start toPosition:end];
    CGRect rect = [textView firstRectForRange:textRange];
    return [textView convertRect:rect fromView:textView.textInputView];
}

- (void)clearText
{
    self.textView.text = nil;
    [self textViewDidChange:self.textView];
}

- (void)scrollToBottom
{
    isNeedScrollToBottom = NO;
    CGPoint bottomOffset = CGPointMake(0, self.textView.contentSize.height - self.textView.bounds.size.height);
    [self.textView setContentOffset:bottomOffset animated:YES];
}


#pragma mark - UITextView Delegate

- (void)textViewDidChange:(UITextView *)aTextView
{
    if(self.textView != aTextView)
        return;
    
    CGFloat previousHeight = self.textView.bounds.size.height;
    CGSize textViewSize = self.textView.contentSize;//[self.textView sizeThatFits:CGSizeMake(self.textView.frame.size.width, FLT_MAX)];
    CGFloat newSizeH = textViewSize.height;
    
    if (newSizeH < self.minHeight*1.3 || !self.textView.hasText)
        newSizeH = self.minHeight;
    
    NSInteger numLines = (newSizeH - lineDiff) / self.textView.font.lineHeight;
    
    if (numLines > self.maxLines)
    {
        newSizeH = maxHeight;
        if (self.textView.scrollEnabled == NO)
        {
            [self.textView setScrollEnabled:YES];
            [self.textView flashScrollIndicators];
        }
    }
    
    
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)])
        [self.delegate textViewDidChange:aTextView];
    
    if (previousHeight != newSizeH)
    {
        float dh = newSizeH - previousHeight;
        
        CGRect frame = self.frame;
        frame.size.height += dh;
        frame.origin.y -= dh;
        self.frame = frame;
        
        [self resizeLinkedView];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.textView setContentOffset:CGPointZero animated:NO];
        });
        
        if ([self.delegate respondsToSelector:@selector(inputPanel:didChangeHeight:)])
            [self.delegate inputPanel:self didChangeHeight:self.frame.size.height];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        isNeedScrollToBottom = YES;
    }
    return YES;
}

#pragma mark - Keyboard Notifications

- (void)keyboardWillShow:(NSNotification*)aNotification
{
    if([self.textView isFirstResponder])
    {
        [self.textView becomeFirstResponder];
    }
    
    [self resizeViewWithOptions:aNotification.userInfo keyBoardShowing:YES];
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    if([self.textView isFirstResponder])
    {
        [self.textView resignFirstResponder];
    }
    
    [self resizeViewWithOptions:aNotification.userInfo keyBoardShowing:NO];
}

- (void)resizeViewWithOptions:(NSDictionary *)anOptions keyBoardShowing:(BOOL)aShowing
{
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[anOptions objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[anOptions objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[anOptions objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    BOOL shouldShowOverlayView = self.showOverlayView;
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0f
                        options:(animationCurve | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^
     {
         CGFloat viewHeight = [self.superview convertRect:keyboardEndFrame fromView:nil].origin.y;
         CGRect viewFrame = self.frame;
         if (aShowing)
         {
             viewFrame.origin.y = viewHeight - self.frame.size.height;
             if (shouldShowOverlayView)
                 overlayView.alpha = 0.5;
         }
         else
         {
             viewFrame.origin.y = self.superview.frame.size.height - viewFrame.size.height;
             if (shouldShowOverlayView)
                 overlayView.alpha = 0.0;
         }
         self.frame = viewFrame;
         [self resizeLinkedView];
         
     } completion:nil];
}

- (void)resizeLinkedView
{
    if(!self.linkedView)
        return;
    
    CGRect linkedViewFrame = self.linkedView.frame;
    linkedViewFrame.size.height = self.frame.origin.y;
    self.linkedView.frame = linkedViewFrame;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return !(touch.view == self || touch.view.superview == self || [touch.view isKindOfClass:[UIControl class]] ||
             (self.showOverlayView && ([touch.view isKindOfClass:[UITableViewCell class]] || [touch.view.superview isKindOfClass:[UITableViewCell class]])));
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handleTapGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == tapRecognizer && self.hideKeyboardOnTapOutside)
    {
        [self.textView resignFirstResponder];
    }
}

@end
