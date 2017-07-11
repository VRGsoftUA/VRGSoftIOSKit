//
//  SMPagingMoreCellProtocol.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 20.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SMPagingMoreCellProtocol <NSObject>

- (void)didBeginDataLoading;
- (void)didEndDataLoading;

@end

@protocol SMPagingMoreCellDataProtocol <NSObject>

@optional
- (void)addTarget:(id)aTarget action:(SEL)anAction;

@end
