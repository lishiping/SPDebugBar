//
//  SPDebugVC.h
//  SPDebugBar
//
//  Created by shiping li on 2018/3/9.
//  Copyright © 2018年 lishiping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPServerListVC.h"

@interface SPDebugVC : UIViewController

@property(nonatomic,copy)NSArrayResultBlock selectServerArrayBlock;//选择地址后回调
@property (strong, nonatomic) NSArray *tempserverArr;//给定的服务器地址数组

@end
