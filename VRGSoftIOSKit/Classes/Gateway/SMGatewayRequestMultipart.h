//
//  SMGatewayRequestMultipart.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 24.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMGatewayRequest.h"

@protocol SMMultipartFormData <AFMultipartFormData>
@end

typedef void (^SMConstructingMultipartFormDataBlock)(id<SMMultipartFormData> formData);

@interface SMGatewayRequestMultipart : SMGatewayRequest
{
    NSMutableArray* constructingBlocks;
}

- (void)addConstructingMultipartFormDataBlock:(SMConstructingMultipartFormDataBlock)block;

@end


