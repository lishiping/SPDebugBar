//
//  SPDebugBar.m
//  e-mail:83118274@qq.com
//  Created by lishiping on 16/9/19.
//  Copyright © 2016年 lishiping. All rights reserved.
//

#import "SPDebugBar.h"
#import "UIDevice-Hardware.h"

@interface SPDebugBar ()

@property (strong, nonatomic) UILabel* tipLabel;
@property (strong, nonatomic) NSTimer* monitorTimer;
@property (copy, nonatomic) NSArray *serverArray;
@property (copy, nonatomic) SPArrayResultBlock selectArrayBlock; //选择的服务地址回调

@end

@implementation SPDebugBar

static SPDebugBar* instance = nil;
+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        float ScreenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
        instance = [[[self class] alloc] initWithFrame:CGRectMake(ScreenWidth-250, 0, 250, 20)];
        [instance setRootViewController:[SPServerBaseVC new]]; // Xcode7 之后的版本 必须 设置rootViewController
    });
    return instance;
}

+ (id)sharedInstanceWithFrame:(CGRect)frame
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] initWithFrame:frame];
        [instance setRootViewController:[SPServerBaseVC new]]; // Xcode7 之后的版本 必须 设置rootViewController
    });
    return instance;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //UIWindowLevel级别高于状态栏，这样才能显示在状态栏之上
        self.windowLevel = UIWindowLevelStatusBar + 1.0;
        self.backgroundColor = [UIColor clearColor];
        
        //文字提示label,显示cpu和内存使用情况
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _tipLabel.backgroundColor = [UIColor blackColor];
        _tipLabel.textColor = [UIColor greenColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:_tipLabel];
        
        //添加长按手势弹出配置界面
        UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(presentConfigPageVC)];
        [self addGestureRecognizer:longPressGesture];
        
        //添加单击手势隐藏和显示页面
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHiddenDebugStatusBar)];
        [self addGestureRecognizer:tapGesture];
        
        //收到内存警告时调试条背景变色
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarningTip:) name:@"UIApplicationDidReceiveMemoryWarningNotification" object:nil];
        
        //获取设备信息
//        [self refreshDeviceInfo];
    }
    return self;
}

-(void)initwithServerArray:(NSArray *)serverArray selectArrayBlock:(SPArrayResultBlock)selectArrayBlock
{
    _serverArray = serverArray;
    _selectArrayBlock = selectArrayBlock;
    
    //检查服务器地址数组是否合法，如果不合法返回错误
    if (![self checkArray:serverArray]) {
        if (self.selectArrayBlock) {
            self.selectArrayBlock(nil,[NSError errorWithDomain:@"data is illegal" code:-2 userInfo:nil]);
            self.selectArrayBlock = nil;
        }
    }
    else
    {
        //服务器地址合法返回本地缓存选择过得地址，没有选择过得地址，默认选择每一组的第一个作为该组的选中地址
        NSArray *selectArr =[SPServerListVC getSelectArrayWithServerArray:_serverArray];
        
        if (self.selectArrayBlock&&selectArr.count>0) {
            self.selectArrayBlock([selectArr copy],nil);
        }
    }
    
    //开始监听设备，获取活动消息
    [self startMonitorDevice];
}

//检查给定服务器地址
-(BOOL)checkArray:(NSArray*)serverArr
{
    BOOL ret = YES;
    if ([serverArr isKindOfClass:[NSArray class]]&&serverArr.count>0) {
        for (NSArray *arr in serverArr) {
            if ([arr isKindOfClass:[NSArray class]]&&arr.count>0) {
                for (NSString *serverUrl in arr) {
                    if (![serverUrl isKindOfClass:[NSString class]]||serverUrl.length==0) {
                        ret = NO;
                    }
                }
            }
            else{
                ret =NO;
            }
        }
    }
    else
    {
        ret = NO;
    }
    return ret;
}

// 实时更新资源使用情况
- (void)refreshDeviceInfo
{
    UIDevice* device = [UIDevice currentDevice];
    NSArray* cpuUsage = [device cpuUsage];
    
    //CPU
    NSMutableString* cpuInfo = [NSMutableString stringWithFormat:@"CPU:"];
    for (NSNumber* cpu in cpuUsage) {
        [cpuInfo appendString:[NSString stringWithFormat:@"%.1f%% ", [cpu floatValue]]];
    }
    
    //Memory
    NSString* memoryInfo = [NSString stringWithFormat:@"Memory:%.1fM/%luM", (float)[device freeMemoryBytes] / 1024.0 / 1024.0,(unsigned long)[device totalMemoryBytes] / 1024 / 1024];
    
    _tipLabel.text = [NSString stringWithFormat:@"%@  %@", cpuInfo, memoryInfo];
}

//弹出配置页面
- (void)presentConfigPageVC
{
    self.tipLabel.hidden= NO;
    
    UIViewController *vc = [[UIApplication sharedApplication].delegate window].rootViewController;
    if ([vc presentedViewController]) {
        return;
    }
    
    //弹出配置页面
    SPServerListVC* serverListVC = [[SPServerListVC alloc] init];
    serverListVC.tempserverArr =_serverArray;
    
    __weak __typeof(self)weakSelf = self;
    serverListVC.selectServerArrayBlock = ^(NSArray *array){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if (strongSelf.selectArrayBlock) {
            strongSelf.selectArrayBlock([array copy],nil);
        }
    };
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:serverListVC];
    [vc presentViewController:navigationController animated:YES completion:nil];
}

//收到内存警告，调试条变色
- (void)didReceiveMemoryWarningTip:(NSNotification*)noti
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAutoreverse
                     animations:^{
                         self.tipLabel.backgroundColor = [UIColor orangeColor];
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             self.tipLabel.backgroundColor = [UIColor blackColor];
                         }
                     }];
}

//开始监听设备
- (void)startMonitorDevice
{
    self.hidden = NO;
    
    _monitorTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshDeviceInfo) userInfo:nil repeats:YES];
    [_monitorTimer fire];
}

//显示或隐藏Bar
- (void)showOrHiddenDebugStatusBar
{
    if (self.tipLabel.hidden) {
        self.tipLabel.hidden =NO;
    }
    else
    {
        self.tipLabel.hidden = YES;
    }
}

@end
