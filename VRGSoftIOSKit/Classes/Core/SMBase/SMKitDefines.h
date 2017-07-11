//
//  SMKitDefines.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 9/23/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#ifndef VRGSoftIOSKit_SMKitDefines_h
#define VRGSoftIOSKit_SMKitDefines_h

#define SM_NULL_PROTECT(value) ( ((NSNull*)value == [NSNull null]) ? (nil) : (value) )
#define SM_NIL_PROTECT(value) ( (value == nil) ? ([NSNull null]) : (value) )

#define SM_IS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define SM_CHECK_INDEX(index, min, max) {NSAssert( index >= min && index < max, @"Wrong index!");}

#define SM_IS_RETINA ([UIScreen mainScreen].scale > 1.5f)
#define SM_ONE_PIXEL (1.0f/[UIScreen mainScreen].scale)

#define SMWeakSelf __weak __typeof(&*self)weakSelf = self;
#define SMStrongSelf __strong __typeof(&*weakSelf)strongSelf = weakSelf;
#define SMWeak(__t__) __weak typeof(__t__) weak##__t__ = __t__
#define SM_SCREEN_SCALE [UIScreen mainScreen].scale


#define NSLocalizedFormatString(fmt, ...) [NSString stringWithFormat:NSLocalizedString(fmt, nil), __VA_ARGS__]
#define SMDeallocLog NSLog(@"DEALLOC - %@",NSStringFromClass([self class]));

/**
 * Log
 **/

#ifdef DEBUG
#   define SMLog(format, ...) NSLog(format, __VA_ARGS__)
#else
#   define SMLog(format, ...)
#endif

#define SM_IS_IPHONE_FOUR_INCH ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && \
                                MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width) == 568.0)

#define SM_IS_IOS6 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define SM_IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define SM_IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define SM_IS_IOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define SM_IS_IOS10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)

/**
 * Dispatch retain/release
 **/

#define SM_NEEDS_DISPATCH_RETAIN_RELEASE !OS_OBJECT_USE_OBJC

/**
 * Autoresizing masks
 **/

#define SMViewAutoresizingFlexibleSize      UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth
#define SMViewAutoresizingFlexibleMargin    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin
#define SMViewAutoresizingAll SMViewAutoresizingFlexibleSize | SMViewAutoresizingFlexibleMargin

/*
 *  System Versioning Preprocessor Macros
 */

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#endif
