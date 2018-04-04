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

#define SP_ChangeAddress_KEY SP_LANGUAGE_IS_CHINESE? @"切换服务器" : @"Change Server"
#define SP_ChangeNSUserDefaults_KEY SP_LANGUAGE_IS_CHINESE? @"修改NSUserDefaults":@"Change NSUserDefaults"//服务器列表每组的名称键值

@interface SPDebugBar ()

@property (strong, nonatomic) UILabel* tipLabel;//显示标签
//@property (strong, nonatomic) NSTimer* monitorTimer;//计时器
@property (strong, nonatomic) NSArray *serverArray;//预给定服务器列表
@property (copy, nonatomic) SPArrayResultBlock selectedServerArrayBlock; //选择的服务地址回调
@property (assign, nonatomic) NSUInteger isStartWarningNum;

@property (strong, nonatomic) NSArray *otherSectionArray;//调试工具自定义传进来的数组名字列表
@property (copy, nonatomic) SPNavigationStringErrorBlock otherSectionArrayBlock; //调试工具自定义传进来的数组名字列表回调


/****0.2.0加入刷新fps使用的****/
@property (nonatomic, strong) CADisplayLink *displayLink;//更精确的计时器
@property (nonatomic) int screenUpdatesCount;
@property (nonatomic) CFTimeInterval screenUpdatesBeginTime;
@property (nonatomic) CFTimeInterval averageScreenUpdatesTime;
@property  NSUInteger fps;

@end

@implementation SPDebugBar

#pragma mark - shareInstance
static SPDebugBar* instance = nil;

+ (id)sharedInstanceWithServerArray:(NSArray*)serverArray
           selectedServerArrayBlock:(SPArrayResultBlock)selectedServerArrayBlock
                  otherSectionArray:(NSArray *)otherSectionArray
             otherSectionArrayBlock:(SPNavigationStringErrorBlock)otherSectionArrayBlock
{
    CGRect frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds)-250, 0, 250, 20);
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
        // Initialization code
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    _isStartWarningNum =0;
    _screenUpdatesCount = 0;
    _screenUpdatesBeginTime = 0.0f;
    _averageScreenUpdatesTime = 0.017f;
    
    //UIWindowLevel级别高于状态栏，这样才能显示在状态栏之上
    self.windowLevel = UIWindowLevelStatusBar + 1.0;
    self.backgroundColor = [UIColor clearColor];
    
    //文字提示label,显示cpu和内存使用情况
    _tipLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _tipLabel.backgroundColor = [UIColor blackColor];
    _tipLabel.textColor = [UIColor greenColor];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:_tipLabel];
    
    //添加长按手势弹出配置界面
    UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(presentDebugVC)];
    [self addGestureRecognizer:longPressGesture];
    
    //添加单击手势隐藏和显示页面
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHiddenDebugStatusBar)];
    [self addGestureRecognizer:tapGesture];
    
    //收到内存警告时调试条背景变色
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarningTip:) name:@"UIApplicationDidReceiveMemoryWarningNotification" object:nil];
    
    //    //开始监听设备，获取活动消息
    [self startMonitorDevice];
}

#pragma mark - events
// 实时更新资源使用情况
- (void)refreshDeviceInfo
{
    if (_isStartWarningNum>0&&_isStartWarningNum<5) {
        _isStartWarningNum++;
        [self tipLabelAnimation];
    }else
    {
        _isStartWarningNum = 0;
        self.tipLabel.backgroundColor = [UIColor blackColor];
    }
    
    UIDevice* device = [UIDevice currentDevice];
    float cpu = [device cpuUsagePercentage];
    
    //CPU
    NSMutableString* cpuInfo = [NSMutableString stringWithFormat:@"CPU:"];
    [cpuInfo appendString:[NSString stringWithFormat:@"%.1f%% ", cpu*100]];
    
    //Memory
    NSString* memoryInfo = [NSString stringWithFormat:@"Memory:%.1fM/%.1fM", (double)[device usedMemoryBytes],(double)[device totalMemoryBytes] / 1024.0 / 1024.0];
    
    //FPS
    NSString* fpsInfo = [NSString stringWithFormat:@"FPS:%lu", (unsigned long)self.fps];
    
    _tipLabel.text = [NSString stringWithFormat:@"%@ %@ %@", cpuInfo,fpsInfo,memoryInfo];
}

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

//开始监听设备
- (void)startMonitorDevice
{
    self.hidden = NO;
    //
    //    _monitorTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(refreshDeviceInfo) userInfo:nil repeats:YES];
    //
    //    [[NSRunLoop mainRunLoop] addTimer:_monitorTimer forMode:NSRunLoopCommonModes];
    //
    //    [_monitorTimer fire];
    
    //之前使用timer刷新，但是我想加入刷新fps功能，所以就得改成使用displayLink刷新
    [self setupDisplayLink];
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

- (void)setupDisplayLink
{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)displayLinkAction:(CADisplayLink *)displayLink
{
    if (self.screenUpdatesBeginTime == 0.0f) {
        self.screenUpdatesBeginTime = displayLink.timestamp;
    } else {
        self.screenUpdatesCount += 1;
        
        CFTimeInterval screenUpdatesTime = self.displayLink.timestamp - self.screenUpdatesBeginTime;
        
        if (screenUpdatesTime >= 1.0)
        {
            CFTimeInterval updatesOverSecond = screenUpdatesTime - 1.0f;
            int framesOverSecond = updatesOverSecond / self.averageScreenUpdatesTime;
            
            self.screenUpdatesCount -= framesOverSecond;
            if (self.screenUpdatesCount < 0) {
                self.screenUpdatesCount = 0;
            }
            
            [self updateFPS];
        }
    }
}

- (void)updateFPS
{
    self.fps = self.screenUpdatesCount;
    self.screenUpdatesCount = 0;
    self.screenUpdatesBeginTime = 0.0f;
    
    [self refreshDeviceInfo];
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
    
    UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    if ([rootVC presentedViewController]) {
        return;
    }
    
    //弹出调试工具栏
    SPDebugVC* debugVC = [[SPDebugVC alloc] init];
    
    NSDictionary *dic =@{
                         SP_TITLE_KEY:@"第三方自带功能(不断更新中)",
                         SP_ARRAY_KEY: @[SP_ChangeAddress_KEY,SP_ChangeNSUserDefaults_KEY]};
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


@end
