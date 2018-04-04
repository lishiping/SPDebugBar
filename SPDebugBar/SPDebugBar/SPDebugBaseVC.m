//
//  SPDebugBaseVC.m
//  e-mail:83118274@qq.com
//  Created by lishiping on 16/9/19.
//  Copyright © 2016年 lishiping. All rights reserved.
//


#import "SPDebugBaseVC.h"

@interface SPDebugBaseVC ()

@end

@implementation SPDebugBaseVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setBaseBarButtonItem];
}

-(void)setBaseBarButtonItem
{
    if (self.navigationController.viewControllers.count>1)
    {
        //返回按钮
        UIBarButtonItem *backlItem  = [[UIBarButtonItem alloc] initWithTitle:SP_LANGUAGE_IS_CHINESE? @"返回":@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        
        //关闭按钮
        UIBarButtonItem *closeItem  = [[UIBarButtonItem alloc] initWithTitle:SP_LANGUAGE_IS_CHINESE? @"关闭":@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
        
        [self.navigationItem setLeftBarButtonItems:@[backlItem,closeItem]];
    }
    else
    {
        //关闭按钮
        UIBarButtonItem *closeItem  = [[UIBarButtonItem alloc] initWithTitle:SP_LANGUAGE_IS_CHINESE? @"关闭":@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
        
        [self.navigationItem setLeftBarButtonItems:@[closeItem]];
    }
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

+(UIView *)tableFooterView
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UIView *tableFooterView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 400)];
    //author
    UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, width, 30)];
    authorLabel.textColor = [UIColor darkGrayColor];
    authorLabel.text = SP_LANGUAGE_IS_CHINESE? @"作者:李世平 邮箱:83118274@qq.com":@"Author:lishiping e-mail:83118274@qq.com";
    [authorLabel setFont:[UIFont systemFontOfSize:12]];
    authorLabel.textAlignment = NSTextAlignmentCenter;
    [tableFooterView addSubview:authorLabel];
    
    //version
    NSString *applicationVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *applicationBuild = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 220, width, 30)];
    versionLabel.textColor = [UIColor darkGrayColor];
    versionLabel.text = [NSString stringWithFormat:@"APP v%@  Build(%@)  iOS(%@)",applicationVersion,applicationBuild,systemVersion];
    [versionLabel setFont:[UIFont systemFontOfSize:12]];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [tableFooterView addSubview:versionLabel];
    
    return tableFooterView;
}

//// 竖屏
//- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED;
//{
//    return NO;
//}
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED;
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED;
//{
//    return UIInterfaceOrientationPortrait;
//}
//- (BOOL)prefersStatusBarHidden {
//    return NO;
//}
//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleDefault;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
