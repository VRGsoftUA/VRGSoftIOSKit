//
//  SMTableDisposerModeled.m
//
//
//  Created by VRGSoft on 30.03.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMTableDisposerModeled.h"
#import "SMCompoundCell.h"
#import "SMCompoundModel.h"

@implementation SMTableDisposerModeled

@synthesize modeledDelegate, modeledMulticastDelegate, compoundCellDataClass, compoundModelClass;

- (instancetype)init
{
    if( (self = [super init]) )
    {
        registeredClasses = [NSMutableDictionary new];
        modeledMulticastDelegate = (SMMulticastDelegate<SMTableDisposerModeledMulticastDelegate>*)[SMMulticastDelegate new];
        compoundCellDataClass = [SMCompoundCellData class];
        compoundModelClass = [SMCompoundModel class];
    }
    return self;
}

- (void)setUseCompoundCells:(BOOL)useCompoundCells
{
    if (_useCompoundCells != useCompoundCells)
    {
        _useCompoundCells = useCompoundCells;
        if(useCompoundCells)
            [self registerCellData:self.compoundCellDataClass forModel:self.compoundModelClass];
        else
            [self unregisterCellDataForModel:self.compoundModelClass];
    }
}

- (void)setCompoundCellDataClass:(Class)aCompoundCellDataClass
{
    NSAssert([aCompoundCellDataClass isSubclassOfClass:[SMCompoundCellData class]], @"aCompoundCellDataClass is not subclass of SMCompoundCellData");
    compoundCellDataClass = aCompoundCellDataClass;
    if (self.useCompoundCells)
        [self registerCellData:compoundCellDataClass forModel:self.compoundModelClass];
}

- (void)setCompoundModelClass:(Class)aCompoundModelClass
{
    if (compoundModelClass != aCompoundModelClass)
    {
        NSAssert([aCompoundModelClass isSubclassOfClass:[SMCompoundModel class]], @"aCompoundModelClass is not subclass of SMCompoundModel");
        if (self.useCompoundCells)
        {
            [self unregisterCellDataForModel:compoundModelClass];
            [self registerCellData:self.compoundCellDataClass forModel:aCompoundModelClass];
        }
        compoundModelClass = aCompoundModelClass;
    }
}

#pragma mark - Modeled multicast delegates

- (void)addModeledDelegate:(id)aDelegate delegateQueue:(dispatch_queue_t)aDelegateQueue
{
    [modeledMulticastDelegate addDelegate:aDelegate delegateQueue:aDelegateQueue];
}

- (void)removeModeledDelegate:(id)aDelegate delegateQueue:(dispatch_queue_t)aDelegateQueue
{
    [modeledMulticastDelegate removeDelegate:aDelegate delegateQueue:aDelegateQueue];
}

- (void)registerCellData:(Class)aCellDataClass forModel:(Class)aModelClass
{
    [registeredClasses setObject:aCellDataClass forKey:NSStringFromClass(aModelClass)];
}

- (void)unregisterCellDataForModel:(Class)aModelClass
{
    [registeredClasses removeObjectForKey:NSStringFromClass(aModelClass)];
}

- (void)setupModels:(NSArray*)aModels forSectionAtIndex:(NSUInteger)aSectionIndex
{
    SMSectionReadonly* section = [self sectionByIndex:aSectionIndex];
    [self setupModels:aModels forSection:section];
}

- (void)setupModels:(NSArray*)aModels forSection:(SMSectionReadonly*)aSection
{
    NSAssert(aSection, @"aSection is nil!!!");
    
    for(id model in aModels)
    {
        SMCellDataModeled* cellData = [self cellDataFromModel:model];
        if(cellData)
        {
            [aSection addCellData:cellData];
            
            [self didCreateCellData:cellData];
        }
    }
    
}

- (SMCellDataModeled*)cellDataFromModel:(id)aModel
{
    NSString* modelClassName = NSStringFromClass([aModel class]);
    
    Class cellDataClass = [registeredClasses objectForKey:modelClassName];
    
    if(!cellDataClass && modeledDelegate && [modeledDelegate respondsToSelector:@selector(tableDisposer:cellDataClassForUnregisteredModel:)])
    {
        cellDataClass = [modeledDelegate tableDisposer:self cellDataClassForUnregisteredModel:aModel];
    }
    
    NSAssert(cellDataClass, (NSString*)([NSString stringWithFormat:@"Model doesn't have registered cellData class %@", NSStringFromClass([aModel class])]));
    NSAssert([cellDataClass isSubclassOfClass:[SMCellDataModeled class]], @"CellData must be subclass of SMCellDataModeled!");
    
    SMCellDataModeled* cellData = [[cellDataClass alloc] initWithModel:aModel];
    
    return cellData;
}

#pragma mark -

- (void)didCreateCellData:(SMCellData*)aCellData
{
    if (self.useCompoundCells)
    {
        if([aCellData isKindOfClass:[SMCompoundCellData class]])
            [(SMCompoundCellData*)aCellData setTableDisposer:self];
    }
    
    if([self.modeledDelegate respondsToSelector:@selector(tableDisposer:didCreateCellData:)])
        [self.modeledDelegate tableDisposer:self didCreateCellData:aCellData];
    
    [modeledMulticastDelegate tableDisposer:self didCreateCellData:aCellData];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    SMTableDisposerModeled* tableDisposer = (SMTableDisposerModeled*)[super copyWithZone:zone];
    tableDisposer.modeledDelegate = self.modeledDelegate;
    tableDisposer->_useCompoundCells = self.useCompoundCells;
    tableDisposer->compoundCellDataClass = self.compoundCellDataClass;
    tableDisposer->compoundModelClass = self.compoundModelClass;
    [tableDisposer->registeredClasses addEntriesFromDictionary:registeredClasses];
    
    SMMulticastDelegateEnumerator *enumerator = [self.modeledMulticastDelegate delegateEnumerator];
    id nextDelegate; dispatch_queue_t nextDispatch_queue;
    while ([enumerator getNextDelegate:&nextDelegate delegateQueue:&nextDispatch_queue])
    {
        [tableDisposer.modeledMulticastDelegate addDelegate:nextDelegate delegateQueue:nextDispatch_queue];
    }
    
    return tableDisposer;
}

@end
