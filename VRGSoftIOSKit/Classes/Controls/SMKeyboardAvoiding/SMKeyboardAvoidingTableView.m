//
//  SMKeyboardAvoidingTableView.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 1/30/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMKeyboardAvoidingTableView.h"
#import "SMKeyboardAvoiderProtocol.h"
#import "SMKitDefines.h"
#import "NSObject+BKBlockExecution.h"

#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")

@interface SMKeyboardAvoidingTableView ()
{
    BOOL setuped;
}

- (void)setup;

- (UITableViewCell*)findCellFromInputView:(UIView*)aView;
- (UIView*)findFirstResponderBeneathView:(UIView*)view;
- (UIEdgeInsets)contentInsetForKeyboard;
- (CGFloat)idealOffsetForView:(UIView *)view withSpace:(CGFloat)space;
- (CGRect)keyboardRect;

- (void)createToolbar;
- (void)deleteToolbar;

@end

@implementation SMKeyboardAvoidingTableView

@synthesize keyboardToolbar = keyboardToolbar;
@synthesize showsKeyboardToolbar;

#pragma mark - Init/Dealloc

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setup];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    if (!setuped)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        _objectsInKeyboard = [NSMutableArray new];
        _indexPathseObjectsInKeyboard = [NSMutableDictionary new];
        if (showsKeyboardToolbar)
            [self createToolbar];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - SetFrame/SetContentSize/TouchesEnded

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_keyboardVisible)
    {
        self.contentInset = [self contentInsetForKeyboard];
    }
}

-(void)setContentSize:(CGSize)contentSize
{
    [super setContentSize:contentSize];
    if (_keyboardVisible)
    {
        self.contentInset = [self contentInsetForKeyboard];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self findFirstResponderBeneathView:self] resignFirstResponder];
    [super touchesEnded:touches withEvent:event];
}

#pragma mark - NSNotification

