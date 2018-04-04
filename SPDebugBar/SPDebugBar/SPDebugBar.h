//
//  SPDebugBar.h
//  e-mail:83118274@qq.com
//  Created by lishiping on 16/9/19.
//  Copyright © 2016年 lishiping. All rights reserved.
//
//If you think this open source library is of great help to you, please open the URL to click the Star,your approbation can encourage me, the author will publish the better open source library for guys again
//如果您认为本开源库对您很有帮助，请打开URL给作者点个赞，您的认可给作者极大的鼓励，作者还会发布更好的开源库给大家

//github address//https://github.com/lishiping/SPWebView
//github address//https://github.com/lishiping/SPDebugBar
//github address//https://github.com/lishiping/SPFastPush
//github address//https://github.com/lishiping/SPMacro
//github address//https://github.com/lishiping/SafeData
//github address//https://github.com/lishiping/SPCategory
//github address//https://github.com/lishiping/SPBaseClass

//v1.0.0正式版加入修改NSUserDefaults，添加自定义组件功能
/**
 Switch the server address, help develop and test the switch server address in debug mode or test package, help modify and reset the NSUserDefaults debugger, and add custom component functionality.
 
 1. The functions of this tool: in a given switching between the address of the server, and back to the selected address by block for developers and testers can switch the server address when using the APP widgets.
 
 2. When the application starts to start, check if the given server address is correct, and if not, return the error.
 
 3. The application starts, before returning to locally to save the selected address (the default option for the first time in each group first), if the given address have change, all are reset, and returns the first in each group
 
 4. After the application is started, you can choose to switch by pressing the debug bar pop-up address list.
 
 5. After the popup list, also can click on the currently selected in the black box of the server address, actual it is UItextfield that can input, online press enter, you can manually add a new server address, at the same time, the current input the list to join this group.
 
 6. Click the debug bar to hide and display the debug bar information (the debug bar information is CPU, memory, and FPS usage)
 
 The debug bar will change color when you receive a memory alert.
 
 8. If you add too many addresses, you can remove the added address manually and restore it to a given address list.
 
 9. This little tool can be given more set in advance the address of the server, a set of three groups of the two groups can, such as convenient and different business interface using multiple service address, if group number has changed, the data reset, all previously entered manually add do not retain, and application has just started to return to take each group first.
 
 10. New addition of v1.0.0 can modify NSUserDefaults, and new additions can allow users to customize adding features.
 
 11.Method of use, such as:
 
 切换服务器地址，帮助开发和测试在debug模式下或者测试包上切换服务器地址，帮助修改和重置NSUserDefaults调试程序,以及可以添加自定义组件功能
 
 1.本工具的功能作用：在给定的服务器地址间切换，并且通过block返回选中的地址方便开发者和测试人员在使用APP的时候可以切换服务器地址的小工具。
 
 2.应用开始启动的时候，检查给定服务器地址是否正确，如果不正确，返回错误。
 
 3.应用开始启动，返回本地保存的之前选中的地址（第一次默认选择每组的第一个）,如果给定地址有变化，则全部重置，并返回每组第一个
 
 4.应用启动之后可以长按调试条弹出地址列表进行选择切换。
 
 5.弹出列表之后，也可以点击黑框内当前选中的那条服务器地址，实际是UItextfield可以在线输入，回车，就可以手动加入一条新的服务器地址，同时把当前输入的这条加入到该组的列表中。
 
 6.单击调试条隐藏和显示调试条信息（调试条信息是CPU，内存，FPS的使用情况）
 
 7.当收到内存警告的时候调试条会变色。
 
 8.如果添加的地址太多了，可以清除手动输入增加的地址，恢复成给定的地址列表。
 
 9.本小工具可以预先给定多组服务器地址，一组两组三组等都可以，方便不同业务接口使用多个服务地址，如果组数有变动，则数据全部重置，之前手动输入添加的不保留，而且应用刚启动时返回的取每组第一个。
 
 10.v1.0.0新加入功能，可以修改NSUserDefaults，新增加可以让使用者自定义添加功能
 
 111.使用方法，例如：
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
 }
 else
 {
 //set up online server address
 //设置线上地址
 }
 }

 
 */

#import <UIKit/UIKit.h>
#import "SPDebugBaseVC.h"

@interface SPDebugBar : UIWindow

/**
 Singleton, debugbar of default on the top right corner
 Singleton单例，调试条默认放在右上角
 @param serverArray      Given the address of the server list(给定服务器地址列表)
 @param selectedServerArrayBlock Returns the selected server address, the first array element is given the address of the server are to be selected the first set of array elements, the second for a given inside the second group is selected in the address of the server, and so on
 (返回选中的服务器地址，数组元素的第一个是给定的服务器地址第一组里面被选中的，数组元素第二个为给定服务器地址中第二组里面被选中的，以此类推)，error返回错误原因，给定地址有错误
 */
+ (id)sharedInstanceWithServerArray:(NSArray*)serverArray
           selectedServerArrayBlock:(SPArrayResultBlock)selectedServerArrayBlock
                  otherSectionArray:(NSArray *)otherSectionArray
             otherSectionArrayBlock:(SPNavigationStringErrorBlock)otherSectionArrayBlock;

/**
 Singleton, the method can custom debugbar of the position
 singleton单例，该方法可以自定义调试条的位置
 */
+ (id)sharedInstanceWithFrame:(CGRect)frame
                  ServerArray:(NSArray*)serverArray
     selectedServerArrayBlock:(SPArrayResultBlock)selectedServerArrayBlock
            otherSectionArray:(NSArray *)otherSectionArray
       otherSectionArrayBlock:(SPNavigationStringErrorBlock)otherSectionArrayBlock;

@end
