//
//  SMFetchable.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 10/14/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>

//==============================================================================
@protocol SMFetchable <NSObject>

/**
 * Need fetch data from server
 **/
@property (nonatomic, assign) BOOL needFetch;

- (void)fetchData;

@end
