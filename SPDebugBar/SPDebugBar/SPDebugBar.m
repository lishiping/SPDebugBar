//
//  SPDebugBar.m
//  e-mail:83118274@qq.com
//  Created by lishiping on 16/9/19.
//  Copyright © 2016年 lishiping. All rights reserved.
//

#import "SPDebugBar.h"
#import "UIDevice-SPHardware.h"
#import "SPDebugVC.h"
#import "SPServerListVC.h"
#import "SPNSUserDefaultsVC.h"
#import "LSPCleanVC.h"
#import "SPPingServices.h"
#import "SPAppInfoHelper.h"
#import "SPNetWorkReachability.h"

#define SP_ChangeAddress_KEY SP_LANGUAGE_IS_CHINESE? @"切换服务器" : @"Change Server"
#define SP_ChangeNSUserDefaults_KEY SP_LANGUAGE_IS_CHINESE? @"修改NSUserDefaults":@"Change NSUserDefaults"//服务器列表每组的名称键值
#define SP_Clean_KEY SP_LANGUAGE_IS_CHINESE? @"清理工具箱":@"Clean Box"

@interface SPDebugBar ()

@property (strong, nonatomic) UILabel* tipLabel;//显示标签
//@property (strong, nonatomic) NSTimer* monitorTimer;//计时器
@property (strong, nonatomic) NSArray *serverArray;//预给定服务器列表
@property (copy, nonatomic) SPArrayResultBlock selectedServerArrayBlock; //选择的服务地址回调
@property (assign, nonatomic) NSUInteger isStartWarningNum;

@property (strong, nonatomic) NSArray *otherSectionArray;//调试工具自定义传进来的数组名字列表
@property (copy, nonatomic) SPNavigationStringErrorBlock otherSectionArrayBlock; //调试工具自定义传进来的数组名字列表回调

@property (atomic,copy)NSString *pingAddress;//ping地址
@property (atomic,copy)NSString *pingString;//延迟时间,毫秒
@property (nonatomic, strong) SPPingServices *pingService;

@end

@implementation SPDebugBar

#pragma mark - shareInstance
static SPDebugBar* instance = nil;
static SPPingServices *pingService = nil;
+ (id)sharedInstanceWithServerArray:(NSArray*)serverArray
           selectedServerArrayBlock:(SPArrayResultBlock)selectedServerArrayBlock
                  otherSectionArray:(NSArray *)otherSectionArray
             otherSectionArrayBlock:(SPNavigationStringErrorBlock)otherSectionArrayBlock
{
    CGRect frame = CGRectMake(0, 33, [UIScreen mainScreen].bounds.size.width, 20);
    return [self sharedInstanceWithFrame:frame ServerArray:serverArray selectedServerArrayBlock:selectedServerArrayBlock otherSectionArray:otherSectionArray otherSectionArrayBlock:otherSectionArrayBlock];
}

+ (id)sharedInstanceWithFrame:(CGRect)frame
                  ServerArray:(NSArray*)serverArray
     selectedServerArrayBlock:(SPArrayResultBlock)selectedServerArrayBlock
            otherSectionArray:(NSArray *)otherSectionArray
       otherSectionArrayBlock:(SPNavigationStringErrorBlock)otherSectionArrayBlock
{
    SPDebugBar *sharedInstance =  [[self class] sharedInstanceWithFrame:frame];
    [sharedInstance configServerArray:serverArray selectedServerArrayBlock:selectedServerArrayBlock];
    sharedInstance.otherSectionArray = otherSectionArray;
    sharedInstance.otherSectionArrayBlock = otherSectionArrayBlock;
    return sharedInstance;
}

+(void)startPingAddress:(NSString *)address
{
    if (!instance || address.length == 0) {
        return;
    }
    instance.pingAddress = address;
    [instance startPing];
}

+(void)show
{
    if (instance) {
        instance.hidden = NO;
    }
}

+(void)hide
{
    if (instance) {
        instance.hidden = YES;
    }
}
#pragma mark - init

