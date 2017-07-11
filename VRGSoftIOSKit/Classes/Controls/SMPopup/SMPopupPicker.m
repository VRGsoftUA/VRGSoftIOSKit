//
//  SMPopupPicker.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 9/23/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import "SMPopupPicker.h"

@interface SMPopupPicker ()

- (void)toolbarButtonPressed:(UIButton*)aSender;
- (void)toolbarItemPressed:(UIBarButtonItem*)aSender;
- (void)configureFrames;

@end

@implementation SMPopupPicker

@synthesize toolbar;
@synthesize selectedItem;
@synthesize selectHandler;

- (void)dealloc
{
    if ([picker isKindOfClass:[UIPickerView class]])
    {
        ((UIPickerView*)picker).delegate = nil;
        ((UIPickerView*)picker).dataSource = nil;
    }
}

// Create, configure and return popupedView
- (void)setup
{
    [super setup];
    
    self.frame = CGRectMake(0, 0, 320, 216);
    
    self.backgroundColor = [UIColor clearColor];
    picker = [self createPicker];
    [self addSubview:picker];
    
    [self configureFrames];
}

- (void)configureFrames
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    picker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    
    CGRect frame = picker.frame;
    frame.origin.y = toolbar.bounds.size.height;
    picker.frame = frame;
    
    frame.origin.y = 0;
    frame.size.height += toolbar.bounds.size.height;
    self.frame = frame;
    
    picker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)setToolbar:(SMToolbar *)aToolbar
{
    if(toolbar == aToolbar)
        return;
    
    if(aToolbar)
    {
        toolbar = aToolbar;
        [self addSubview:toolbar];
        [toolbar sizeToFit];
        toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [self configureFrames];
        
        int index = 0;
        for(UIBarButtonItem* bbi in toolbar.items)
        {
            if(bbi.customView && [bbi.customView isKindOfClass:[UIButton class]])
            {
                bbi.customView.tag = index;
                [((UIButton*)bbi.customView) addTarget:self action:@selector(toolbarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                bbi.tag = index;
                [bbi setTarget:self];
                [bbi setAction:@selector(toolbarItemPressed:)];
            }
            
            ++index;
        }
    }
    else
    {
        [toolbar removeFromSuperview];
        toolbar = nil;
    }
}

- (UIView*)createPicker
{
    // override it in subclasses
    return nil;
}

- (id)selectedItem
{
    // override it in subclasses
    return nil;
}

#pragma mark - Toolbar

- (void)toolbarButtonPressed:(UIButton*)aSender
{
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:@(aSender.tag) forKey:SM_POPUPVIEW_TOOLBAR_ITEM_PRESSED_INDEX];
    [[NSNotificationCenter defaultCenter] postNotificationName:SM_POPUPVIEW_TOOLBAR_ITEM_DID_PRESSED object:self userInfo:userInfo];
}

- (void)toolbarItemPressed:(UIBarButtonItem*)aSender
{
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:@(aSender.tag) forKey:SM_POPUPVIEW_TOOLBAR_ITEM_PRESSED_INDEX];
    [[NSNotificationCenter defaultCenter] postNotificationName:SM_POPUPVIEW_TOOLBAR_ITEM_DID_PRESSED object:self userInfo:userInfo];
}

@end
