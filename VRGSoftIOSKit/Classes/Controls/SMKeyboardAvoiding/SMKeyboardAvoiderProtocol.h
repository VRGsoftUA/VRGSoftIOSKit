//
//  SMKeyboardAvoiderProtocol.h
// VRGSoftIOSKit
//
//  Created by VRGSoft on 02.04.12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SMKeyboardAvoidingProtocol;

@protocol SMKeyboardAvoiderProtocol <NSObject>

@property (nonatomic, weak) id<SMKeyboardAvoidingProtocol> keyboardAvoiding;

@end
