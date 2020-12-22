//
//  AppDelegate.m
//  SPDebugBar
//
//  Created by lishiping on 17/1/4.
//  Copyright © 2017年 lishiping. All rights reserved.
//

#import "AppDelegate.h"
#import "SPDebugBar.h"
#import "ViewController.h"
#import "ABTestVC.h"

@interface AppDelegate ()

@property(nonatomic,strong)ViewController *topVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //获取系统配置的是否是测试包
    _TEST = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"TEST"];
    //加载调试工具
    [self loadDebugTool];
    
    [application setStatusBarHidden:NO];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    _topVC= [[ViewController alloc] init];
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:_topVC];
    
    self.window.rootViewController =navi;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

//加载调试工具
-(void)loadDebugTool
{
    //当debug和打测试包的时候为了测试人员切换服务器调试，调试工具要显示，线上包的时候该调试工具不显示
    if (_TEST||DEBUG)
    {
        NSDictionary* serverDic = @{
                                    SP_TITLE_KEY:@"百度服务器地址",
                                    SP_ARRAY_KEY: @[
                                            @"https://api.baidu.com",
                                            @"http://api.baidu.com",
                                            @"http://api.ceshi.baidu.com"
                                            ]
                                    };
        
        NSDictionary *panServerDic = @{
                                       SP_TITLE_KEY:@"百度网盘地址",
                                       SP_ARRAY_KEY: @[
                                               @"https://api.pan.baidu.com",
                                               @"http://api.pan.baidu.com",
                                               @"http://api.ceshi.pan.baidu.com",
                                               @"http://api.test.pan.baidu.com"
                                               ]};
        
        NSDictionary *imServerDic = @{
                                      SP_TITLE_KEY:@"百度聊天地址",
                                      SP_ARRAY_KEY: @[
                                              @"https://api.pan.baidu.com",
                                              @"http://api.pan.baidu.com",
                                              @"http://api.ceshi.pan.baidu.com",
                                              @"http://api.test.pan.baidu.com"
                                              ]};
        
        NSArray *serverArray = [NSArray arrayWithObjects:serverDic,panServerDic,imServerDic, nil];
        
        NSDictionary* secondDic = @{
                                    SP_TITLE_KEY:@"灰度功能",
                                    SP_ARRAY_KEY: @[
                                            @"ABTestSDK",
                                            @"AB放量"
                                            ]
                                    };
        
        NSDictionary *thirdDic = @{
                                       SP_TITLE_KEY:@"商业化功能",
                                       SP_ARRAY_KEY: @[
                                               @"商业放量",
                                               @"商业灰度"
                                               ]};
        
        NSArray *otherArray = [NSArray arrayWithObjects:secondDic,thirdDic, nil];
        
        [SPDebugBar sharedInstanceWithServerArray:serverArray selectedServerArrayBlock:^(NSArray *objects, NSError *error) {
            NSLog(@"选中的服务器地址：%@",objects);
            _topVC.firstLabel.text =[NSString stringWithFormat:@"百度服务器地址:%@",objects[0]];
            _topVC.secondLabel.text =[NSString stringWithFormat:@"百度网盘地址:%@",objects[1]];
            
        } otherSectionArray:otherArray otherSectionArrayBlock:^(UINavigationController *navigationController,NSString *string, NSError *error) {
            _topVC.thirdLabel.text =[NSString stringWithFormat:@"你点击了:%@",string];
            
            ABTestVC *abTestVC = [[ABTestVC alloc] init];
            abTestVC.title = string;
            
            [navigationController pushViewController:abTestVC animated:YES];
        }];
        [SPDebugBar startPingAddress:@"ccp.koolearn.com"];
    }
    else
    {
        //set up online server address
        //设置线上地址
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
