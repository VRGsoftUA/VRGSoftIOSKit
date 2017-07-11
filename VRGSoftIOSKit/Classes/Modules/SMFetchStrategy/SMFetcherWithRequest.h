//
//  SMFetcherWithRequest.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 16.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMDataFetcher.h"
#import "SMRequest.h"
#import "SMFetcherMessage.h"

/**
 * This is strategy that determine fetch data with request.
 * Request can be SMGatewayRequest or SMDataBaseRequest.
 * WARNING: Setup callbackQueue before setup request.
 **/
@interface SMFetcherWithRequest : NSObject <SMDataFetcher>
{
    SMRequest* preparedRequest;
    SMRequest* request;
    
    SMDataFetchCallback fetchCallback;
}

@property (nonatomic, strong) SMRequest* request;
@property (nonatomic, readonly) SMDataFetchCallback fetchCallback;

- (SMRequest*)preparedRequestByMessage:(SMFetcherMessage*)aMessage;
- (NSMutableArray*)processFetchedModelsInResponse:(SMResponse *)aResponse;

@end
