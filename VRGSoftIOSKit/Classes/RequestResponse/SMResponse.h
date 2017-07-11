//
//  SMResponse.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 15.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMResponse : NSObject

@property (nonatomic, assign) BOOL success;

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString *textMessage;
@property (nonatomic, strong) NSString *textTitle;

@property (nonatomic, readonly) NSMutableDictionary* dataDictionary;
@property (nonatomic, strong) NSMutableArray* boArray;

@property (nonatomic, strong) NSError *error;
@property (nonatomic, assign, getter = isRequestCancelled) BOOL requestCancelled;

@end
