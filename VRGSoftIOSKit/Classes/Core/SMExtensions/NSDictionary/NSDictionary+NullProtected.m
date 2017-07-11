//
//  NSDictionary+NullProtected.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 24.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "NSDictionary+NullProtected.h"
#import "SMKitDefines.h"

@implementation NSDictionary (NullProtected)

- (id)nullProtectedObjectForKey:(id)aKey
{
    return SM_NULL_PROTECT(self[aKey]);
}

- (id)nullProtectedObjectForKeyPath:(id)aKeyPath
{
    return SM_NULL_PROTECT([self valueForKeyPath:aKeyPath]);
}

- (NSDictionary*)dictionaryCleanedFromNulls
{
    NSSet* keySet = [self keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop)
                     {
                         return ![obj isEqual:[NSNull null]];
                     }];
    
    return [self dictionaryWithValuesForKeys:[keySet allObjects]];
}

@end


@implementation NSMutableDictionary (NilProtected)

- (void)setNilProtectedObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    self[aKey] = SM_NIL_PROTECT(anObject);
}

- (void)setObjectIfNotNil:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject)
    {
        self[aKey] = anObject;
    }
}

- (void)setStringIfNotEmpty:(NSString *)aString forKey:(id<NSCopying>)aKey
{
    if (aString.length)
    {
        self[aKey] = aString;
    }
}

@end
