//
//  SPDebugBaseVC.h
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

//判断是否是简体中文环境
#define SP_LANGUAGE_IS_CHINESE         [[[NSLocale preferredLanguages] objectAtIndex:0] isEqualToString:@"zh-Hans-US"]

#define SP_TITLE_KEY @"title"//服务器列表每组的名称键值
#define SP_ARRAY_KEY @"array"//服务器列表数组每组的键值

#import <UIKit/UIKit.h>

typedef void (^NSIndexPathResultBlock)(NSIndexPath* indexPath);
typedef void (^SPArrayResultBlock)(NSArray* objects, NSError *error);
typedef void (^SPNavigationStringErrorBlock)(UINavigationController *navigationController,NSString* string,NSError *error);

@interface SPDebugBaseVC : UIViewController

- (void)dismiss;

- (void)back;

+(UIView *)tableFooterView;

@end
