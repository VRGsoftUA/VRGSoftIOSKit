//
//  SMTableDisposerModeled.h
//
//
//  Created by VRGSoft on 30.03.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMTableDisposer.h"
#import "SMCellDataModeled.h"

@protocol SMTableDisposerModeledDelegate;
@protocol SMTableDisposerModeledMulticastDelegate;

@interface SMTableDisposerModeled : SMTableDisposer
{
    NSMutableDictionary <NSString *, Class> *registeredClasses;
    
    Class compoundCellDataClass;
    Class compoundModelClass;
}

@property (nonatomic, weak) id<SMTableDisposerModeledDelegate> modeledDelegate;
@property (nonatomic, readonly) SMMulticastDelegate<SMTableDisposerModeledMulticastDelegate>* modeledMulticastDelegate;

@property (nonatomic, assign) BOOL useCompoundCells;
@property (nonatomic, assign) Class compoundCellDataClass;
@property (nonatomic, assign) Class compoundModelClass;

- (void)registerCellData:(Class)aCellDataClass forModel:(Class)aModelClass;
- (void)unregisterCellDataForModel:(Class)aModelClass;

- (void)setupModels:(NSArray*)aModels forSectionAtIndex:(NSUInteger)aSectionIndex;
- (void)setupModels:(NSArray*)aModels forSection:(SMSectionReadonly*)aSection;

- (SMCellDataModeled*)cellDataFromModel:(id)aModel;

#pragma mark - Modeled multicast delegates
- (void)addModeledDelegate:(id)aDelegate delegateQueue:(dispatch_queue_t)aDelegateQueue;
- (void)removeModeledDelegate:(id)aDelegate delegateQueue:(dispatch_queue_t)aDelegateQueue;

#pragma mark -
- (void)didCreateCellData:(SMCellData*)aCellData;

@end


@protocol SMTableDisposerModeledDelegate <NSObject>

@optional
- (void)tableDisposer:(SMTableDisposerModeled*)aTableDisposer didCreateCellData:(SMCellData*)aCellData;
- (Class)tableDisposer:(SMTableDisposerModeled*)aTableDisposer cellDataClassForUnregisteredModel:(id)aModel;

@end


@protocol SMTableDisposerModeledMulticastDelegate <NSObject>

@optional
- (void)tableDisposer:(SMTableDisposerModeled*)aTableDisposer didCreateCellData:(SMCellData*)aCellData;

@end
