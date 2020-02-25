//
//  LSPCleanVC.m
//  SPDebugBar
//
//  Created by shiping li on 2018/3/9.
//  Copyright © 2018年 lishiping. All rights reserved.
//

#import "LSPCleanVC.h"

@interface LSPCleanVC ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSArray *tableDataArr;//数组

@end

@implementation LSPCleanVC

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SP_LANGUAGE_IS_CHINESE ?@"清理工具箱":@"Clean Box";
    self.view.backgroundColor = [UIColor whiteColor];
    _tableDataArr =@[@"清理NSHTTPCookie",@"清理磁盘Cookie缓存"];

    [self.view addSubview:self.tableView];
}

#pragma mark - tableview
-(UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:
         NSStringFromClass([UITableViewCell class])];
        //使用父类视图
        _tableView.tableFooterView = self.class.tableFooterView;
    }
    return _tableView;
}

#pragma mark - UITableView Delgate and Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count =self.tableDataArr.count;
    return count;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 100)];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, tableView.frame.size.width-40, 50)];
    label1.textColor = [UIColor redColor];
    label1.numberOfLines = 5;
    label1.font = [UIFont systemFontOfSize:12];
    label1.text = @"1.本功能是清理Webview的Cookie和清理磁盘缓存的";
    [view addSubview:label1];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    NSString *text = [self.tableDataArr objectAtIndex:indexPath.row];
    cell.textLabel.text =text?:@"";
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    //找到字符串
    NSString *key =[self.tableDataArr objectAtIndex:indexPath.row];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:key message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:SP_LANGUAGE_IS_CHINESE ?@"取消": @"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
      }];
      [alertVC addAction:cancelAction];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:SP_LANGUAGE_IS_CHINESE ?@"确定":@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (indexPath.row==0) {
            [self deleteCookiesStotage];
        }else if (indexPath.row==1){
            [self deleteCookiesFiles];
        }
      }];
      [alertVC addAction:okAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertVC animated:YES completion:nil];
    });
}

- (void)deleteCookiesFiles {
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
    NSError *errors;
    [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
}

- (void)deleteCookiesStotage {
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

@end
