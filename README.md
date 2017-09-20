
#pod 'SPDebugBar'                   

#Set up the environment,help developers and testers switch server address in the debug mode or the test package,debug the program.设置环境，帮助开发者和测试者在debug模式下或者测试包上切换服务器地址，调试程序,显示CPU,Memory,FPS

1. The functions of this tool: in a given switching between the address of the server, and back to the selected address by block for developers and testers can switch the server address when using the APP widgets.

2. The application to start, check the server address is correct, if not correct, return an error.

3. The application starts, before returning to local saved before the selected address (the default option for the first time in each group first)

4. After the application can grow according to debug the popup switch by selecting address list.

5. After the popup list, also can click on the selected green one server address, actual it is UItextfield that can input, online press enter, you can manually add a new server address, at the same time, the current input the list to join this group.

6. Click the debug debugging to hide and display text (debug message is CPU and memory usage.)

7. When received memory warning debug will change color.

8. If you add the address of too many, can remove manually enter the additional address, back to the given address list.

9. This little tool can be given more set in advance the address of the server, a set of three groups of the two groups can, such as convenient and different business interface using multiple service address, if group number has changed, the data reset, all previously entered manually add do not retain, and application has just started to return to take each group first.

10.Method of use, such as:

设置环境，帮助开发者和测试者在debug模式下或者测试包上切换服务器地址，调试程序

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

 [SPDebugBar sharedInstanceWithServerArray:serverArray SelectArrayBlock:^(NSArray *objects, NSError *error)
{
NSLog(@"选中的服务器地址：%@",objects);
}];

}

#else

  set up online server address
  设置线上地址

#endif
}



