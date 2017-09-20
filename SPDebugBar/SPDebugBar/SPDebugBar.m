//
//  SPDebugBar.m
//  e-mail:83118274@qq.com
//  Created by lishiping on 16/9/19.
//  Copyright © 2016年 lishiping. All rights reserved.
//

#import "SPDebugBar.h"
#import "UIDevice-SPHardware.h"

@interface SPDebugBar ()

@property (strong, nonatomic) UILabel* tipLabel;//显示标签
//@property (strong, nonatomic) NSTimer* monitorTimer;//计时器
@property (strong, nonatomic) NSArray *serverArray;//预给定服务器列表
@property (copy, nonatomic) SPArrayResultBlock selectArrayBlock; //选择的服务地址回调
@property (assign, nonatomic) NSUInteger isStartWarningNum;

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

+ (id)sharedInstanceWithServerArray:(NSArray *)serverArray SelectArrayBlock:(SPArrayResultBlock)selectArrayBlock
{
    CGFloat ScreenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    return [[self class] sharedInstanceWithFrame:CGRectMake(ScreenWidth-250, 0, 250, 20) ServerArray:serverArray SelectArrayBlock:selectArrayBlock];
}

+ (id)sharedInstanceWithFrame:(CGRect)frame ServerArray:(NSArray *)serverArray SelectArrayBlock:(SPArrayResultBlock)selectArrayBlock
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] initWithFrame:frame];
        [instance setRootViewController:[SPServerBaseVC new]]; // Xcode7 之后的版本 必须 设置rootViewController
        [instance configServerArray:serverArray selectArrayBlock:selectArrayBlock];
    });
    return instance;
}

#pragma mark - init
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
    UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(presentConfigPageVC)];
    [self addGestureRecognizer:longPressGesture];
    
    //添加单击手势隐藏和显示页面
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHiddenDebugStatusBar)];
    [self addGestureRecognizer:tapGesture];
    
    //收到内存警告时调试条背景变色
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarningTip:) name:@"UIApplicationDidReceiveMemoryWarningNotification" object:nil];
    
    self.screenUpdatesCount = 0;
    self.screenUpdatesBeginTime = 0.0f;
    self.averageScreenUpdatesTime = 0.017f;
}

-(void)configServerArray:(NSArray *)serverArray selectArrayBlock:(SPArrayResultBlock)selectArrayBlock
{
    self.serverArray = serverArray;
    self.selectArrayBlock = selectArrayBlock;
    
    //检查服务器地址数组是否合法
    if ([self checkArray:serverArray]) {
        //服务器地址合法返回本地缓存选择过得地址，没有选择过得地址，默认选择每一组的第一个作为该组的选中地址
        NSArray *selectArr =[SPServerListVC getSelectArrayWithServerArray:_serverArray];
        
        if (self.selectArrayBlock && selectArr.count>0) {
            self.selectArrayBlock([selectArr copy],nil);
        }
    }
    else
    {
        //如果地址不合法，返回错误信息
        if (self.selectArrayBlock) {
            self.selectArrayBlock(nil,[NSError errorWithDomain:@"url is illegal" code:-2 userInfo:nil]);
            self.selectArrayBlock = nil;
        }
    }
    
    //开始监听设备，获取活动消息
    [self startMonitorDevice];
}

#pragma mark - check
//检查给定服务器地址是否合法,只检查了字符串，没检查url地址的正则表达式
-(BOOL)checkArray:(NSArray*)serverArr
{
    BOOL ret = YES;
    if ([serverArr isKindOfClass:[NSArray class]] && serverArr.count>0) {
        for (NSArray *arr in serverArr) {
            if ([arr isKindOfClass:[NSArray class]] && arr.count>0) {
                for (NSString *serverUrl in arr) {
                    if (![serverUrl isKindOfClass:[NSString class]] || serverUrl.length<1) {
                        ret = NO;
                    }
                }
            }
            else
            {
                ret = NO;
            }
        }
    }
    else
    {
        ret = NO;
    }
    return ret;
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
    serverListVC.tempserverArr =self.serverArray;
    
    //页面选择回调地址
    __weak __typeof(self) weakSelf = self;
    serverListVC.selectServerArrayBlock = ^(NSArray *array){
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        if (strongSelf.selectArrayBlock && array.count>0) {
            strongSelf.selectArrayBlock([array copy],nil);
        }
    };
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:serverListVC];
    [vc presentViewController:navigationController animated:YES completion:nil];
}

//收到内存警告，启动动画
- (void)didReceiveMemoryWarningTip:(NSNotification*)noti
{
    _isStartWarningNum = 1;
}

//调试条动画
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
    
    //开始使用timer刷新，但是我想加入刷新fps功能，所以就得改成使用displayLink刷新
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


@end
