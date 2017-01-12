
#pod 'SPDebugBar',                   # 加入SPDebugBar

#A tool to help developers and testers quickly switch the server address, convenient to debug the program.一个小工具帮助开发人员和测试人员快速切换服务器地址，方便调试程序，可以在debug模式下或者测试包上方便切换地址

/**
A tool to help developers and testers quickly switch the server address, convenient to debug the program.一个小工具帮助开发人员和测试人员快速切换服务器地址，方便调试程序，可以在debug模式下或者测试包上方便切换地址

1.本工具的功能作用：在给定的服务器地址间切换，并且通过block返回选中的地址方便开发者和测试人员在使用APP的时候可以切换服务器地址的小工具。

2.应用开始启动的时候，检查服务器地址是否正确，如果不正确，返回错误。

3.应用开始启动，返回之前本地保存的之前选中的地址（第一次默认选择每组的第一个）

4.应用启动之后可以长按活动调试条弹出地址列表进行选择切换。

5.弹出列表之后，也可以点击绿色被选中的那条服务器地址，实际是UItextfield可以在线输入，回车，就可以手动加入一条新的服务器地址，同时把当前输入的这条加入到该组的列表中。

6.单击调试条隐藏和显示调试条文字（调试条信息是CPU和内存使用情况）

7.当收到内存警告的时候调试条会变色。

8.如果添加的地址太多了，可以清除手动输入增加的地址，恢复成给定的地址列表。

9.本小工具可以预先给定多组服务器地址，一组两组三组等都可以，方便不同业务接口使用多个服务地址，如果组数有变动，则数据全部重置，之前手动输入添加的不保留，而且应用刚启动时返回的取每组第一个。

10.使用方法，例如：
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

[self configServerUrl];

}

//服务器地址配置方法
-(void)configServerUrl
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
@"http://api.ceshi.pan.baidu.com"
];

NSArray *serverArray = [NSArray arrayWithObjects:serverArr,panServerArr, nil];

[[SPDebugBar sharedInstance] initwithServerArray:serverArray selectArrayBlock:^(NSArray *objects, NSError *error){
NSLog(@"选中的服务器地址：%@",objects);
}];

}
#endif
}


@param serverArray      给定服务器地址列表
@param selectArrayBlock 返回选中的服务器地址，数组元素的第一个是给定的服务器地址第一组里面被选中的，数组元素第二个为给定服务器地址中第二组里面被选中的，以此类推
*/
