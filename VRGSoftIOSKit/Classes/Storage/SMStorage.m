//
//  SMStorage.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 09.04.13.
//  Copyright (c) 2013 Caiguda All rights reserved.
//

#import "SMStorage.h"
#import "SMKitDefines.h"
#import "SMPair.h"
#import <objc/runtime.h>

@interface SMStorage ()

@property (nonatomic, strong, readonly) NSManagedObjectModel* managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator* persistentStoreCoordinator;

- (void)save:(BOOL)isAsync;
- (void)managedObjectContextDidSaveNotification:(NSNotification*)aNotification;
- (NSManagedObject*)updateIntoContextObjectID:(NSManagedObjectID*)anObjectID
                                    fromModel:(NSManagedObject*)aModel
                                   attributes:(NSSet*)anAttributes;

@end

@implementation SMStorage

@dynamic migrationPolicy;
@dynamic storeType;
@dynamic persistentStoreName;
@dynamic mergeModels;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize mainThreadManagedObjectContext = _mainThreadManagedObjectContext;

#pragma mark - Init/Dealloc

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        storageQueue = dispatch_queue_create(class_getName([self class]), NULL);
        queueTag = &queueTag;
        dispatch_queue_set_specific(storageQueue, queueTag, queueTag, NULL);
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if SM_NEEDS_DISPATCH_RETAIN_RELEASE
    if (storageQueue)
        dispatch_release(storageQueue);
#endif
    storageQueue = NULL;
}

#pragma mark - Configuration

- (NSString*)persistentStoreName
{
    NSAssert(NO, @"Override this!!!");
    return nil;
}

- (NSDictionary*)migrationPolicy
{
    return
    @{
        NSMigratePersistentStoresAutomaticallyOption : @(YES),
        NSInferMappingModelAutomaticallyOption : @(YES)
    };
}

- (NSString*)storeType
{
    return NSSQLiteStoreType;
//    return NSInMemoryStoreType;
}

- (BOOL)mergeModels
{
    return YES;
}

#pragma mark - CoreData preparation

- (NSManagedObjectModel*)managedObjectModel
{
    __block NSManagedObjectModel* result = nil;
    
    dispatch_block_t block = ^
    {
        if (_managedObjectModel)
        {
            result = _managedObjectModel;
        }
        else
        {
            if (![self mergeModels])
            {
                NSString* name = [self.persistentStoreName stringByReplacingOccurrencesOfString:@".sqlite" withString:@""];
                NSString* modelPath = [[NSBundle mainBundle] pathForResource:name ofType:@"momd"];
                NSURL* modelURL = [NSURL fileURLWithPath:modelPath];
                _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
            }
            else
            {
                _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:[NSBundle mainBundle]]];
            }
            
            result = _managedObjectModel;
        }
        
    };
    
    //    if (dispatch_get_current_queue() == storageQueue)
    if(dispatch_get_specific(queueTag))
        block();
    else
        dispatch_sync(storageQueue, block);
    
    return result;
}

- (NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
    __block NSPersistentStoreCoordinator* result = nil;
    
    dispatch_block_t block = ^
    {
        if (_persistentStoreCoordinator)
        {
            result = _persistentStoreCoordinator;
            return;
        }
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *directoryURL =  [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *storeUrl = [NSURL URLWithString:self.persistentStoreName relativeToURL:directoryURL];
        [storeUrl setResourceValue:@(!self.shouldCacheStorage) forKey:NSURLIsExcludedFromBackupKey error:nil];
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        NSError *error = nil;
        NSPersistentStore *store = [_persistentStoreCoordinator addPersistentStoreWithType:self.storeType
                                                                             configuration:nil
                                                                                       URL:storeUrl
                                                                                   options:self.migrationPolicy
                                                                                     error:&error];
        
        if (!store)
        {
            NSLog(@"MUStorage: Unresolved error %@", error);
# if DEBUG
            abort();
#endif
        }
        
        result = _persistentStoreCoordinator;
    };
    
//    if (dispatch_get_current_queue() == storageQueue)
    if(dispatch_get_specific(queueTag))
        block();
    else
        dispatch_sync(storageQueue, block);
    
    return result;
}

- (NSManagedObjectContext*)managedObjectContext
{
//	NSAssert(dispatch_get_current_queue() == storageQueue, @"Invoked on incorrect queue");
    // should call this method inside from storageQueue, so:
    NSAssert(dispatch_get_specific(queueTag), @"SMStorage: Invoked on incorrect queue");

    if (_managedObjectContext)
        return _managedObjectContext;

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator)
    {
        if ([NSManagedObjectContext instancesRespondToSelector:@selector(initWithConcurrencyType:)])
            _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
        else
            _managedObjectContext = [[NSManagedObjectContext alloc] init];

        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
        _managedObjectContext.mergePolicy = NSOverwriteMergePolicy;
        _managedObjectContext.undoManager = nil;
    }

    return _managedObjectContext;
}


