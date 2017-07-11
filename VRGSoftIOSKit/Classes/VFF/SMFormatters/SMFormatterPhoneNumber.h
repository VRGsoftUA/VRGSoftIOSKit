//
//  SMFormatterPhoneNumber.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 12/14/11.
//  Copyright (c) 2011 VRGSoft. all rights reserved.
//

#import "SMFormatter.h"

@interface SMFormatterPhoneNumber : SMFormatter
{
    /**
     * available formats @"us", @"uk", @"jp, @"ru", @"ua"
     **/
    NSDictionary *predefinedFormats;

    NSCharacterSet *acceptableInputCharacters;
}

@property (nonatomic, retain) NSString* locale;

/*
 * if result string after formatting is not suitable for any format of current local then return just input string
 * if value is NO then return prev formatted string before last input
 * by default is NO
 */
@property (nonatomic, assign) BOOL acceptsNotPredefinedFormattedPhoneNumber;

@end
