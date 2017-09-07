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


/**
 Set up the environment,help developers and testers switch server address in the debug mode or the test package,debug the program
 
 1. The functions of this tool: in a given switching between the address of the server, and back to the selected address by block for developers and testers can switch the server address when using the APP widgets.
 
 2. The application to start, check the server address is correct, if not correct, return an error.
 
 3. The application starts, before returning to local saved before the selected address (the default option for the first time in each group first)
 
 4. After the application can grow according to debug the popup switch by selecting address list.
 
 5. After the popup list, also can click on the selected green one server address, actual it is UItextfield that can input, online press enter, you can manually add a new server address, at the same time, the current input the list to join this group.
 
 6. Click the debug debugging to hide and display text (debug message is CPU and memory,FPS usage.)
 
 7. When received memory warning debug will change color.
 
 8. If you add the address of too many, can remove manually enter the additional address, back to the given address list.
 
 9. This little tool can be given more set in advance the address of the server, a set of three groups of the two groups can, such as convenient and different business interface using multiple service address, if group number has changed, the data reset, all previously entered manually add do not retain, and application has just started to return to take each group first.
 
 10.Method of use, such as:
 
 设置环境，帮助开发者和测试者在debug模式下或者测试包上切换服务器地址，调试程序
 
 1.本工具的功能作用：在给定的服务器地址间切换，并且通过block返回选中的地址方便开发者和测试人员在使用APP的时候可以切换服务器地址的小工具。
 
 2.应用开始启动的时候，检查服务器地址是否正确，如果不正确，返回错误。
 
 3.应用开始启动，返回本地保存的之前选中的地址（第一次默认选择每组的第一个）,如果给定地址有变化，则全部重置，并返回每组第一个
 
 4.应用启动之后可以长按调试条弹出地址列表进行选择切换。
 
 5.弹出列表之后，也可以点击绿色被选中的那条服务器地址，实际是UItextfield可以在线输入，回车，就可以手动加入一条新的服务器地址，同时把当前输入的这条加入到该组的列表中。
 
 6.单击调试条隐藏和显示调试条信息（调试条信息是CPU，内存，FPS的使用情况）
 
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
 NSLog(@"select server address：%@",objects);
 }];
 
 }
 else
 NSLog(@"select server address：%@",objects);
 
 //set up online server address
 //设置线上正式服地址
 
 #endif
 }
 
 */

#import <UIKit/UIKit.h>
#import "SPServerListVC.h"

typedef void (^SPArrayResultBlock)(NSArray* objects, NSError* error);

@interface SPDebugBar : UIWindow

/**
 Singleton, debugbar of default on the top right corner
 Singleton单例，调试条默认放在右上角
 @param serverArray      Given the address of the server list(给定服务器地址列表)
 @param selectArrayBlock Returns the selected server address, the first array element is given the address of the server are to be selected the first set of array elements, the second for a given inside the second group is selected in the address of the server, and so on
 (返回选中的服务器地址，数组元素的第一个是给定的服务器地址第一组里面被选中的，数组元素第二个为给定服务器地址中第二组里面被选中的，以此类推)，error返回错误原因，给定地址有错误
 */
+ (id)sharedInstanceWithServerArray:(NSArray*)serverArray  SelectArrayBlock:(SPArrayResultBlock)selectArrayBlock;

/**
 Singleton, the method can custom debugbar of the position
 singleton单例，该方法可以自定义调试条的位置
 */
+ (id)sharedInstanceWithFrame:(CGRect)frame ServerArray:(NSArray*)serverArray  SelectArrayBlock:(SPArrayResultBlock)selectArrayBlock;

@end
