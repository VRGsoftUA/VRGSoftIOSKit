//
//  SMDownloaderTaskRequested.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 24.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMDownloaderTask.h"
#import "SMGatewayRequest.h"

/**
 * DAL
 * Downloasd task with request
 **/
@interface SMDownloaderTaskRequested : SMDownloaderTask

@property (nonatomic, readonly) SMGatewayRequest* request;

- (instancetype)initWithRequest:(SMGatewayRequest*)aRequest;

/**
 * Process response here (this method called in queue taskQueue)
 * Override it in your subclass
 **/
- (void)requestCompleteWithResponse:(SMResponse*)aResponse;

@end
