//
//  SMDataBaseRequest.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 16.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMRequest.h"
#import "SMStorage.h"

@interface SMDataBaseRequest : SMRequest
{
    SMStorage* storage;

    BOOL cancelled;
    BOOL executing;
}

@property (nonatomic, strong) NSFetchRequest* fetchRequest;

- (instancetype)initWithStorage:(SMStorage*)aStorage;

/**
 * Execute request synchronously
 **/
- (void)execute;

@end