- (NSManagedObjectContext*)mainThreadManagedObjectContext
{
	NSAssert([NSThread isMainThread], @"Invoked on incorrect queue! (Only use in main thread)");
    
    if (_mainThreadManagedObjectContext)
        return _mainThreadManagedObjectContext;
    
    NSPersistentStoreCoordinator* coordinator = [self persistentStoreCoordinator];
    if (coordinator)
    {
        if ([NSManagedObjectContext instancesRespondToSelector:@selector(initWithConcurrencyType:)])
            _mainThreadManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        else
            _mainThreadManagedObjectContext = [[NSManagedObjectContext alloc] init];
        
        [_mainThreadManagedObjectContext setPersistentStoreCoordinator: coordinator];
        _mainThreadManagedObjectContext.mergePolicy = NSOverwriteMergePolicy;
        _mainThreadManagedObjectContext.undoManager = nil;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(managedObjectContextDidSaveNotification:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:nil];
    }
    
    return _mainThreadManagedObjectContext;
}

#pragma mark - Save

- (void)save:(BOOL)isAsync
{
    dispatch_block_t block = ^
    {
        NSError* error = nil;
        if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error])
        {
            if (error)
            {
                NSLog(@"MUStorage: Unresolved error %@", error);
#if DEBUG
                abort();
#else
                [self.managedObjectContext rollback];
#endif
            }
        }
    };
    
//    if (dispatch_get_current_queue() == storageQueue)
    if(dispatch_get_specific(queueTag))
    {
        block();
    }
    else
    {
        if (isAsync)
            dispatch_async(storageQueue, block);
        else
            dispatch_sync(storageQueue, block);
    }
}

- (void)save
{
    [self save:NO];
}

- (void)scheduleSave
{
    [self save:YES];
}

- (void)managedObjectContextDidSaveNotification:(NSNotification*)aNotification
{
    NSManagedObjectContext* context = (NSManagedObjectContext*)aNotification.object;
    if(context != self.mainThreadManagedObjectContext &&
       context.persistentStoreCoordinator == self.mainThreadManagedObjectContext.persistentStoreCoordinator)
    {
        dispatch_async(storageQueue, ^
        {
            [self.mainThreadManagedObjectContext mergeChangesFromContextDidSaveNotification:aNotification];
        });
    }
}

#pragma mark - Perform blocks

- (void)executeBlock:(dispatch_block_t)aBlock
{
//	NSAssert(dispatch_get_current_queue() != storageQueue, @"Invoked on incorrect queue");
    // Should call this method outside from storageQueue
    NSAssert(!dispatch_get_specific(queueTag), @"SMStorage: Invoked on incorrect queue");
    
    dispatch_sync(storageQueue, aBlock);
}

- (void)scheduleBlock:(dispatch_block_t)aBlock
{
//	NSAssert(dispatch_get_current_queue() != storageQueue, @"Invoked on incorrect queue");
    // Should call this method outside from storageQueue
    NSAssert(!dispatch_get_specific(queueTag), @"SMStorage: Invoked on incorrect queue");

    dispatch_async(storageQueue, aBlock);
}

#pragma mark - Remove entities

- (void)removeAllEntitiesWithName:(NSString*)anEntityName
{
    SMWeakSelf;
    [self executeBlock:^
     {
         NSFetchRequest *entitiesRequest = [NSFetchRequest new];
         entitiesRequest.entity = [NSEntityDescription entityForName:anEntityName inManagedObjectContext:self.managedObjectContext];
         [entitiesRequest setIncludesPropertyValues:NO];
         NSError *error = nil;
         NSArray *entities = [self.managedObjectContext executeFetchRequest:entitiesRequest error:&error];
         if(error)
         {
             SMLog(@"STStorage: remove entities with error: %@", error);
         }
         for (NSManagedObject *object in entities)
         {
             [weakSelf.managedObjectContext deleteObject:object];
         }
     }];
}

#pragma mark - Object creation

