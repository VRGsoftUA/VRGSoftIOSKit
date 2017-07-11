//
//  SMStorableObject.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 29.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol SMStorableObject <NSObject>

+ (NSManagedObjectID*)isStorageContainedObject:(NSManagedObject*)anObject;

- (void)setupWithDictionary:(NSDictionary*)aData;

/**
 * Insert into context without immediate save into storage
 **/
- (void)insertIntoContext;

@optional

+ (NSArray*)defaultSortDescriptors;

/**
 * Determine not updatable attributes in model during update (see insertModelsWithUpdate:modelAttributesToUpdate: in SMStorable)
 **/
+ (NSSet*)notUpdatableAttributes;

@end
