//
//  SPNetWorkReachability.h
//
//  Created by lishiping on 20/6/29.
//  Copyright © 2020年 lishiping. All rights reserved.
//
/*高级网络环境类，带有2g，3g，4g，wifi*/

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SPNetWorkStatus) {
    SPNetWorkStatusNotReachable = 0,
    SPNetWorkStatusUnknown = 1,
    SPNetWorkStatusWWAN2G = 2,
    SPNetWorkStatusWWAN3G = 3,
    SPNetWorkStatusWWAN4G = 4,
    SPNetWorkStatusWWAN5G = 5,
    SPNetWorkStatusWiFi = 9,
};

extern NSString *SPNetWorkReachabilityChangedNotification;

@interface SPNetWorkReachability : NSObject

/*!
 * Use to check the reachability of a given host name.
 */
+ (instancetype)reachabilityWithHostName:(NSString *)hostName;

/*!
 * Use to check the reachability of a given IP address.
 */
+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress;

/*!
 * Checks whether the default route is available. Should be used by applications that do not connect to a particular host.
 */
+ (instancetype)reachabilityForInternetConnection;

- (BOOL)startNotifier;

- (void)stopNotifier;

- (SPNetWorkStatus)currentReachabilityStatus;

@end
