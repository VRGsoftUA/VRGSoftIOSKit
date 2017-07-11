//
//  SMKeyboardToolbar.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 4/16/12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMKeyboardToolbar.h"

@interface SMKeyboardToolbar ()

@end

@implementation SMKeyboardToolbar

@synthesize bbiDone;
@synthesize smdelegate;
@synthesize bbiBack,bbiNext;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.barStyle = UIBarStyleBlack;
        self.translucent = NO;
        self.opaque = NO;
        NSBundle *mainBundle = [NSBundle mainBundle];

        NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"VRGSoftIOSKit" ofType:@"bundle"]];

        UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeSystem];
        buttonBack.frame = CGRectMake(0, 0, 40, 40);
        
        UIImage *imageLeft = [UIImage imageNamed:@"SMKeyboardAvoideBarArrowLeft" inBundle:resourcesBundle compatibleWithTraitCollection:nil];
        UIImage *imageRight = [UIImage imageNamed:@"SMKeyboardAvoideBarArrowRight" inBundle:resourcesBundle compatibleWithTraitCollection:nil];

        
        [buttonBack setImage:imageLeft forState:UIControlStateNormal];
        [buttonBack addTarget:self action:@selector(didBtBackClicked:) forControlEvents:UIControlEventTouchUpInside];
        bbiBack = [[UIBarButtonItem alloc] initWithCustomView:buttonBack];
        
        UIButton *buttonNext = [UIButton buttonWithType:UIButtonTypeSystem];
        buttonNext.frame = CGRectMake(0, 0, 40, 40);
        [buttonNext setImage:imageRight forState:UIControlStateNormal];
        [buttonNext addTarget:self action:@selector(didBtNextClicked:) forControlEvents:UIControlEventTouchUpInside];
        bbiNext = [[UIBarButtonItem alloc] initWithCustomView:buttonNext];
        
        UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixed.width = 10;
        
        bbiDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didBtDoneClicked:)];

        
        self.items = [NSArray arrayWithObjects:bbiBack,bbiNext, flex, self.bbiDone,fixed, nil];
        
        UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5f, self.frame.size.width, 0.5f)];
        vLine.backgroundColor = [UIColor blackColor];
        vLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:vLine];
        self.tintColor = [UIColor blackColor];
    }
    
    return self;
}

- (void)setKeyboardAppearance:(UIKeyboardAppearance)keyboardAppearance
{
    _keyboardAppearance = keyboardAppearance;
    
    switch (keyboardAppearance)
    {
        case UIKeyboardAppearanceDefault:
        {
            self.backgroundColor = [UIColor colorWithRed:210.0f/255.0f green:213.0f/255.0f blue:219.0f/255.0f alpha:1.0f];//Light
            self.tintColor = [UIColor blackColor];
        }
            break;

        case UIKeyboardAppearanceLight:
        {
            self.backgroundColor = [UIColor colorWithRed:210.0f/255.0f green:213.0f/255.0f blue:219.0f/255.0f alpha:1.0f];//Light
            self.tintColor = [UIColor blackColor];
        }
            break;

        case UIKeyboardAppearanceDark:
        {
            self.backgroundColor = [UIColor colorWithRed:80.0f/255.0f green:80.0f/255.0f blue:80.0f/255.0f alpha:0.97f];//Dark
            self.tintColor = [UIColor whiteColor];
        }
            break;

        default:
            break;
    }
//    self.backgroundColor = [UIColor clearColor];
}

- (void)selectedInputFieldIndex:(NSInteger)selectInsex allCountInputFields:(NSInteger)allCountInputFields
{
    if (selectInsex > 0)
        bbiBack.enabled = YES;
    else
        bbiBack.enabled = NO;
    
    if (selectInsex < allCountInputFields - 1)
        bbiNext.enabled = YES;
    else
        bbiNext.enabled = NO;
}

- (void)segmentedControlPreviousNextChangedValue:(id)sender
{
    switch ([(UISegmentedControl *)sender selectedSegmentIndex])
    {
        case 0:
            [smdelegate didPrevButtonPressd];
            break;
        case 1:
            [smdelegate didNextButtonPressd];
            break;
    }
}

- (void)didBtBackClicked:(id)sender
{
    [self.smdelegate didPrevButtonPressd];
}

- (void)didBtNextClicked:(id)sender
{
    [self.smdelegate didNextButtonPressd];
}

- (void)didBtDoneClicked:(id)sender
{
    [self.smdelegate didDoneButtonPressd];
}

@end




