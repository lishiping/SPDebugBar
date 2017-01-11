//
//  SPServerListVC.h
//  e-mail:83118274@qq.com
//  Created by lishiping on 16/9/19.
//  Copyright © 2016年 lishiping. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SPServerBaseVC.h"

#define DEBUGSERVERLIST @"SPServerList"
#define SELECTSERVERLIST @"SPSelectServerList"

typedef void (^NSArrayResultBlock)(NSArray* array);

@interface SPServerListVC : SPServerBaseVC

@property(nonatomic,copy)NSArrayResultBlock selectServerArrayBlock;
@property (copy, nonatomic) NSArray *tempserverArr;//给定的服务器地址数组

/**
 获得已经选中的服务地址，如果第一次启动，没有选择过，则返回每组的第一个，如果有本地缓存，则返回本地缓存服务地址

 @param serverArr 给定的服务地址列表

 @return 返回选择的
 */
+(NSArray *)getSelectArrayWithServerArray:(NSArray*)serverArr;

@end
