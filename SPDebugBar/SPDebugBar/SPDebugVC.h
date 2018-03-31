//
//  SPDebugVC.h
//  SPDebugBar
//
//  Created by shiping li on 2018/3/9.
//  Copyright © 2018年 lishiping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPDebugBaseVC.h"
#import "SPServerListVC.h"

@interface SPDebugVC : SPDebugBaseVC

@property (strong, nonatomic) NSArray *tableArr;//服务器地址数组
@property (copy, nonatomic) NSIndexPathResultBlock tableBlock; //调试工具自定义传进来的数组名字列表回调

@end
