//
//  SMDataBaseRequest.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 16.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMDataBaseRequest.h"

@interface SMDataBaseRequest ()

- (SMResponse*)executeRequest:(NSFetchRequest*)aRequest
                    inContext:(NSManagedObjectContext*)aContext;

@end

@implementation SMDataBaseRequest

- (instancetype)initWithStorage:(SMStorage*)aStorage
{
    self = [super init];
    if(self)
    {
        storage = aStorage;
    }
    return self;
}

#pragma mark - Request execute

- (BOOL)canExecute
{
    return storage && self.fetchRequest;
}

- (void)start
{
    cancelled = NO;
    executing = YES;
    __weak SMDataBaseRequest *weakself = self;
    
    [storage scheduleBlock:^
    {
        SMDataBaseRequest *strongself = weakself;
        if (strongself)
        {
            SMResponse* response = nil;
            if(strongself->cancelled)
            {
                strongself->executing = NO;
                
                response = [SMResponse new];
                response.requestCancelled = YES;
                response.success = NO;
                [strongself executeAllResponseBlocksWithResponse:response];
                return;
            }
            
            response = [strongself executeRequest:strongself.fetchRequest inContext:strongself->storage.managedObjectContext];
            
            strongself->executing = NO;
            if(weakself.executeAllResponseBlocksSync)
                [strongself executeSynchronouslyAllResponseBlocksWithResponse:response];
            else
                [strongself executeAllResponseBlocksWithResponse:response];
        }
    }];
}

- (void)execute
{
    cancelled = NO;
    executing = YES;
    __weak SMDataBaseRequest *weakself = self;
    __block SMResponse* response;
    
    [storage executeBlock:^
    {
        SMDataBaseRequest *strongself = weakself;
        if (strongself)
            response = [strongself executeRequest:strongself.fetchRequest inContext:strongself->storage.managedObjectContext];
    }];
        
    executing = NO;
    [self executeSynchronouslyAllResponseBlocksWithResponse:response];
}

#pragma mark -

- (SMResponse*)executeRequest:(NSFetchRequest*)aRequest inContext:(NSManagedObjectContext*)aContext
{
    NSError* error = nil;
    NSArray* results = [aContext executeFetchRequest:aRequest error:&error];
    
    SMResponse* response = [SMResponse new];
    if([results count])
        [response.boArray addObjectsFromArray:results];
    
    response.error = error;
    response.code = error.code;
    response.requestCancelled = [self isCancelled];
    response.success = !response.error && !response.requestCancelled;

    return response;
}

- (void)cancel
{
    cancelled = YES;
}

- (BOOL)isExecuting
{
    return executing;
}

- (BOOL)isCancelled
{
    return cancelled;
}

@end
