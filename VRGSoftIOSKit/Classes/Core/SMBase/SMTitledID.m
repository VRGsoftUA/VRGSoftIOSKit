//
//  SMBOTitledID.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 9/23/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import "SMTitledID.h"


@implementation SMTitledID

@synthesize ID;
@synthesize title;

- (instancetype)initWithID:(id)aID title:(NSString*)aTitle
{
    if( (self = [super init]) )
    {
        self.ID = aID;
        self.title = aTitle;
    }
    
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithID:ID title:title];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"{%@, %@}", ID, title];
}

@end

@implementation NSArray (SMTitledID)

- (SMTitledID*)titledIDByID:(id) aID
{
    SMTitledID* result = nil;
    
    if([aID isKindOfClass:[NSString class]])
    {
        for(SMTitledID* titledID in self)
        {
            if([titledID.ID isEqualToString:aID])
            {
                result = titledID;
                break;
            }
        }
    }
    else
    {
        for(SMTitledID* titledID in self)
        {
            if([titledID.ID isEqual:aID])
            {
                result = titledID;
                break;
            }
        }
    }

    return result;
}

- (SMTitledID*)titledIDByTitle:(NSString*) aTitle
{
    SMTitledID* result = nil;
    
    for(SMTitledID* titledID in self)
    {
        if([titledID.ID isEqualToString:aTitle])
        {
            result = titledID;
            break;
        }
    }
    
    return result;
}

@end
