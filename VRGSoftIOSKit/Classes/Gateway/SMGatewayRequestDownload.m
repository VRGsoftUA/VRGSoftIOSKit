//
//  SMGatewayRequestDownload.m
//  VRGSoftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 12/28/15.
//  Copyright © 2015 VRGSoft. All rights reserved.
//

#import "SMGatewayRequestDownload.h"
#import "SMGateway.h"

@implementation SMGatewayRequestDownload

- (NSURLSessionTask *)dataTask
{
    SMWeakSelf;
    __block NSURLSessionTask *dataTask = nil;
    assert(NO);
    dataTask = [gateway.httpClient downloadTaskWithRequest:self.urlRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        [weakSelf executeAllDownloadProgressBlocksWith:downloadProgress];
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return weakSelf.filePath;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            if(!(dataTask.state == NSURLSessionTaskStateCanceling))
                SMLog(@"\nSMGateway request failed with error:\n%@\n", error);
            [weakSelf executeFailureBlockWithOperation:dataTask error:error];
        } else {
            [weakSelf executeSuccessBlockWithOperation:dataTask responseObject:filePath];
        }
    }];
    
    dataTask = [gateway.httpClient dataTaskWithRequest:self.urlRequest uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
        [weakSelf executeAllUploadProgressBlocksWith:uploadProgress];
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
        [weakSelf executeAllDownloadProgressBlocksWith:downloadProgress];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if(!(dataTask.state == NSURLSessionTaskStateCanceling))
                SMLog(@"\nSMGateway request failed with error:\n%@\n", error);
            [weakSelf executeFailureBlockWithOperation:dataTask error:error];
        } else {
            [weakSelf executeSuccessBlockWithOperation:dataTask responseObject:responseObject];
        }
    }];
    
    return dataTask;
}

@end
