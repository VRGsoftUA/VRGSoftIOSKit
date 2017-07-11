//
//  SMSearchDisplayController.h
//
//
//  Created by Alexander Burkhai on 8/21/13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSearchDisplayController : UISearchDisplayController

/* Note. This property implemented only for iOS 5.x and (deprecated for above versions)
 * by default is YES. Automatically hides navigation bar according to default behavior
 */
@property (nonatomic, assign) BOOL shouldHideNavigationBar;

@end
