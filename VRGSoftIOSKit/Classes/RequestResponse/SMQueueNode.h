//
//  SMQueueNode.h
//  VRGSoftIOSKit
//
//  Created by Alexander Burkhai on 8/6/13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMKitDefines.h"

@interface SMQueueNode : NSObject

#if SM_NEEDS_DISPATCH_RETAIN_RELEASE
    @property (nonatomic, assign) dispatch_queue_t dispatchQueue;
#else
    @property (nonatomic, strong) dispatch_queue_t dispatchQueue;
#endif

@end
