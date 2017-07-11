//
//  SMSingleton.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 24.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>

#define SM_DECLARE_SINGLETON                    \
+ (instancetype)sharedInstance;

#define SM_IMPLEMENT_SINGLETON                  \
+ (instancetype)sharedInstance                  \
{                                               \
    static id sharedInstance = nil;             \
    static dispatch_once_t onceToken;           \
    dispatch_once(&onceToken, ^                 \
    {                                           \
        sharedInstance = [self new];            \
    });                                         \
    return sharedInstance;                      \
}
