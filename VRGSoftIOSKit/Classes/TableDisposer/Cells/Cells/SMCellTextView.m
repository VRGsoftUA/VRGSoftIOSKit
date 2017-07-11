//
//  SMCellTextView.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 04.04.12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMCellTextView.h"
#import "SMCellDataTextView.h"
//#import <QuartzCore/QuartzCore.h>

@implementation SMCellTextView

@synthesize textView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:titleLabel];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        textView = [[SMTextView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:textView];
        textView.backgroundColor = [UIColor clearColor];
        textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [textView addObserver:self forKeyPath:@"observedText" options:NSKeyValueObservingOptionNew context:NULL];
        
        
    }
    return self;
}

- (void)dealloc
{
    [textView removeObserver:self forKeyPath:@"observedText"];
}

- (void)setupCellData:(SMCellData *)aCellData
{
    [super setupCellData:aCellData];
    
    SMCellDataTextView* cellDataTextView = (SMCellDataTextView*)aCellData;
    
    // text
    CGFloat cellHeight = [cellDataTextView cellHeightForWidth:self.bounds.size.width];
    CGFloat titleHeight = (cellDataTextView.title) ? cellDataTextView.titleFont.lineHeight : 0;
    textView.frame = CGRectMake(0, titleHeight, self.contentView.bounds.size.width, cellHeight - titleHeight);

    textView.autocapitalizationType = cellDataTextView.autocapitalizationType;
    textView.autocorrectionType = cellDataTextView.autocorrectionType;
    textView.keyboardType = cellDataTextView.keyboardType;
    textView.keyboardAppearance = cellDataTextView.keyboardAppearance;
    textView.returnKeyType = cellDataTextView.returnKeyType;
    
    textView.text = cellDataTextView.text;
    textView.font = cellDataTextView.textFont;
    textView.textColor = cellDataTextView.textColor;
    textView.textAlignment = cellDataTextView.textAlignment;
    textView.editable = self.cellData.enableEdit;
    
    textView.validator = cellDataTextView.validator;
    textView.filter = cellDataTextView.filter;
    
    if (cellDataTextView.placeholder)
        textView.placeholder = cellDataTextView.placeholder;
    if (cellDataTextView.placeholderColor)
        textView.placeholderColor = cellDataTextView.placeholderColor;

    // title
    titleLabel.frame = CGRectMake(10, 0, self.contentView.bounds.size.width - 20, titleHeight);
    titleLabel.text = cellDataTextView.title;
    titleLabel.textColor = cellDataTextView.titleColor;
    titleLabel.font = cellDataTextView.titleFont;
    
}

- (NSArray *)inputTraits
{
    if(!self.cellData.disableInputTraits && self.cellData.enableEdit)
    {
        return [NSArray arrayWithObject:textView];
    }
    
    return nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    ((SMCellDataTextView*)self.cellData).text = [change objectForKey:NSKeyValueChangeNewKey];
}

@end
