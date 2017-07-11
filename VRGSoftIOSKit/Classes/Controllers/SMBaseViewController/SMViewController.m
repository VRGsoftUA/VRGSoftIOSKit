//
//  SMViewController.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 7/7/11.
//  Copyright 2011 VRGSoft. all rights reserved.
//

#import "SMViewController.h"
#import "UIAlertView+BlocksKit.h"
#import "SMActivityHUD.h"
#import "SMAlertView.h"

@implementation SMViewController

@synthesize isVisible,isModal;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    activity = [SMActivityHUD new];
    [activity configureWithView:self.view];
    
    // bg image
    UIImage* bgImage = [self backgroundImage];
    if (bgImage)
    {
        CGRect frame = self.view.bounds;
        _backgroundImageView = [[UIImageView alloc] initWithFrame:frame];
        _backgroundImageView.autoresizingMask = SMViewAutoresizingFlexibleSize;
        [_backgroundImageView setImage:bgImage];
        [self.view addSubview:_backgroundImageView];
        [self.view sendSubviewToBack:_backgroundImageView];
    }
    
    // left nav button
    if(!self.navigationItem.hidesBackButton)
    {
        // custom left button
        UIBarButtonItem* leftNavigationButton = [self createLeftNavButton];
        if(leftNavigationButton)
        {
            if ([leftNavigationButton.customView isKindOfClass:[UIButton class]])
            {
                [((UIButton*)leftNavigationButton.customView) addTarget:self
                                                                 action:@selector(didBtNavLeftClicked:)
                                                       forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                leftNavigationButton.target = self;
                leftNavigationButton.action = @selector(didBtNavLeftClicked:);
            }
            
            NSArray *leftBbis = self.createLeftNavButtonsAdditionals;
            if (leftBbis.count)
            {
                NSMutableArray *fullLeftBbis = [NSMutableArray new];
                [fullLeftBbis addObject:leftNavigationButton];
                [fullLeftBbis addObjectsFromArray:leftBbis];
                self.navigationItem.leftBarButtonItems = fullLeftBbis;
            } else
            {
                self.navigationItem.leftBarButtonItem = leftNavigationButton;
            }
        }
    }
    
    // right nav button
    UIBarButtonItem* rightNavigationButton = [self createRightNavButton];
    if(rightNavigationButton)
    {
        if ([rightNavigationButton.customView isKindOfClass:[UIButton class]])
        {
            [((UIButton*)rightNavigationButton.customView) addTarget:self
                                                              action:@selector(didBtNavRightClicked:)
                                                    forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            rightNavigationButton.target = self;
            rightNavigationButton.action = @selector(didBtNavRightClicked:);
        }
        
        NSArray *rightBbis = self.createRightNavButtonsAdditionals;
        if (rightBbis.count)
        {
            NSMutableArray *fullRightBbis = [NSMutableArray new];
            [fullRightBbis addObject:rightNavigationButton];
            [fullRightBbis addObjectsFromArray:rightBbis];
            self.navigationItem.rightBarButtonItems = fullRightBbis;
        } else
        {
            self.navigationItem.rightBarButtonItem = rightNavigationButton;
        }
    }
    
    // custom title view for nav.item
    UIView *titleView = [self createTitleViewNavItem];
    if (titleView)
    {
        self.navigationItem.titleView = titleView;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotification:) name:self.class.notificationKey object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isVisible = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    isVisible = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}


- (BOOL)isModal
{
    return (self.navigationController.childViewControllers.firstObject == self || self.navigationController == nil);
}


#pragma mark - Activity

- (void)showActivity
{
    [activity showActivity:YES];
}

- (void)hideActivity;
{
    [activity hideActivity:YES];
}


#pragma mark - Show Alert View

- (void)showAlertViewWithTitle:(NSString*)aTitle message:(NSString*)aMessage
{
    if (isVisible && aMessage.length)
    {
        SMShowSimpleAlertControllerFromVc(aTitle, aMessage,self);
    }
}

- (void)showAlertViewWithTitle:(NSString *)aTitle
                       message:(NSString *)aMessage
             cancelButtonTitle:(NSString *)aCancelButtonTitle
             otherButtonTitles:(NSArray *)aOtherButtonTitles
                  dismissBlock:(void(^)(id alertController, NSInteger buttonIndex))dismissBlock
{
    if (isVisible && aMessage.length)
    {
        [SMAlertController showAlertControllerWithTitle:aTitle
                                                message:aMessage
                                     fromViewController:self
                                      cancelButtonTitle:aCancelButtonTitle
                                      otherButtonTitles:aOtherButtonTitles
                                                handler:dismissBlock];
    }
}


#pragma mark - Customization For Navigation Bar

// create custom left button for navigation bar
- (UIBarButtonItem*)createLeftNavButton
{
    return nil;
}

// create custom left buttons for navigation bar
- (NSArray <UIBarItem *>*)createLeftNavButtonsAdditionals
{
    return nil;
}


// create custom right button for navigation bar
- (UIBarButtonItem*)createRightNavButton
{
    return nil;
}

// create custom right buttons for navigation bar
- (NSArray <UIBarItem *>*)createRightNavButtonsAdditionals
{
    return nil;
}

// create custom title view for navigation bar (return nil by default)
- (UIView*)createTitleViewNavItem
{
    return nil;
}


#pragma mark - Process Events

// action to process pressed-on-left-button event
- (void)didBtNavLeftClicked:(id)aSender
{
    if (self.isModal)
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// action to process pressed-on-right-button event
- (void)didBtNavRightClicked:(id)aSender
{
    // empty by default
}


#pragma mark - Backgroung Image

- (UIImage*)backgroundImage
{
    return nil;
}

+ (instancetype)loadFromNib
{
    return [[self alloc] initWithNibName:NSStringFromClass(self) bundle:nil];
}

- (void)dealloc
{
    SMDeallocLog;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - NSNotification

+ (void)sendNotificationData:(id)aData
{
    [[NSNotificationCenter defaultCenter] postNotificationName:self.notificationKey object:aData];
}

+ (NSString *)notificationKey
{
    return [NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),NSStringFromSelector(@selector(sendNotificationData:))];
}

- (void)reciveNotification:(NSNotification *)aNotification
{
    [self reciveNotificationData:aNotification.object];
}

- (void)reciveNotificationData:(id)aData
{
    
}

@end