+ (id)sharedInstanceWithFrame:(CGRect)frame
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] initWithFrame:frame];
        [instance setRootViewController:[SPDebugBaseVC new]]; //Xcode7之后的版本必须设置rootViewController
    });
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)dealloc
{
    [self unregisterLLAppInfoHelperNotification];
}
-(void)initialize
{
    _pingString = @"not Start";
    _isStartWarningNum =0;
    
    //UIWindowLevel级别高于状态栏，这样才能显示在状态栏之上
    self.windowLevel = UIWindowLevelStatusBar + 1.0;
    self.backgroundColor = [UIColor clearColor];
    
    //文字提示label,显示cpu和内存使用情况
    _tipLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _tipLabel.userInteractionEnabled = NO;
    _tipLabel.backgroundColor = [UIColor blackColor];
    _tipLabel.textColor = [UIColor greenColor];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.font = [UIFont systemFontOfSize:8];
    [self addSubview:_tipLabel];
    
    //添加长按手势弹出配置界面
    UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(presentDebugVC)];
    [self addGestureRecognizer:longPressGesture];
    
    //添加双击手势隐藏和显示页面
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHiddenDebugStatusBar)];
    tapGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tapGesture];
    
    //双指点击重新ping
    UITapGestureRecognizer* doubleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startPing)];
    doubleGesture.numberOfTouchesRequired = 2;
    [self addGestureRecognizer:doubleGesture];
    
    UITapGestureRecognizer* threeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopPing)];
    threeGesture.numberOfTouchesRequired = 3;
    [self addGestureRecognizer:threeGesture];
    
    //收到内存警告时调试条背景变色
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarningTip:) name:@"UIApplicationDidReceiveMemoryWarningNotification" object:nil];
    
    //开始监听设备，获取活动消息
    self.hidden = NO;
    [[SPAppInfoHelper shared] setEnable:YES];
    [self updateDynamicData];
    [self registerLLAppInfoHelperNotification];
}

-(void)updateDynamicData
{
    NSString *total = [NSByteCountFormatter stringFromByteCount:[[UIDevice currentDevice] totalMemoryBytes] countStyle:NSByteCountFormatterCountStyleFile];
    
    NSMutableString *mstr = [[NSMutableString alloc] initWithString:@""];
    for (NSDictionary *dic in [[SPAppInfoHelper shared] dynamicInfos]) {
        if ([dic.allKeys.firstObject isEqualToString:@"Memory"]) {
            [mstr appendFormat:@" %@ %@/%@",dic.allKeys.firstObject,dic.allValues.firstObject,total];
        }
        else if ([dic.allKeys.firstObject isEqualToString:@"Speed"]) {
            [mstr appendFormat:@" %@",dic.allValues.firstObject];
        }
        else{
            [mstr appendFormat:@" %@ %@",dic.allKeys.firstObject,dic.allValues.firstObject];
        }
    }
    
    if (_pingString.length>0) {
        [mstr appendString:_pingString];
    }
    
    _tipLabel.text = mstr;
}

#pragma mark - LLAppInfoHelperNotification
- (void)registerLLAppInfoHelperNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLLAppInfoHelperDidUpdateAppInfosNotification:) name:LLAppInfoHelperDidUpdateAppInfosNotificationName object:nil];
}

- (void)unregisterLLAppInfoHelperNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LLAppInfoHelperDidUpdateAppInfosNotificationName object:nil];
}

- (void)didReceiveLLAppInfoHelperDidUpdateAppInfosNotification:(NSNotification *)notification {
    [self updateDynamicData];
}

#pragma mark - events

//收到内存警告，启动动画
- (void)didReceiveMemoryWarningTip:(NSNotification*)noti
{
    _isStartWarningNum = 1;
}

