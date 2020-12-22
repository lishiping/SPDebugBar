//
//  SPPingServices.h
//  ApolloApi
//
//  Created by lishiping on 2020/8/17.
//  Copyright © 2020 新东方. All rights reserved.
//

//思想： 还是利用app  demo 中使用 simpleping  作为属性 去ping 实现其代理
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "SPSimplePing.h"

typedef NS_ENUM(NSInteger, SPPingStatus) {
    SPPingStatusDidStart,
    SPPingStatusDidFailToSendPacket,
    SPPingStatusDidReceivePacket,
    SPPingStatusDidReceiveUnexpectedPacket,
    SPPingStatusDidTimeout,
    SPPingStatusError,
    SPPingStatusFinished,
};

@interface SPPingItem : NSObject

//目标原地址
@property(nonatomic) NSString *originalAddress;
//目标ip地址   32个bit ip
@property(nonatomic, copy) NSString *IPAddress;
//数据长度
@property(nonatomic) NSUInteger dateBytesLength;
//回应时间
@property(nonatomic) double     timeMilliseconds;
//ttl请求生命周期，路由跳转  可以重这里看出 不同系统有默认值 - 当前这个ttl 就是路由周转跳数
@property(nonatomic) NSInteger  timeToLive;
//路由跳数
@property(nonatomic) NSInteger   tracertCount;
@property(nonatomic) NSInteger  ICMPSequence;

@property(nonatomic) SPPingStatus status;

+ (NSString *)statisticsWithPingItems:(NSArray *)pingItems;

@end

@interface SPPingServices : NSObject

/// 超时时间, default 500ms
@property(nonatomic) double timeoutMilliseconds;

+ (SPPingServices *)startPingAddress:(NSString *)address
                      callbackHandler:(void(^)(SPPingItem *pingItem, NSArray *pingItems))handler;

@property(nonatomic) NSInteger  maximumPingTimes;

- (void)cancel;

@end


//使用例子
//self.pingServices = [SPPingServices startPingAddress:@"要检测的域名" callbackHandler:^(SPPingItem *pingItem, NSArray *pingItems) {
//    if (pingItem.status != SPPingStatusFinished) {
//        NSLog(@"网络延迟  %.0fms", pingItem.timeMilliseconds);
//    }else {
//        //NSLog(@"%@", [SPPingItem statisticsWithPingItems:pingItems]);
//    }
//}];
//[self.pingServices cancel];
