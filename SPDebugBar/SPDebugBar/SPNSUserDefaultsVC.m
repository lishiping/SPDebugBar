//
//  SPNSUserDefaultsVC.m
//  SPDebugBar
//
//  Created by shiping li on 2018/3/9.
//  Copyright © 2018年 lishiping. All rights reserved.
//

#import "SPNSUserDefaultsVC.h"

@interface SPNSUserDefaultsVC ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSArray *tableDataArr;//服务器地址数组
@property (strong, nonatomic) NSDictionary *userDefaultDic;//服务器地址数组

@end

@implementation SPNSUserDefaultsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"NSUserDefaults的key列表";
    self.view.backgroundColor = [UIColor whiteColor];
    [self addButtonItem];
    [self.view addSubview:self.tableView];
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - add button item
-(void)addButtonItem
{
    //返回按钮
    UIBarButtonItem *backlItem  = [[UIBarButtonItem alloc] initWithTitle:SP_LANGUAGE_IS_EN ? @"Back" : @"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    //关闭按钮
    UIBarButtonItem *closeItem  = [[UIBarButtonItem alloc] initWithTitle:SP_LANGUAGE_IS_EN ? @"Close" : @"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    
    [self.navigationItem setLeftBarButtonItems:@[backlItem,closeItem]];
    
    
    //添加按钮
    UIBarButtonItem *addItem  = [[UIBarButtonItem alloc] initWithTitle:SP_LANGUAGE_IS_EN ? @"Add" : @"添加" style:UIBarButtonItemStylePlain target:self action:@selector(add)];
    
    //清除按钮
    UIBarButtonItem *cleanItem  = [[UIBarButtonItem alloc] initWithTitle:SP_LANGUAGE_IS_EN ? @"Clean" : @"清除" style:UIBarButtonItemStylePlain target:self action:@selector(add)];
    
    
    [self.navigationItem setRightBarButtonItems:@[addItem,cleanItem]];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)add
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加一个键值对" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 101;
    [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    [alert textFieldAtIndex:0].placeholder =@"key";
    [alert textFieldAtIndex:1].placeholder =@"value";
    [alert textFieldAtIndex:1].secureTextEntry = NO;

    [alert show];
}

-(void)refreshData
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.tableDataArr = self.getUserDefaultDic.allKeys;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}
#pragma mark - init ServerArray
-(NSArray*)tableDataArr
{
    if (!_tableDataArr) {
//        _tableDataArr = self.getUserDefaultDic.allKeys;
        _tableDataArr =[[NSArray alloc] init];
    }
    return _tableDataArr;
}

-(NSDictionary*)getUserDefaultDic
{
    //        NSDictionary*dic =  [user volatileDomainForName:NSArgumentDomain];
    //        NSDictionary *dic2 = [user persistentDomainForName:@"com.36kr.SPDebugBar"];
    
    NSString *str =  [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Preferences"];
    NSString *string = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString *url = [str stringByAppendingPathComponent:string];
    NSString *path =[NSString stringWithFormat:@"%@.plist",url];
    _userDefaultDic = [NSDictionary dictionaryWithContentsOfFile:path];
    return _userDefaultDic;
}

#pragma mark - tableview
-(UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.sectionFooterHeight = 1.0f;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:
         NSStringFromClass([UITableViewCell class])];
        _tableView.tableFooterView = nil;
    }
    return _tableView;
}

#pragma mark - UITableView Delgate and Datasource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count =self.tableDataArr.count;
    return count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    NSString *text = [self.tableDataArr objectAtIndex:indexPath.row];
    cell.textLabel.text =text;
//    cell.textLabel.adjustsFontSizeToFitWidth = YES;
//
//    NSString *detail = [[NSUserDefaults standardUserDefaults] objectForKey:text];
//    cell.detailTextLabel.text =@"22";
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    //找到字符串
    NSString *key =[self.tableDataArr objectAtIndex:indexPath.row];
    NSObject *value = [_userDefaultDic objectForKey:key];
//
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:value.description delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alert show];
    
    //    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:key delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"重置" otherButtonTitles:@"修改", nil];
    //
    //    [sheet showInView:self.view];
    
    
    UIAlertController *spAlertVC = [UIAlertController alertControllerWithTitle:key message:value.description preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *resetAction = [UIAlertAction actionWithTitle:@"重置" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:key message:@"你想要重置当前key的值吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 102;
        [alert show];
        
    }];
    [spAlertVC addAction:resetAction];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:key message:@"修改值" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 103;
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        UITextField *valueField = [alert textFieldAtIndex:0];
        valueField.clearButtonMode = UITextFieldViewModeWhileEditing;
        valueField.placeholder = @"value";
        valueField.text = value.description;
        [alert show];
        
    }];
    [spAlertVC addAction:okAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [spAlertVC addAction:cancelAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:spAlertVC animated:YES completion:nil];
    });
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 160;
}

#pragma mark - alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //添加
    if (alertView.tag==101) {
        UITextField *key = [alertView textFieldAtIndex:0];
        UITextField *value = [alertView textFieldAtIndex:1];
        
        if (key.text.length>0&&value.text.length>0) {
            [[NSUserDefaults standardUserDefaults] setValue:value.text forKey:key.text];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self refreshData];
        }
    }
    //重置
    else if (alertView.tag==102)
    {
        //确认清除后添加的
        if (buttonIndex==1&&alertView.title.length>0)
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:alertView.title];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self refreshData];
        }
    }
    //修改
    else if (alertView.tag==103)
    {
        UITextField *value = [alertView textFieldAtIndex:0];
        if (alertView.title.length>0&&value.text.length>0) {
            [[NSUserDefaults standardUserDefaults] setValue:value.text forKey:alertView.title];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self refreshData];
        }
    }
}

@end