//内存警告时候，调试条动画闪烁
-(void)tipLabelAnimation
{
    [UIView animateWithDuration:0.5f animations:^{
        self.tipLabel.backgroundColor = [UIColor whiteColor];
    } completion:^(BOOL finished) {
        self.tipLabel.backgroundColor = [UIColor redColor];
    }];
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

-(void)startPing
{
    if (_pingAddress.length>0) {
        __weak typeof(self) weakSelf = self;
        self.pingService = [SPPingServices startPingAddress:_pingAddress callbackHandler:^(SPPingItem *pingItem, NSArray *pingItems) {
            if (pingItem.status != SPPingStatusFinished) {
                NSLog(@"网络延迟  %.3fms", pingItem.timeMilliseconds);
    //            延迟时间,毫秒
                weakSelf.pingString = [NSString stringWithFormat:@" delay %.1fms",pingItem.timeMilliseconds];
            }else {
                NSLog(@"%@", [SPPingItem statisticsWithPingItems:pingItems]);
                weakSelf.pingString = @" delay finish";
            }
        }];
    }
}

-(void)stopPing
{
    if (self.pingService) {
        [self.pingService cancel];
        self.pingService = nil;
    }
}

#pragma mark - 配置服务器地址
-(void)configServerArray:(NSArray *)serverArray selectedServerArrayBlock:(SPArrayResultBlock)selectedServerArrayBlock
{
    self.serverArray = serverArray;
    self.selectedServerArrayBlock = selectedServerArrayBlock;
    //检查服务器地址数组是否合法
    if ([SPServerListVC checkArray:serverArray]) {
        //服务器地址合法返回本地缓存选择过得地址，没有选择过得地址，默认选择每一组的第一个作为该组的选中地址
        NSArray *selectArr =[SPServerListVC getSelectArrayWithServerArray:serverArray];
        
        if (self.selectedServerArrayBlock && selectArr.count>0) {
            self.selectedServerArrayBlock(selectArr,nil);
        }
    }
    else
    {
        //如果地址不合法，返回错误信息
        if (self.selectedServerArrayBlock) {
            self.selectedServerArrayBlock(nil,[NSError errorWithDomain:SP_LANGUAGE_IS_CHINESE? @"url必须是字符串类型" : @"url is illegal，url must Be NSString" code:-2 userInfo:nil]);
            self.selectedServerArrayBlock = nil;
        }
    }
}

#pragma mark - 弹出调试工具栏
//弹出配置页面
- (void)presentDebugVC
{
    self.tipLabel.hidden= NO;
    
    UIViewController *rootVC = [[self class] mainWindow].rootViewController;
    if ([rootVC presentedViewController]) {
        return;
    }
    
    //弹出调试工具栏
    SPDebugVC* debugVC = [[SPDebugVC alloc] init];
    
    NSDictionary *dic =@{
                         SP_TITLE_KEY:@"第三方自带功能(不断更新中)",
                         SP_ARRAY_KEY: @[SP_ChangeAddress_KEY,SP_ChangeNSUserDefaults_KEY,SP_Clean_KEY]};
    NSMutableArray *marr = [NSMutableArray arrayWithObject:dic];
    
    //调试工具栏头部留给自带功能
    [marr addObjectsFromArray:self.otherSectionArray];
    
    debugVC.tableArr = marr;
    
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:debugVC];
    [rootVC presentViewController:navigationController animated:NO completion:nil];

    //tableview点击回调
    debugVC.tableBlock = ^(NSIndexPath *indexPath)
    {
        NSDictionary *dic = [marr objectAtIndex:indexPath.section];
        NSArray *array = [dic objectForKey:SP_ARRAY_KEY];
        NSString *string =[array objectAtIndex:indexPath.row];
        
        //自带切换服务器功能
        if ([string isEqualToString:SP_ChangeAddress_KEY])
        {
            //弹出配置页面
            SPServerListVC* serverListVC = [[SPServerListVC alloc] init];
            serverListVC.tempserverArr =self.serverArray;
            serverListVC.selectServerArrayBlock = self.selectedServerArrayBlock;
            [navigationController pushViewController:serverListVC animated:YES];
        }
        //自带更改NSUserDefaults功能
        else if ([string isEqualToString:SP_ChangeNSUserDefaults_KEY])
        {
            SPNSUserDefaultsVC *userDefaultsVC = [[SPNSUserDefaultsVC alloc] init];
            [navigationController pushViewController:userDefaultsVC animated:YES];
        }
        //清理工具箱功能
        else if ([string isEqualToString:SP_Clean_KEY])
        {
            LSPCleanVC *cleanVC = [[LSPCleanVC alloc] init];
            [navigationController pushViewController:cleanVC animated:YES];
        }
        else
        {
            if (self.otherSectionArrayBlock)
            {
                if (string.length>0 && navigationController) {
                    self.otherSectionArrayBlock(navigationController,string, nil);
                }else
                {
                    self.otherSectionArrayBlock(navigationController,string, [NSError errorWithDomain:@"字符串为空" code:-2 userInfo:nil]);
                }
            }
        }
    };
}

+ (UIWindow*)mainWindow
{
    UIWindow *window = nil;
    
    UIApplication *app  = [UIApplication sharedApplication];
    
    if ([app.delegate respondsToSelector:@selector(window)]) {
        window = [app.delegate window];
    }
    
    if (!window) {
        if ([app windows].count>0)
        {
            window = [[app windows] objectAtIndex:0];
        }
    }
    
    if (!window) {
        window = [UIApplication sharedApplication].keyWindow;
    }
    
    return window;
}

@end
