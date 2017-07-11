//
//  SMPullToRefreshAdapter.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 15.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>

@class SMPullToRefreshAdapter;

typedef void (^SMPullToRefreshAdapterRefreshCallback)(SMPullToRefreshAdapter* aRefreshAdapter);

/**
 * Adapter for any pull-to-refresh controls (controls that provide pull-to-refresh effect for UITableView).
 * Implemented according to Adapter pattern.
 * This pattern make ability to use any pull-to-refresh control inside ready logic and switch between outer pull-to-refresh controls without any changes in code that used this wrapper.
 * This adapter used only with UITableView classes.
 */
@interface SMPullToRefreshAdapter : NSObject

@property (nonatomic,assign) BOOL enabled;

/**
 * Setup callback that should be executed at the and of pull-to-refresh effect.
 * As example, when user drag table down, pull-to-refresh effect appears. After that user drop table and this callback will be executed.
 * In this callback you can begin update data (fetch from remote server, or from local database).
 */
@property (nonatomic, copy) SMPullToRefreshAdapterRefreshCallback refreshCallback;

/**
 * Configure wrapped pull-to-refresh control in this method.
 * You should call this method in methods like -viewDidLoad: (in controller) or some of -init methods in view subclasses.
 * @param aTableView Parent view for wrapped control.
 */
- (void)configureWithTableView:(UITableView*)aTableView;

/**
 * Remove and nullify wrapped control here.
 * As example, you can call this method inside -viewDidUnload of controller.
 */
- (void)releaseRefreshControl;

/**
 * Call this method to begin pull-to-refresh process and visual effect.
 */
- (void)beginPullToRefresh;

/**
 * Call this method to complete pull-to-refresh process and visual effect.
 * As example, you can call this method after updateing data.
 * In this method you should hide pull-to-refresh effect.
 */
- (void)endPullToRefresh;

@end