- (void)keyboardWillShow:(NSNotification*)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIResponder <UITextInputTraits>*v in _objectsInKeyboard)
        {
            if (v.isFirstResponder)
            {
                keyboardToolbar.keyboardAppearance = [v keyboardAppearance];
            }
        }
    });

    CGRect kbRect = [[[notification userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (kbRect.size.height > _keyboardRect.size.height || !_keyboardVisible)
    {
        if (kbRect.size.height)
        {
            _keyboardRect = kbRect;
            _keyboardVisible = YES;
            
            _priorInset = self.contentInset;
            self.contentInset = [self contentInsetForKeyboard];
            
            UIView *firstResponder = [self findFirstResponderBeneathView:self];
            if ( !firstResponder )
            {
                return;
            }
            
            _inputField = firstResponder;
            _selectIndexInputField = [_objectsInKeyboard indexOfObject:_inputField];
            
            [self adjustOffset];
        }
    }
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    _keyboardRect = CGRectZero;
    _keyboardVisible = NO;
    _selectIndexInputField = 0;
    _inputField = nil;
    
    _keyboardRect = [[[notification userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^
     {
         self.contentInset = _priorInset;
     }];
    
    [self adjustOffset];
}

#pragma mark - Private Methods

- (UIView*)findFirstResponderBeneathView:(UIView*)view
{
    // Search recursively for first responder
    for ( UIView *childView in view.subviews )
    {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] )
            return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result )
            return result;
    }
    return nil;
}

- (UIEdgeInsets)contentInsetForKeyboard
{
    UIEdgeInsets newInset = self.contentInset;
    CGRect keyboardRect = [self keyboardRect];
    newInset.bottom = keyboardRect.size.height - ((keyboardRect.origin.y+keyboardRect.size.height) - (self.bounds.origin.y+self.bounds.size.height));
    
    if (newInset.bottom < 0)
    {
        newInset.bottom = 0;
    }
    return newInset;
}

-(CGFloat)idealOffsetForView:(UIView *)view withSpace:(CGFloat)space
{
    _selectIndexInputField = [_objectsInKeyboard indexOfObject:view];
    if (_selectIndexInputField != NSNotFound)
        [keyboardToolbar selectedInputFieldIndex:_selectIndexInputField allCountInputFields:[_objectsInKeyboard count]];
    
    // Convert the rect to get the view's distance from the top of the scrollView.
    CGRect rect = [view convertRect:view.bounds toView:self];
    
    // Set starting offset to that point
    CGFloat offset = rect.origin.y;
    
    if ( self.contentSize.height - offset < space )
    {
        // Scroll to the bottom
        //offset = self.contentSize.height - space;
        offset -= (floor(space-view.bounds.size.height)-20);
        
    }
    else
    {
        if ( view.bounds.size.height < space )
        {
            // Center vertically if there's room
            //offset -= floor((space-view.bounds.size.height)/2.0);
            offset -= (floor(space-view.bounds.size.height)-20);
            
        }
        if ( offset + space > self.contentSize.height )
        {
            // Clamp to content size
            offset = self.contentSize.height - space;
        }
    }
    
    if (offset < 0) offset = 0;
    
    return offset;
}

- (CGRect)keyboardRect
{
    CGRect keyboardRect = [self convertRect:_keyboardRect fromView:nil];
    if ( keyboardRect.origin.y == 0 )
    {
        CGRect screenBounds = [self convertRect:[UIScreen mainScreen].bounds fromView:nil];
        keyboardRect.origin = CGPointMake(0, screenBounds.size.height - keyboardRect.size.height);
    }
    return keyboardRect;
}

#pragma mark - Public Methods

-(void)adjustOffset
{
    // Only do this if the keyboard is already visible
    if ( !_keyboardVisible )
        return;
    
    CGFloat visibleSpace = self.bounds.size.height - self.contentInset.top - self.contentInset.bottom;
    
    CGPoint idealOffset = CGPointMake(0, [self idealOffsetForView:[self findFirstResponderBeneathView:self] withSpace:visibleSpace]);
    
    [self setContentOffset:idealOffset animated:YES];
}

- (void)hideKeyBoard
{
    BOOL result = [_inputField resignFirstResponder];
    //    BOOL result = [[self findFirstResponderBeneathView:self] resignFirstResponder];
    if (!result)
    {
        [self endEditing:YES];
    }
    SMLog(@"SMKeyboardAvoidingTableView: resignFirstResponder %d",result);
}

- (void)addObjectForKeyboard:(id<UITextInputTraits, SMKeyboardAvoiderProtocol>)objectForKeyboard
{
    if ([_objectsInKeyboard count] > 0)
    {
        [[_objectsInKeyboard lastObject] setReturnKeyType:UIReturnKeyNext];
    }
    
    [objectForKeyboard setReturnKeyType:UIReturnKeyDone];
    
    [_objectsInKeyboard addObject:objectForKeyboard];
    
    objectForKeyboard.keyboardAvoiding = self;
}

- (void)addObjectsForKeyboard:(NSArray *)objectsForKeyboard
{
    for (id obj in objectsForKeyboard)
    {
        if ([obj conformsToProtocol:@protocol(UITextInputTraits)])
        {
            if ([obj respondsToSelector:@selector(inputAccessoryView)] && keyboardToolbar)
            {
                [obj setInputAccessoryView: keyboardToolbar];
            }
            [self addObjectForKeyboard:obj];
        }
        else
        {
            NSAssert(NO, @"VRGSoftIOSKit(SMKeyboardAvoidingScrollView): object does not implement the protocol 'UITextInputTraits'");
        }
    }
}

- (void)responderShouldReturn:(UIResponder*)aResponder
{
    NSUInteger index = [_objectsInKeyboard indexOfObject:aResponder];
    NSAssert(index != NSNotFound, @"VRGSoftIOSKit: _objectsInKeyboard is empty in SMKeyboardAvoidingTableView");
    
    if (index < [_objectsInKeyboard count] - 1)
    {
        _selectIndexInputField = index + 1;
        [[_objectsInKeyboard objectAtIndex:_selectIndexInputField] becomeFirstResponder];
    }
    else
    {
        _selectIndexInputField = 0;
        [aResponder resignFirstResponder];
    }
}

#pragma mark - SMKeyboardToolbarProtocol

- (void)didDoneButtonPressd
{
    [self hideKeyBoard];
}

- (void)didNextButtonPressd
{
    if (_isAnimated)
        return;
    
    if (_selectIndexInputField < [_objectsInKeyboard count] - 1)
    {
        _selectIndexInputField ++;
        
        SMLog(@"current input field tag %@", @([_inputField tag]));
        _inputField = [_objectsInKeyboard objectAtIndex:_selectIndexInputField];
        SMLog(@"next    input field tag %@", @([_inputField tag]));
        
        if ([_inputField isKindOfClass:[UIResponder class]])
        {
            if (![_inputField becomeFirstResponder])
            {
                if (_keyboardVisible)
                {
                    //                    UIView *view = [self findCellFromInputView:(UIView*)_inputField];
                    //                    [self scrollRectToVisible:view.frame animated:YES];
                    
                    CGFloat visibleSpace = self.bounds.size.height - self.contentInset.top - self.contentInset.bottom;
                    CGPoint idealOffset = CGPointMake(0, [self idealOffsetForView:_inputField withSpace:visibleSpace]);
                    
                    [UIView animateWithDuration:0.3 animations:^
                     {
                         [self setContentOffset:idealOffset];
                         
                     } completion:^(BOOL finished)
                     {
                         //                         SMLog(@"SMKeyboardAvoidingTableView: becomeFirstResponder %d",[_inputField becomeFirstResponder]);
                     }];
                    
                    _isAnimated = YES;
                    [self bk_performBlock:^(id obj)
                     {
                         _isAnimated = NO;
                         SMLog(@"SMKeyboardAvoidingTableView: becomeFirstResponder %d",[_inputField becomeFirstResponder]);
                     } afterDelay:0.5];
                }
            }
            else
            {
                SMLog(@"SMKeyboardAvoidingTableView: becomeFirstResponder %d",[_inputField becomeFirstResponder]);
            }
        }
    }
    else
    {
        [self hideKeyBoard];
    }
}

- (void)didPrevButtonPressd
{
    if (_isAnimated)
        return;
    
    if (_selectIndexInputField >= 1)
    {
        _selectIndexInputField --;
        
        SMLog(@"current input field tag %@", @([_inputField tag]));
        _inputField = [_objectsInKeyboard objectAtIndex:_selectIndexInputField];
        SMLog(@"prev    input field tag %@", @([_inputField tag]));
        
        if ([_inputField isKindOfClass:[UIResponder class]])
        {
            if (![_inputField becomeFirstResponder])
            {
                if (_keyboardVisible)
                {
                    //                    UIView *view = [self findCellFromInputView:(UIView*)_inputField];
                    //                    [self scrollRectToVisible:view.frame animated:YES];
                    
                    CGFloat visibleSpace = self.bounds.size.height - self.contentInset.top - self.contentInset.bottom;
                    CGPoint idealOffset = CGPointMake(0, [self idealOffsetForView:_inputField withSpace:visibleSpace]);
                    
                    [UIView animateWithDuration:0.3 animations:^
                     {
                         [self setContentOffset:idealOffset];
                         
                     } completion:^(BOOL finished)
                     {
                         //                         SMLog(@"SMKeyboardAvoidingTableView: becomeFirstResponder %d",[_inputField becomeFirstResponder]);
                     }];
                    
                    _isAnimated = YES;
                    [self bk_performBlock:^(id obj)
                     {
                         _isAnimated = NO;
                         SMLog(@"SMKeyboardAvoidingTableView: becomeFirstResponder %d",[_inputField becomeFirstResponder]);
                     } afterDelay:0.4];
                }
            }
            else
            {
                SMLog(@"SMKeyboardAvoidingTableView: becomeFirstResponder %d",[_inputField becomeFirstResponder]);
            }
        }
    }
    else
    {
        [self hideKeyBoard];
    }
}

#pragma mark - Setting Toolbar

- (void)setShowsKeyboardToolbar:(BOOL)aKeyboardToolbarShow
{
    showsKeyboardToolbar = aKeyboardToolbarShow;
    if (showsKeyboardToolbar)
    {
        [self createToolbar];
    }
    else
    {
        [self deleteToolbar];
    }
}

- (void)createToolbar
{
    keyboardToolbar = [[SMKeyboardToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44.f)];
    keyboardToolbar.smdelegate = self;
    [self setInputAccessoryView:keyboardToolbar];
}

- (void)deleteToolbar
{
    keyboardToolbar = nil;
    [self setInputAccessoryView:keyboardToolbar];
}

- (void)setInputAccessoryView:(UIView*)accessoryView
{
    for (id obj in _objectsInKeyboard)
    {
        if ([obj respondsToSelector:@selector(setInputAccessoryView:)])
        {
            [obj setInputAccessoryView: keyboardToolbar];
        }
    }
}

- (void)removeAllObjectsForKeyboard
{
    [_objectsInKeyboard removeAllObjects];
    [_indexPathseObjectsInKeyboard removeAllObjects];
}

- (void)removeObjectForKeyboard:(id<UITextInputTraits, SMKeyboardAvoiderProtocol>)objectForKeyboard
{
    [_objectsInKeyboard removeObject:objectForKeyboard];
    
    if ([_objectsInKeyboard count] > 0)
    {
        [[_objectsInKeyboard lastObject] setReturnKeyType:UIReturnKeyDone];
    }
    
    NSIndexPath* deleteIndexPath  = nil;
    for (NSIndexPath* ip in [_indexPathseObjectsInKeyboard allKeys])
    {
        NSArray* inpTrs = [_indexPathseObjectsInKeyboard objectForKey:ip];
        for (id obj in inpTrs)
        {
            if (obj == objectForKeyboard)
            {
                deleteIndexPath = ip;
                break;
            }
        }
    }
    if (deleteIndexPath)
        [_indexPathseObjectsInKeyboard removeObjectForKey:deleteIndexPath];
}

- (void)removeObjectsForKeyboard:(NSArray *)objectsForKeyboard
{
    for (id obj in objectsForKeyboard)
    {
        if ([obj conformsToProtocol:@protocol(UITextInputTraits)])
            [self removeObjectForKeyboard:obj];
    }
}

- (void)sordetInputTraits:(NSArray*)inputTraits byIndexPath:(NSIndexPath*)indexPath
{
    if (!inputTraits)
        return;
    
    [_objectsInKeyboard removeAllObjects];
    
    
    if ([_indexPathseObjectsInKeyboard objectForKey:indexPath])
    {
        NSIndexPath* temp = indexPath;
        NSMutableDictionary* tempIndexPathseObjectsInKeyboard = [NSMutableDictionary dictionary];
        for (NSIndexPath* indp in [_indexPathseObjectsInKeyboard allKeys])
        {
            if ([indp isEqual:temp])
            {
                if ([indp isEqual:indexPath])
                {
                    [tempIndexPathseObjectsInKeyboard setObject:inputTraits forKey:indexPath];
                }
                temp = [NSIndexPath indexPathForRow:indp.row + 1 inSection:indp.section];
                [tempIndexPathseObjectsInKeyboard setObject:[_indexPathseObjectsInKeyboard objectForKey:indp] forKey:temp];
            }
            else
            {
                [tempIndexPathseObjectsInKeyboard setObject:[_indexPathseObjectsInKeyboard objectForKey:indp] forKey:indp];
            }
        }
        _indexPathseObjectsInKeyboard = tempIndexPathseObjectsInKeyboard;
    }
    else
    {
        [_indexPathseObjectsInKeyboard setObject:inputTraits forKey:indexPath];
    }
    
    NSArray* sordetIndexPath = [[_indexPathseObjectsInKeyboard allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    for (NSIndexPath* ip in sordetIndexPath)
    {
        NSArray* inpTrs = [_indexPathseObjectsInKeyboard objectForKey:ip];
        for (id obj in inpTrs)
        {
            [obj setReturnKeyType:UIReturnKeyNext];
            [_objectsInKeyboard addObject:obj];
        }
    }
    [[_objectsInKeyboard lastObject] setReturnKeyType:UIReturnKeyDone];
    
    if (_inputField)
    {
        _selectIndexInputField = [_objectsInKeyboard indexOfObject:_inputField];
    }
    
    SMLog(@"SMKeyboardAvoidingTableView: selected index = %i, total objects = %i", (int)_selectIndexInputField, (int)[_objectsInKeyboard count]);
}

- (UITableViewCell*)findCellFromInputView:(UIView*)aView
{
    if ([aView.superview isKindOfClass:[UITableViewCell class]])
    {
        return (UITableViewCell *)aView.superview;
    }
    else
    {
        return [self findCellFromInputView:aView.superview];
    }
}

@end













