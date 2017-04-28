//
//  SPServerListVC.h
//  e-mail:83118274@qq.com
//  Created by lishiping on 16/9/19.
//  Copyright © 2016年 lishiping. All rights reserved.
//

//If you feel the WebView open source is of great help to you, please give the author some praise, recognition you give great encouragement, the author also hope you give the author other open source libraries some praise, the author will release better open source library for you again
//如果您感觉本开源WebView对您很有帮助，请给作者点个赞，您的认可给作者极大的鼓励，也希望您给作者其他的开源库点个赞，作者还会再发布更好的开源库给大家

//github address//https://github.com/lishiping/SPWebView
//github address//https://github.com/lishiping/SPDebugBar
//github address//https://github.com/lishiping/SPFastPush
//github address//https://github.com/lishiping/SPMacro
//github address//https://github.com/lishiping/SafeData

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
