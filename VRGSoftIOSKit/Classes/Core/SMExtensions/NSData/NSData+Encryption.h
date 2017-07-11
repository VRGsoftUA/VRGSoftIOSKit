//
//  NSData+Encryption.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 11.07.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

@interface NSData (Encryption)

- (NSData *)md5Digest;
- (NSData *)sha1Digest;

- (NSString *)hexStringValue;

- (NSString *)base64Encoded;
- (NSData *)base64Decoded;

@end
