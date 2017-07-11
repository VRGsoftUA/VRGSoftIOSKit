//
//  SMTabBarController.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 07.04.12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMTabBarController.h"
#import "SMKitDefines.h"

@implementation SMTabBarItem

- (instancetype)init
{
    if( (self = [super init]) )
    {
        self.titleColor = [UIColor whiteColor];
        self.titleColorSelected = [UIColor whiteColor];
        self.titleFont = [UIFont systemFontOfSize:14];
        self.titleShadowColor = [UIColor clearColor];
        self.titleShadowOffset = CGSizeZero;
    }
    return self;
}

@end

@interface SMTabBarController ()

- (CGRect)getContentFrame;
- (void)setupControllers;
- (UIViewController*)correctForNavigationController:(UIViewController*)vc;
- (UIBarButtonItem*)spacerBeforeTabBarButtonAtIndex:(NSUInteger)anIndex;
- (void)disabledButtonPressed;
- (void)updateTabArrow;

@end

@implementation SMTabBarController

@synthesize delegate;

@synthesize style;
@synthesize tabBarOnTheTop;
@synthesize tabBarHeight;
@synthesize tabBarBackgroundImage;
@synthesize tabBarDrawsColor;
@synthesize tabBarBackgroundColor;
@synthesize tabBarEnabled;
@synthesize tabArrowImage;

@synthesize viewControllers;
@dynamic selectedViewController;
@synthesize selectedIndex;

#pragma mark - Init/Dealloc

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        tabBarHeight = 49;
        selectedIndex = 0;
        tabBarEnabled = YES;
    }
    return self;
}

- (void)dealloc
{
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.autoresizingMask = SMViewAutoresizingFlexibleSize;
}

- (void)viewDidUnload
{
    tabBar = nil;
    disabledButton = nil;
    contentView = nil;
    currentView = nil;
    tabArrowImageView = nil;
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(!contentView)
    {
        contentView = [[UIView alloc] initWithFrame:[self getContentFrame]];
        contentView.backgroundColor = [UIColor clearColor];
        contentView.autoresizingMask = SMViewAutoresizingFlexibleSize;
        [self.view addSubview:contentView];
    }
    
    if(!tabBar)
    {
        // create tabBar
        float y = (tabBarOnTheTop) ? (0) : (self.view.bounds.size.height - tabBarHeight);
        tabBar = [[SMTabedToolbar alloc] initWithFrame:CGRectMake(0, y, self.view.bounds.size.width, tabBarHeight)];
        tabBar.smdelegate = self;
        tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        tabBar.autoresizingMask |= (tabBarOnTheTop) ? (UIViewAutoresizingFlexibleBottomMargin) : (UIViewAutoresizingFlexibleTopMargin);
        tabBar.backgroundImage = tabBarBackgroundImage;
        tabBar.drawsColor = tabBarDrawsColor;
        if (tabBarBackgroundColor)
            tabBar.backgroundColor = tabBarBackgroundColor;
        tabBar.enabled = tabBarEnabled;
        
        [self configureTabBar];
        [self setupControllers];
        
        [self.view addSubview:tabBar];
    }
    
    [self updateTabArrow];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    BOOL result = YES;
    
    for(UIViewController* vc in viewControllers)
        result &= [vc shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    
    return result;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    UIInterfaceOrientationMask result = (SM_IS_IPAD) ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskAllButUpsideDown;
    
    for(UIViewController* vc in viewControllers)
        result = result & ([vc supportedInterfaceOrientations]);
    
    return result;
}

#pragma mark -

- (void)setTabBarEnabled:(BOOL)aTabBarEnabled
{
    tabBarEnabled = aTabBarEnabled;
    tabBar.enabled = tabBarEnabled;
}

- (void)setSelectedIndex:(NSUInteger)aSelectedIndex
{
    // save prev
    UIViewController* prevController = [self selectedViewController];
    UIView* prevView = currentView;
    
    // get new
    selectedIndex = aSelectedIndex;
    UIViewController* newController = [self selectedViewController];
    
    if (style != SMTabBarControllerStyleTabsHidden)
    {
        // switch tabBar
        [tabBar switchToItemWithIndex:selectedIndex];
        disabledButton.frame = [[tabBar.buttons objectAtIndex:aSelectedIndex] frame];
    }
    
    // will hide prev
    if(prevView)
    {
        [prevController removeFromParentViewController];
    }
    
    // will show new
    currentView = newController.view;
    currentView.frame = contentView.bounds;
    currentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // did hide prev
    if(prevView)
    {
        [prevView removeFromSuperview];
    }
    
    // did show new
    [contentView addSubview:currentView];
    [self addChildViewController:newController];
    
    [self updateTabArrow];
    
    // delegate
    if([self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)])
        [self.delegate tabBarController:self didSelectViewController:[viewControllers objectAtIndex:aSelectedIndex]];
}

