//
//  SMFetcherIntoStorage.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 29.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMFetcherWithRequest.h"
#import "SMGatewayRequest.h"
#import "SMDataBaseRequest.h"
#import "SMStorage.h"

/**
 * This fetcher automaticaly save received data from server.
 * When fether start it check if interneat connection reachable. 
 * If YES - fetcher will fetch data from server. 
 * When data was fetched, fetcher will save this data into database (insert or update)
 * If NO - fetcher will fetch data from database.
 * WARNING: Setup callbackQueue before setup request.
 **/
@interface SMFetcherIntoStorage : SMFetcherWithRequest

@property (nonatomic, readonly) SMStorage* storage;

@property (nonatomic, assign) BOOL clearStorageBeforeSave;
@property (nonatomic, assign) BOOL fetchOnlyFromDataBase;
@property (nonatomic, assign) BOOL fetchFromDataBaseWhenGatewayRequestFailed;
@property (nonatomic, assign) BOOL fetchFromDataBaseWhenGatewayRequestSuccess;
@property (nonatomic, assign) BOOL fetchedModelsContainsDifferentEntities;
@property (nonatomic, assign) BOOL dontSaveIntoStorageAfterFetchFromGateway;
@property (nonatomic, strong) SMFetcherMessage* currentMessage;


- (instancetype)initWithStorage:(SMStorage*)aStorage;

- (SMGatewayRequest*)gatewayRequestByMessage:(SMFetcherMessage*)aMessage;
- (SMDataBaseRequest*)dataBaseRequestByMessage:(SMFetcherMessage*)aMessage;

/**
 * You can here change array of received models.
 **/
- (NSMutableArray*)processFetchedModelsAfterGatewayInResponse:(SMResponse *)aResponse;

- (void)willSaveIntoStorage:(NSArray*)aModels;
- (void)didSaveIntoStorage:(NSArray*)aModels;

- (NSSet*)attributesToUpdateInModel;

- (BOOL)canFetchFromDatabaseForFailedResponse:(SMResponse*)aResponse;

@end
