//
//  SMBOCompoundModel.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 11.02.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMCompoundModel : NSObject

/*
 * indicates how much models could be in compound model
 * readwrite property so you can change this value at any time
 * for ex. cell according to this value will generate empty spaces for missing items
 */
@property (nonatomic, assign) NSUInteger maxModelsCount;

@property (nonatomic, readonly) NSArray* models;

- (instancetype)initWithModels:(NSArray*)aModels;

+ (NSArray*)compoundModelsFromModels:(NSArray*)aModels
                      groupedByCount:(NSUInteger)aGroupCount;

@end