- (UIViewController*)selectedViewController
{
    return ([viewControllers count] > 0 && selectedIndex < [viewControllers count]) ? ([viewControllers objectAtIndex:selectedIndex]) : nil;
}

- (void)setSelectedViewController:(UIViewController *)aSelectedViewController
{
    NSUInteger index = [viewControllers indexOfObject:aSelectedViewController];
    if(index != NSNotFound)
    {
        [self setSelectedIndex:index];
    }
}

- (CGRect)getContentFrame
{
    float y = (tabBarOnTheTop) ? (tabBarHeight) : (0);
    return CGRectMake(0, y, self.view.bounds.size.width, self.view.bounds.size.height - tabBarHeight);
}


- (void)setViewControllers:(NSArray *)aViewControllers
{
    if(viewControllers != aViewControllers)
    {
        selectedIndex = 0;
        
        // remove old controllers
        [currentView removeFromSuperview];
        currentView = nil;
        for(UIViewController* vc in viewControllers)
            [vc removeFromParentViewController];
        
        // save new controllers
        viewControllers = [aViewControllers copy];
        
        // setup new controllers
        if (tabBar)
            [self setupControllers];
    }
    
}

- (UIViewController*)correctForNavigationController:(UIViewController*)vc
{
    UIViewController* result = vc;
    
    if([vc isKindOfClass:[UINavigationController class]])
    {
        if([[(UINavigationController*)vc viewControllers] count] > 0)
            result = [[(UINavigationController*)vc viewControllers] objectAtIndex:0];
        else
        {
            NSAssert(NO, @"Navigation controller without root controller!");
            result = nil;
        }
    }
    
    return result;
}

