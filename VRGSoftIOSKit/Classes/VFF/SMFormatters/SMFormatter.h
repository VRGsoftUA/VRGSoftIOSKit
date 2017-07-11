//
//  SMFormatter.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 22.04.13.
//
//

#import <Foundation/Foundation.h>

@class SMFormatter;

@protocol SMFormatterProtocol <NSObject>

- (void)setFormatter:(SMFormatter*)aFormatter;
- (SMFormatter*)formatter;
- (NSString*)formattingText;

@end


@interface SMFormatter : NSObject

@property (nonatomic, weak) id<SMFormatterProtocol> formattableObject;

- (NSString*)formattedTextFromString:(NSString*)aOriginalString;
- (BOOL)formatWithNewCharactersInRange:(NSRange)aRange replacementString:(NSString*)aString;

- (NSString*)rawText;

@end
