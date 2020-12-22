//
//  SPNetWorkReachability.m
//  SECC01
//
//  Created by lishiping on 20/6/29.
//  Copyright © 2020年 lishiping. All rights reserved.
//
#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <UIKit/UIKit.h>
#import <netinet/in.h>

#import "SPNetWorkReachability.h"

NSString *SPNetWorkReachabilityChangedNotification = @"SPNetWorkReachabilityChangedNotification";

static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
{
    SPNetWorkReachability *networkObject = (__bridge SPNetWorkReachability *)info;
    
    [[NSNotificationCenter defaultCenter] postNotificationName: SPNetWorkReachabilityChangedNotification object:networkObject];
}

@implementation SPNetWorkReachability
{
    SCNetworkReachabilityRef _reachabilityRef;
}

+ (instancetype)reachabilityWithHostName:(NSString *)hostName
{
    SPNetWorkReachability *returnValue = NULL;
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String]);
    if (reachability != NULL) {
        returnValue = [[self alloc] init];
        if (returnValue != NULL) {
            returnValue->_reachabilityRef = reachability;
        } else {
            CFRelease(reachability);
        }
    }
    return returnValue;
}

+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress
{
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, hostAddress);
    
    SPNetWorkReachability* returnValue = NULL;
    
    if (reachability != NULL)
    {
        returnValue = [[self alloc] init];
        if (returnValue != NULL)
        {
            returnValue->_reachabilityRef = reachability;
        }
        else {
            CFRelease(reachability);
        }
    }
    return returnValue;
}

+ (instancetype)reachabilityForInternetConnection
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    return [self reachabilityWithAddress: (const struct sockaddr *) &zeroAddress];
}

- (BOOL)startNotifier
{
    BOOL returnValue = NO;
    SCNetworkReachabilityContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    
    if (SCNetworkReachabilitySetCallback(_reachabilityRef, ReachabilityCallback, &context)) {
        if (SCNetworkReachabilityScheduleWithRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode)) {
            returnValue = YES;
        }
    }
    return returnValue;
}

- (SPNetWorkStatus)currentReachabilityStatus
{
    SPNetWorkStatus returnValue = SPNetWorkStatusNotReachable;
    SCNetworkReachabilityFlags flags;
    if (SCNetworkReachabilityGetFlags(_reachabilityRef, &flags))
    {
        returnValue = [self networkStatusForFlags:flags];
    }
    
    return returnValue;
}

- (SPNetWorkStatus)networkStatusForFlags:(SCNetworkReachabilityFlags)flags
{
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
    {
        // The target host is not reachable.
        return SPNetWorkStatusNotReachable;
    }
    
    SPNetWorkStatus returnValue = SPNetWorkStatusNotReachable;
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
    {
        /*
         If the target host is reachable and no connection is required then we'll assume (for now) that you're on Wi-Fi...
         */
        returnValue = SPNetWorkStatusWiFi;
    }
    
    if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
         (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
    {
        /*
         ... and the connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs...
         */
        
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
        {
            /*
             ... and no [user] intervention is needed...
             */
            returnValue = SPNetWorkStatusWiFi;
        }
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
    {
        /*
         ... but WWAN connections are OK if the calling application is using the CFNetwork APIs.
         */
        NSArray *typeStrings2G = @[CTRadioAccessTechnologyEdge,
                           CTRadioAccessTechnologyGPRS,
                           CTRadioAccessTechnologyCDMA1x];
        
        NSArray *typeStrings3G = @[CTRadioAccessTechnologyHSDPA,
                           CTRadioAccessTechnologyWCDMA,
                           CTRadioAccessTechnologyHSUPA,
                           CTRadioAccessTechnologyCDMAEVDORev0,
                           CTRadioAccessTechnologyCDMAEVDORevA,
                           CTRadioAccessTechnologyCDMAEVDORevB,
                           CTRadioAccessTechnologyeHRPD];
        
        NSArray *typeStrings4G = @[CTRadioAccessTechnologyLTE];
        NSArray *typeStrings5G = nil;
        if (@available(iOS 14.0, *)) {
            typeStrings5G = @[CTRadioAccessTechnologyNRNSA,CTRadioAccessTechnologyNR];
        }

        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            CTTelephonyNetworkInfo *teleInfo= [[CTTelephonyNetworkInfo alloc] init];
            NSString *accessString = teleInfo.currentRadioAccessTechnology;
            if (typeStrings5G && [typeStrings5G containsObject:accessString]) {
                return SPNetWorkStatusWWAN5G;
            }
            else if ([typeStrings4G containsObject:accessString]) {
                return SPNetWorkStatusWWAN4G;
            } else if ([typeStrings3G containsObject:accessString]) {
                return SPNetWorkStatusWWAN3G;
            } else if ([typeStrings2G containsObject:accessString]) {
                return SPNetWorkStatusWWAN2G;
            } else {
                return SPNetWorkStatusUnknown;
            }
        } else {
            return SPNetWorkStatusUnknown;
        }
    }

    return returnValue;
}

- (void)stopNotifier
{
    if (_reachabilityRef != NULL)
    {
        SCNetworkReachabilityUnscheduleFromRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    }
}

- (void)dealloc
{
    [self stopNotifier];
    if (_reachabilityRef != NULL)
    {
        CFRelease(_reachabilityRef);
    }
}


@end
