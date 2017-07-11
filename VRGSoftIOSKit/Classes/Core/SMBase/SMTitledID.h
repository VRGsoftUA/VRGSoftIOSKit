//
//  SMBOTitledID.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 9/23/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>


@interface SMTitledID : NSObject <NSCopying>
{
    id ID;
    NSString* title;
}

@property (nonatomic, strong) id ID;
@property (nonatomic, strong) NSString* title;

- (instancetype)initWithID:(id)aID title:(NSString*)aTitle;

@end


@interface NSArray (SMTitledID)

- (SMTitledID*)titledIDByID:(id) aID;
- (SMTitledID*)titledIDByTitle:(NSString*) aTitle;

@end
