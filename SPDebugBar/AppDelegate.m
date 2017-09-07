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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [application setStatusBarHidden:NO];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    ViewController *vc = [[ViewController alloc] init];
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    
    self.window.rootViewController =navi;
    
    [self.window makeKeyAndVisible];
    
    [self configServerUrl:vc];
    
    return YES;
}


-(void)configServerUrl:(ViewController*)vc
{
    
#if (DEBUG || TEST)
    {
        NSArray* serverArr = @[
                               @"https://api.baidu.com",
                               @"http://api.baidu.com",
                               @"http://api.ceshi.baidu.com"
                               ];
        
        NSArray *panServerArr = @[
                                  @"https://api.pan.baidu.com",
                                  @"http://api.pan.baidu.com",
                                  @"http://api.ceshi.pan.baidu.com",
                                  @"http://api.test.pan.baidu.com"
                                  ];
        
        NSArray *serverArray = [NSArray arrayWithObjects:serverArr,panServerArr, nil];
        
        [SPDebugBar sharedInstanceWithServerArray:serverArray SelectArrayBlock:^(NSArray *objects, NSError *error)
         {
             NSLog(@"选中的服务器地址：%@",objects);
             vc.firstStr =[NSString stringWithFormat:@"百度地址:%@",objects[0]] ;
             vc.sceondStr =[NSString stringWithFormat:@"百度盘地址:%@",objects[1]];
             [vc refreshLabel];
         }];
        
    }
    
#else
    
    //set up online server address
    //设置线上地址
    
#endif
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
