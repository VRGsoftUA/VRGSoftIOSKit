//
//  SMModuleRemotePushes.h
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 29.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMRequest.h"

/**
 * Use subclass of this module to process remote notification.
 * To use: subclass, override appropriate methods(see below).
 **/
@interface SMModuleRemotePushes : NSObject
{
    NSString* deviceToken;
}

@property (nonatomic, readonly) NSString* deviceToken;
//@property (nonatomic, readonly) NSDate* deviceTokenLastUpdate;

/**
 * Call it in application:didFinishLaunchingWithOptions: method.
 **/
- (void)tryToRegisterForUserNotificationDefault;
- (void)tryToRegisterForUserNotificationTypes:(UIUserNotificationType)aUserNotificationTypes;

/**
 * If you use API that should update deviceToken from time to time, then
 * setup time to update token with this property.
 * 0 by default (Don't update).
 **/
@property (nonatomic, assign) NSUInteger deviceTokenUpdateTimeInterval;

/**
 * Call it in application:didRegisterForRemoteNotificationsWithDeviceToken: method.
 **/
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)aDeviceToken;

/**
 * Call it to register from remote pushes.
 **/
- (void)registerForPushNotifications;

/**
 * Call it to unregister from remote pushes.
 **/
- (void)unregisterForPushNotifications;

/**
 * Use to process received remote push.
 * Call it from -(BOOL)application:didFinishLaunchingWithOptions: or from -(void)application:didReceiveRemoteNotification:
 * Override this method to process received remote push notification.
 **/
- (void)receivePushNotification:(NSDictionary*)aNotificationInfo;

///**
// * checks if device token should be updated according to deviceTokenUpdateTimeInterval. Can be overriden in subclass
// **/
//- (BOOL)shouldUpdateDeviceToken;

#pragma mark - Requests
/**
 * Override this methods in your subclass
 **/
- (SMRequest*)registerDeviceTokenRequest;
- (SMRequest*)unregisterDeviceTokenRequest;
- (BOOL)canRegisterDeviceToken;   //default YES
- (BOOL)canUnregisterDeviceToken; //default YES

@end
