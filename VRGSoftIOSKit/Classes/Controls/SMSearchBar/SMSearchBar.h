//
//  SMSearchBar.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 7/19/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import "SMValidator.h"
#import "SMFilter.h"
#import "SMFormatter.h"

@class SMSearchBarDelegateHolder;

@interface SMSearchBar : UISearchBar <UISearchBarDelegate, SMValidationProtocol, SMFormatterProtocol>
{
    SMValidator* validator;
    SMFormatter* formatter;
    SMSearchBarDelegateHolder* delegateHolder;
}

@property (nonatomic, weak) id<UISearchBarDelegate> smdelegate;
@property (nonatomic, retain) SMFilter *filter;

@end
