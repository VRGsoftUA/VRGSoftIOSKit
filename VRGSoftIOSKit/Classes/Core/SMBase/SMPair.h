//
//  SMPair.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 10/13/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMPair : NSObject

@property (nonatomic, strong) id first;
@property (nonatomic, strong) id second;

+ (instancetype)pairWithFirst:(id)aFirst second:(id)aSecond;
- (instancetype)initWithFirst:(id)aFirst second:(id)aSecond;

@end


@interface NSArray (SMPair)

- (SMPair*)pairByFirst:(id)aFirst;
- (SMPair*)pairBySecond:(id)aSecond;

@end
