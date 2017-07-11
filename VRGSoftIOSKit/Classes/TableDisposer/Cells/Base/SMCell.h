//
//  SMCell.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 30.03.12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCellProtocol.h"

#define kSMCellDefaultSeparatorColor [UIColor colorWithRedI:224 greenI:224 blueI:224 alphaI:255]
#define kSMCellSeparatorHeight 1.0f

@interface SMCell : UITableViewCell <SMCellProtocol>

- (NSArray*)inputTraits;

@end
