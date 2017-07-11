//
//  SMModuleRemotePushes.m
//  VRGSoftIOSKit
//
//  Created by VRGSoft on 29.04.13.
//  Copyright (c) 2013 VRGSoft. all rights reserved.
//

#import "SMModuleRemotePushes.h"

@implementation SMModuleRemotePushes

@synthesize deviceToken;


#pragma mark - Device token Register/Update/Unregister

- (void)tryToRegisterForUserNotificationDefault
{
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)tryToRegisterForUserNotificationTypes:(UIUserNotificationType)aUserNotificationTypes
{
    UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:aUserNotificationTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
}

- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)aDeviceToken
{
    NSString* newDeviceToken = [NSString stringWithFormat:@"%@", aDeviceToken];
    newDeviceToken = [newDeviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    newDeviceToken = [newDeviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    newDeviceToken = [newDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    SMLog(@"SMModuleRemotePushes: Device token: %@", newDeviceToken);
    
    
    deviceToken = newDeviceToken;
    
    [self registerForPushNotifications];
}

- (void)registerForPushNotifications
{
    if(self.deviceToken.length && [self canRegisterDeviceToken])
    {
        [[self registerDeviceTokenRequest] start];
    }
}

- (void)unregisterForPushNotifications
{
    if(self.deviceToken.length && [self canUnregisterDeviceToken])
    {
        [[self unregisterDeviceTokenRequest] start];
    }
}


#pragma mark - Process notification

- (void)receivePushNotification:(NSDictionary*)aNotificationInfo
{
    SMLog(@"SMModuleRemotePushes: Receive push notification: %@", aNotificationInfo);
}


#pragma mark - Requests

- (SMRequest*)registerDeviceTokenRequest
{
    return nil;
}

- (SMRequest*)unregisterDeviceTokenRequest
{
    return nil;
}

- (BOOL)canRegisterDeviceToken
{
    return YES;
}

- (BOOL)canUnregisterDeviceToken
{
    return YES;
}

@end
