//
//  SMFetcherIntoStorage.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 29.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMFetcherIntoStorage.h"
#import "SMStorableObject.h"
#import "SMGatewayConfigurator.h"

@interface SMFetcherIntoStorage ()


@end

@implementation SMFetcherIntoStorage

- (instancetype)initWithStorage:(SMStorage*)aStorage
{
    NSParameterAssert(aStorage);
    self = [super init];
    if(self)
    {
        _storage = aStorage;
    }
    return self;
}

#pragma mark - Request

- (void)setRequest:(SMRequest *)aRequest
{
    NSAssert(self.callbackQueue, @"SMFetcherWithRequest: callbackQueue is nil! Setup callbackQueue before setup request.");
    
    if(request == aRequest)
        return;
    
    [self cancelFetching];
    
    request = aRequest;
    
    __weak  __typeof(&*self)  __self = self;
    [request addResponseBlock:^(SMResponse *aResponse)
     {
         if([aRequest isKindOfClass:[SMGatewayRequest class]])
         {
             BOOL success = aResponse.success;
             
             if(success)
             {
                 NSMutableArray* models = [__self processFetchedModelsAfterGatewayInResponse:aResponse];
                 aResponse.boArray = models;
                 
                 if(aResponse.boArray.count)
                 {
                     if(!__self.dontSaveIntoStorageAfterFetchFromGateway)
                     {
                         if(__self.clearStorageBeforeSave)
                             [__self.storage removeAllEntitiesAndInsertNewModels:models
                                                  arrayContainsDifferentEntities:__self.fetchedModelsContainsDifferentEntities];
                         else
                             [__self.storage insertModelsWithUpdate:models modelAttributesToUpdate:[__self attributesToUpdateInModel]];
                         
                         [__self willSaveIntoStorage:models];
                         [__self.storage save];
                         [__self didSaveIntoStorage:models];
                         
                     }
                 }
                 
                 if (__self.fetchFromDataBaseWhenGatewayRequestSuccess && [__self canFetchFromDatabaseForSuccessResponse:aResponse])
                 {
                     __self.request = [__self dataBaseRequestByMessage:__self.currentMessage];
                     if (__self.request)    // if no request were created we should properly return and call fetchCallback
                         [__self.request start];
                     else
                     {
                         aResponse.boArray = [__self processFetchedModelsInResponse:aResponse];
                         
                         if (__self.fetchCallback)
                             __self.fetchCallback(aResponse);
                     }
                 } else
                 {
                     aResponse.boArray = [__self processFetchedModelsInResponse:aResponse];;
                     
                     if (__self.fetchCallback)
                         __self.fetchCallback(aResponse);
                 }
             }
             else if(__self.fetchFromDataBaseWhenGatewayRequestFailed &&
                     !aResponse.requestCancelled &&
                     [__self canFetchFromDatabaseForFailedResponse:aResponse])
             {
                 __self.request = [__self dataBaseRequestByMessage:__self.currentMessage];
                 if (__self.request)    // if no request were created we should properly return and call fetchCallback
                     [__self.request start];
                 else
                 {
                     aResponse.boArray = [__self processFetchedModelsInResponse:aResponse];
                     
                     if (__self.fetchCallback)
                         __self.fetchCallback(aResponse);
                 }
             }
             else
             {
                 aResponse.boArray = [__self processFetchedModelsInResponse:aResponse];
                 
                 if (__self.fetchCallback)
                     __self.fetchCallback(aResponse);
             }
         }
         else
         {
             aResponse.boArray = [__self processFetchedModelsInResponse:aResponse];
             
             if (__self.fetchCallback)
                 __self.fetchCallback(aResponse);
         }
         
     } responseQueue:self.callbackQueue];
}

- (SMRequest*)preparedRequestByMessage:(SMFetcherMessage*)aMessage
{
    if(self.currentMessage == aMessage)
        return preparedRequest;
    
    self.currentMessage = aMessage;
    
    SMRequest *newRequest;
    if(!self.fetchOnlyFromDataBase)
    {
        if([[SMGatewayConfigurator sharedInstance] isInternetReachable])
            newRequest = [self gatewayRequestByMessage:aMessage];
        else
            newRequest = [self dataBaseRequestByMessage:aMessage];
    }
    else
    {
        newRequest = [self dataBaseRequestByMessage:aMessage];
    }
    
    return newRequest;
}

- (SMGatewayRequest*)gatewayRequestByMessage:(SMFetcherMessage*)aMessage
{
    // override it
    return nil;
}

- (SMDataBaseRequest*)dataBaseRequestByMessage:(SMFetcherMessage*)aMessage
{
    // override it
    return nil;
}

#pragma mark - Fetch

- (void)fetchDataByMessage:(SMFetcherMessage*)aMessage
              withCallback:(SMDataFetchCallback)aFetchCallback
{
    fetchCallback = aFetchCallback;
    
    if(!preparedRequest)
        preparedRequest = [self preparedRequestByMessage:aMessage];
    
    self.request = preparedRequest;
    preparedRequest = nil;
    
    [request start];
}

- (NSMutableArray*)processFetchedModelsAfterGatewayInResponse:(SMResponse *)aResponse
{
    return aResponse.boArray;
}

- (void)willSaveIntoStorage:(NSArray*)aModels
{
    // override it if you need
}

- (void)didSaveIntoStorage:(NSArray*)aModels
{
    // override it if you need
}

- (NSSet*)attributesToUpdateInModel
{
    // override it if you need
    return nil;
}

- (BOOL)canFetchFromDatabaseForFailedResponse:(SMResponse*)aResponse
{
    return YES;
}

- (BOOL)canFetchFromDatabaseForSuccessResponse:(SMResponse*)aResponse
{
    return YES;
}

@end