- (NSManagedObject*)objectOfClass:(Class)aClass fromEntityName:(NSString*)anEntityName
{
    __block NSManagedObject* result = nil;
    
    [self executeBlock:^
     {
         NSEntityDescription* entity = [NSEntityDescription entityForName:anEntityName inManagedObjectContext:self.managedObjectContext];
         result = (NSManagedObject*)[[aClass alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
     }];
    
    return result;
}

- (NSManagedObject*)tempObjectOfClass:(Class)aClass fromEntityName:(NSString*)anEntityName
{
    __block NSManagedObject* result = nil;
    [self executeBlock:^
    {
        NSEntityDescription* entity = [NSEntityDescription entityForName:anEntityName inManagedObjectContext:self.managedObjectContext];
        result = [[aClass alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    }];
    
    return result;
}

#pragma mark - Insert new models

- (void)removeAllEntitiesAndInsertNewModels:(NSArray*)aModels arrayContainsDifferentEntities:(BOOL)aDifferentEntities
{
    if(aDifferentEntities)
    {
        NSMutableArray* entities = [NSMutableArray new];
        for(NSManagedObject<SMStorableObject>* model in aModels)
        {
            if(![entities containsObject:model.entity.name])
                [entities addObject:model.entity.name];
        }
        for(NSString* entityName in entities)
            [self removeAllEntitiesWithName:entityName];
        
    }
    else
    {
        NSManagedObject<SMStorableObject>* model = [aModels lastObject];
        if(model)
            [self removeAllEntitiesWithName:model.entity.name];
    }
    
    for(id<SMStorableObject> model in aModels)
        [model insertIntoContext];
}

- (void)insertModelsWithUpdate:(NSMutableArray*)aModels modelAttributesToUpdate:(NSSet*)anAttributes
{
    __block NSManagedObjectID* objectID;
    __block NSManagedObject* object;
    
    NSMutableArray* replaces = [NSMutableArray array];
    SMPair* pair;
    NSUInteger index = 0;
    
    for(id<SMStorableObject> model in aModels)
    {
        objectID = [[model class] isStorageContainedObject:(NSManagedObject *)model];
        if(objectID)
        {
            object = [self updateIntoContextObjectID:objectID fromModel:(NSManagedObject *)model attributes:anAttributes];
            if(object)
            {
                pair = [SMPair pairWithFirst:@(index) second:object];
                [replaces addObject:pair];
            }
        }
        else
            [model insertIntoContext];
        
        index++;
    }
    
    for(SMPair* pair in replaces)
    {
        [aModels replaceObjectAtIndex:[pair.first unsignedIntegerValue]
                           withObject:pair.second];
    }
}

- (void)insertModels:(NSArray*)aModels
{
    for(id<SMStorableObject> model in aModels)
    {
        [model insertIntoContext];
    }
}

- (NSManagedObject*)updateIntoContextObjectID:(NSManagedObjectID*)anObjectID
                                    fromModel:(NSManagedObject*)aModel
                                   attributes:(NSSet*)anAttributes
{
    __block NSManagedObject* object = nil;
    [self executeBlock:^
     {
         object = [self.managedObjectContext existingObjectWithID:anObjectID error:nil];
         if(object)
         {
             NSMutableSet* attributes = (anAttributes.count) ? ([anAttributes mutableCopy]) :
                                                               ([NSMutableSet setWithArray:[object.entity.attributesByName allKeys]]);
             
             if([[aModel class] respondsToSelector:@selector(notUpdatableAttributes)])
             {
                 NSSet* unupdatableAttributes = [[aModel class] notUpdatableAttributes];
                 [attributes minusSet:unupdatableAttributes];
             }

             for(NSString* attribute in attributes)
             {
                 [object setValue:[aModel valueForKey:attribute] forKey:attribute];
             }
         }
     }];
    
    return object;
}

#pragma mark - 

- (NSManagedObjectID*)isStorageContainedObject:(NSManagedObject*)anObject compareWithPredicate:(NSPredicate*)aPredicate
{
    __block NSManagedObjectID* objectID = nil;
    
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:anObject.entity.name];
    request.predicate = aPredicate;
    request.resultType = NSManagedObjectIDResultType;
    [self executeBlock:^
     {
         NSArray* models = [self.managedObjectContext executeFetchRequest:request error:nil];
         objectID = [models lastObject];
     }];
    
    return objectID;
}

- (void)clearAll
{
    SMWeakSelf
    [self scheduleBlock:^
     {
         [weakSelf clear];
     }];
}

- (void)clearAllSync
{
    SMWeakSelf
    [self executeBlock:^
     {
         [weakSelf clear];
     }];
}

- (void)clear
{
    NSArray *allEntities = self.managedObjectModel.entities;
    for (NSEntityDescription *entityDescription in allEntities)
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entityDescription];
        
        fetchRequest.includesPropertyValues = NO;
        fetchRequest.includesSubentities = NO;
        
        NSError *error;
        NSArray *items = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if (error) {
            NSLog(@"Error requesting items from Core Data: %@", [error localizedDescription]);
        }
        
        for (NSManagedObject *managedObject in items) {
            [self.managedObjectContext deleteObject:managedObject];
        }
        
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Error deleting %@ - error:%@", entityDescription, [error localizedDescription]);
        }
    }
}

@end
