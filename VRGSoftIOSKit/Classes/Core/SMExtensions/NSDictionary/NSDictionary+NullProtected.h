//
//  NSDictionary+NullProtected.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 24.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NullProtected)

- (id)nullProtectedObjectForKey:(id)aKey;
- (id)nullProtectedObjectForKeyPath:(id)aKeyPath;

- (NSDictionary*)dictionaryCleanedFromNulls;

@end


@interface NSMutableDictionary (NilProtected)

- (void)setNilProtectedObject:(id)anObject forKey:(id<NSCopying>)aKey;
- (void)setObjectIfNotNil:(id)anObject forKey:(id<NSCopying>)aKey;
- (void)setStringIfNotEmpty:(NSString *)aString forKey:(id<NSCopying>)aKey;

@end
