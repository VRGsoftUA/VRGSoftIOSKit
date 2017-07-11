//
//  SMStorage.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 09.04.13.
//  Copyright (c) 2013 Caiguda All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SMStorableObject.h"

@interface SMStorage : NSObject
{
    dispatch_queue_t storageQueue;
    void* queueTag;
}

/**
 * Use only in storageQueue
 **/
@property (nonatomic, strong, readonly) NSManagedObjectContext* managedObjectContext;

/**
 * Use only in main queue
 **/
@property (nonatomic, strong, readonly) NSManagedObjectContext* mainThreadManagedObjectContext;

#pragma mark - Configuration
@property (nonatomic, strong, readonly) NSString* persistentStoreName;
@property (nonatomic, assign) BOOL shouldCacheStorage;
@property (nonatomic, strong, readonly) NSDictionary* migrationPolicy;
@property (nonatomic, strong, readonly) NSString* storeType;
@property (nonatomic, assign, readonly) BOOL mergeModels;

#pragma mark - Save
- (void)save;
- (void)scheduleSave;

#pragma mark - Perform blocks
- (void)executeBlock:(dispatch_block_t)aBlock;
- (void)scheduleBlock:(dispatch_block_t)aBlock;

#pragma mark - Remove entities
- (void)removeAllEntitiesWithName:(NSString*)anEntityName;

#pragma mark - Object creation
- (NSManagedObject*)objectOfClass:(Class)aClass fromEntityName:(NSString*)anEntityName;
- (NSManagedObject*)tempObjectOfClass:(Class)aClass fromEntityName:(NSString*)anEntityName;

#pragma mark - Insert new models
/**
 * Remove all objectsd by entity.
 * After thet new objects will insert into storage.
 **/
- (void)removeAllEntitiesAndInsertNewModels:(NSArray*)aModels arrayContainsDifferentEntities:(BOOL)aDifferentEntities;
- (void)insertModelsWithUpdate:(NSMutableArray*)aModels modelAttributesToUpdate:(NSSet*)anAttributes;
- (void)insertModels:(NSArray*)aModels;

#pragma mark -
- (NSManagedObjectID*)isStorageContainedObject:(NSManagedObject*)anObject compareWithPredicate:(NSPredicate*)aPredicate;

//Clear all base asynchronously
- (void)clearAll;
- (void)clearAllSync;

@end
