//
//  SPServerListVC.h
//  e-mail:83118274@qq.com
//  Created by lishiping on 16/9/19.
//  Copyright © 2016年 lishiping. All rights reserved.
//
//If you think this open source library is of great help to you, please open the URL to click the Star,your approbation can encourage me, the author will publish the better open source library for guys again
//如果您认为本开源库对您很有帮助，请打开URL给作者点个赞，您的认可给作者极大的鼓励，作者还会发布更好的开源库给大家

//github address//https://github.com/lishiping/SPWebView
//github address//https://github.com/lishiping/SPDebugBar
//github address//https://github.com/lishiping/SPFastPush
//github address//https://github.com/lishiping/SPMacro
//github address//https://github.com/lishiping/SafeData
//github address//https://github.com/lishiping/SPCategory
//github address//https://github.com/lishiping/SPBaseClass

#import <UIKit/UIKit.h>
#import "SPDebugBaseVC.h"

#define SP_GIVENSERVERLIST @"SPGivenServerList"//给定的服务器地址缓存
#define SP_ALLSERVERLIST @"SPAllServerList"//所有服务器地址缓存
#define SP_SELECTSERVERLIST @"SPSelectServerList"//选择的服务器地址缓存

@interface SPServerListVC : SPDebugBaseVC

@property(nonatomic,copy)SPArrayResultBlock selectServerArrayBlock;//选择地址后回调
@property (strong, nonatomic) NSArray *tempserverArr;//给定的服务器地址数组


//检查给定服务器地址是否合法,只检查了字符串，没检查url地址的正则表达式
+(BOOL)checkArray:(NSArray*)serverArr;

/**
 获得已经选中的服务地址，如果第一次启动，没有选择过，则返回每组的第一个，如果有本地缓存，则返回本地缓存服务地址
 如果给定地址有变化，则重置地址，并取每组第一个
 @param serverArr 给定的服务地址列表
 
 @return 返回选择的
 */
+(NSArray *)getSelectArrayWithServerArray:(NSArray*)serverArr;

@end
