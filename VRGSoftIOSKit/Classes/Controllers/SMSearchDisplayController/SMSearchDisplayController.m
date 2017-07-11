//
//  SMSearchDisplayController.m
//
//
//  Created by Alexander Burkhai on 8/21/13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMSearchDisplayController.h"
#import "SMKitDefines.h"

@implementation SMSearchDisplayController

- (instancetype)initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController *)viewController
{
    self = [super initWithSearchBar:searchBar contentsController:viewController];
    if (self)
    {
        self.shouldHideNavigationBar = YES;
    }
    return self;
}

- (void)setActive:(BOOL)visible animated:(BOOL)animated
{
    if (self.isActive == visible)
        return;
    
    if (SM_IS_IOS6)
    {
        [super setActive:visible animated:animated];
    }
    else
    {
        if (!self.shouldHideNavigationBar)
        {
            [self.searchContentsController.navigationController setNavigationBarHidden:YES animated:NO];
            [super setActive:visible animated:animated];
            [self.searchContentsController.navigationController setNavigationBarHidden:NO animated:NO];
        }
        else
            [super setActive:visible animated:animated];
        
        if (visible)
            [self.searchBar becomeFirstResponder];
        else
            [self.searchBar resignFirstResponder];
    }
}

@end
