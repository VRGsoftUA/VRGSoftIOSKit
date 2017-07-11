//
//  SMPopupPicker.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 9/23/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import "SMPopupView.h"
#import "SMToolbar.h"

#define SM_POPUPVIEW_TOOLBAR_ITEM_DID_PRESSED      @"SMPopupViewToolbarItemDidPressed"
#define SM_POPUPVIEW_TOOLBAR_ITEM_PRESSED_INDEX    @"SMPopupViewToolbarItemPressedIndex"

@class SMPopupPicker;
typedef void (^SMPickeSelectHendlerBlock)(SMPopupPicker *aPicker, id aSelectedItem);

@interface SMPopupPicker : SMPopupView
{
    SMToolbar* toolbar;
    UIView* picker;
    
    id selectedItem;
    
    SMPickeSelectHendlerBlock selectHandler;
}

@property (nonatomic, retain) SMToolbar* toolbar;
@property (nonatomic, retain) id selectedItem;

@property (nonatomic, copy) SMPickeSelectHendlerBlock selectHandler;

- (UIView*)createPicker;

@end
