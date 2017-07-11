//
//  SMQueueNode.m
//  VRGSoftIOSKit
//
//  Created by Alexander Burkhai on 8/6/13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMQueueNode.h"

@implementation SMQueueNode

- (void)dealloc
{
    self.dispatchQueue = NULL;
}

#if SM_NEEDS_DISPATCH_RETAIN_RELEASE
- (void)setDispatchQueue:(dispatch_queue_t)dispatchQueue
{
    if (_dispatchQueue != dispatchQueue)
    {
        if (_dispatchQueue)
        {
            dispatch_release(_dispatchQueue);
            _dispatchQueue = NULL;
        }
        
        if (dispatchQueue)
        {
            dispatch_retain(dispatchQueue);
            _dispatchQueue = dispatchQueue;
        }
    }
}
#endif

@end
