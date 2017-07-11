//
//  SMCellTextView.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 04.04.12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMCell.h"
#import "SMTextView.h"


@interface SMCellTextView : SMCell
{
    UILabel* titleLabel;
}

@property (nonatomic, readonly) SMTextView* textView;

@end
