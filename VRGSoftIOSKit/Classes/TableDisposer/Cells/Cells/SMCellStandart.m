//
//  SMLabelCell.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 3/30/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMCellStandart.h"
#import "SMCellDataStandart.h"
#import "UIImageView+AFNetworking.h"

@implementation SMCellStandart

- (void)setupCellData:(SMCellData *)aCellData
{
    [super setupCellData:aCellData];

    SMCellDataStandart *cellDataStandart = (SMCellDataStandart*)self.cellData;
    
    self.textLabel.text = cellDataStandart.title;
    self.textLabel.font = cellDataStandart.titleFont;
    self.textLabel.textColor = cellDataStandart.titleColor;
    self.textLabel.textAlignment = cellDataStandart.titleTextAlignment;
    
    self.detailTextLabel.textColor = cellDataStandart.subtitleColor;
    self.detailTextLabel.font = cellDataStandart.subtitleFont;
    self.detailTextLabel.text = cellDataStandart.subtitle;
    
    if(cellDataStandart.imageURL)
        [self.imageView setImageWithURL:cellDataStandart.imageURL placeholderImage:cellDataStandart.imagePlaceholder];
    else
        [self.imageView setImage:cellDataStandart.image];
}

@end