- (void)setupControllers
{
    CGSize tabBarItemFullSize = CGSizeMake(ceilf(tabBar.bounds.size.width / viewControllers.count), tabBar.bounds.size.height);
    NSUInteger tabBarButtonIndex = 0;
    NSMutableArray* tabs = [NSMutableArray arrayWithCapacity:[viewControllers count]];
    
    for(__strong UIViewController* vc in viewControllers)
    {
        vc = [self correctForNavigationController:vc];
        vc.smtabBarController = self;
        
        if (style != SMTabBarControllerStyleTabsHidden)
        {
            [tabs addObject:[self spacerBeforeTabBarButtonAtIndex:tabBarButtonIndex]];
            
            // get tabBarItem
            NSAssert([vc conformsToProtocol:@protocol(SMTabBarItemProtocol)], @"View controller must implement protocol SMTabBarItemProtocol!");
            SMTabBarItem* tabBarItem = [(id<SMTabBarItemProtocol>)vc smtabBarItem];
            NSAssert(tabBarItem, @"tabBarItem must be non nil!");
            
            // create tabBar button and configure
            UIButton* button = [self createTabBarButtonAtIndex:tabBarButtonIndex];
            button.autoresizingMask = SMViewAutoresizingFlexibleSize | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            
            [button setTitle:tabBarItem.title forState:UIControlStateNormal];
            [button setTitleColor:tabBarItem.titleColor forState:UIControlStateNormal];
            [button setTitleColor:tabBarItem.titleColorSelected forState:UIControlStateDisabled];
            [button setTitleShadowColor:tabBarItem.titleShadowColor forState:UIControlStateNormal];
            button.titleLabel.font = tabBarItem.titleFont;
            button.titleLabel.shadowOffset = tabBarItem.titleShadowOffset;
            
            [button setBackgroundImage:tabBarItem.backgroundImageNormal forState:UIControlStateNormal];
            if(tabBarItem.backgroundImageSelected)
                [button setBackgroundImage:tabBarItem.backgroundImageSelected forState:UIControlStateDisabled];
            
            [button setImage:tabBarItem.imageNormal forState:UIControlStateNormal];
            if(tabBarItem.imageSelected)
                [button setImage:tabBarItem.imageSelected forState:UIControlStateDisabled];
            
            if(style == SMTabBarControllerStyleTabsFullSize)
            {
                button.frame = CGRectMake(0, 0, tabBarItemFullSize.width, tabBarItemFullSize.height);
            }
            else if(style == SMTabBarControllerStyleTabsSizeByBGImage)
            {
                button.frame = CGRectMake(0, 0, tabBarItem.backgroundImageNormal.size.width, tabBarItem.backgroundImageNormal.size.height);
            }
            else
            {
                NSAssert(NO, @"Other style don't supported yet!");
            }
            
            [self configureTabBarButton:button atIndex:tabBarButtonIndex];
            
            UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithCustomView:button];
            [tabs addObject:bbi];
            
            tabBarButtonIndex++;
        }
    }
    
    if (style == SMTabBarControllerStyleTabsHidden)
    {
        tabBar.hidden = YES;
    }
    else
    {
        tabBar.hidden = NO;
        tabBar.items = tabs;
        
        // disable button
        disabledButton = [UIButton buttonWithType:UIButtonTypeCustom];
        disabledButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [disabledButton addTarget:self action:@selector(disabledButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [tabBar addSubview:disabledButton];
    }
    
    [self setSelectedIndex:selectedIndex];
}

- (void)configureTabBar
{
    // empty by default
}

- (UIButton*)createTabBarButtonAtIndex:(NSUInteger)anIndex
{
    return [UIButton buttonWithType:UIButtonTypeCustom];
}

- (void)configureTabBarButton:(UIButton*)aTabBarButton atIndex:(NSUInteger)anIndex
{
    // empty by default
}

- (UIBarButtonItem*)spacerBeforeTabBarButtonAtIndex:(NSUInteger)anIndex
{
    UIBarButtonItem* result = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    result.width = [self spaceBeforeTabBarButtonAtIndex:anIndex];
    return result;
}

- (CGFloat)spaceBeforeTabBarButtonAtIndex:(NSUInteger)anIndex
{
    CGFloat result = 0.0f;
    if(style == SMTabBarControllerStyleTabsFullSize)
    {
        if(anIndex == 0)
            result = -12;
        else
            result = -10;
    }
    return result;
}

- (void)disabledButtonPressed
{
    if([self.selectedViewController isKindOfClass:[UINavigationController class]])
    {
        [((UINavigationController*)self.selectedViewController) popToRootViewControllerAnimated:YES];
    }
}

- (void)updateTabArrow
{
    if(!tabArrowImage)
        return;
    
    // configure position of the arrow
    if(!tabArrowImageView)
    {
        tabArrowImageView = [[UIImageView alloc] initWithImage:tabArrowImage];
        tabArrowImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [tabBar addSubview:tabArrowImageView];
    }
    
    CGPoint arrowCenter;
    arrowCenter.x = disabledButton.center.x;
    if(tabBarOnTheTop)
    {
        arrowCenter.y = tabBarHeight + tabArrowImage.size.height / 2;
    }
    else
    {
        arrowCenter.y = -tabArrowImage.size.height / 2;
    }
    tabArrowImageView.center = arrowCenter;
}

- (void)updateTabBarButtonTitle:(NSString*)aTabBarButtonTitle forTabBarAtIndex:(NSUInteger)aTabBarButtonIndex
{
    UIButton* button = [tabBar.buttons objectAtIndex:aTabBarButtonIndex];
    [button setTitle:aTabBarButtonTitle forState:UIControlStateNormal];
}

#pragma mark - SMTabedToolbarDelegate

- (BOOL)tabedToolbar:(SMTabedToolbar *)aTabBar shouldSelectItemAtIndex:(NSUInteger)anIndex
{
    BOOL result = YES;
    if ([self.delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)])
        result = [self.delegate tabBarController:self shouldSelectViewController:[viewControllers objectAtIndex:anIndex]];
    
    return result;
}

- (void)tabedToolbar:(SMTabedToolbar*)aTabBar itemChangedTo:(NSUInteger)aToIndex from:(NSUInteger)aFromIndex
{
    [self setSelectedIndex:aToIndex];
}

@end
