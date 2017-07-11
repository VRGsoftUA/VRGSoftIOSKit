//
//  SMHelper.h
//  Pro-Otdyh
//
//  Created by VRGSoft on 24.03.12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMExtensions.h"

inline UIViewController* SMGetPrimeViewController();

typedef BOOL (^SMDividedComparator)(id anObj1, id anObj2);
NSMutableArray* SMDivideArray(NSArray* aDividedArray, NSString* aFieldName, BOOL anAscending, SMDividedComparator aComparator);

NSDate* SMDateFromTimeStampInDictionary(NSDictionary* aDictionary, NSString* aKey);

inline NSString* SMGenerateUUID();
inline NSString* SMDocumentDirectoryPath();
inline NSString* SMCacheDirectoryPath();

inline void SMHideWebViewShadows(UIWebView* webView);

#define SMFrameFromSize(size) CGRectMake(0, 0, size.width, size.height);
