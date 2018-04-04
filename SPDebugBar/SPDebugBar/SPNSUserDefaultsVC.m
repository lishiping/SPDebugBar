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
@property (strong, nonatomic) NSArray *tableDataArr;//数组
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation SPNSUserDefaultsVC

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SP_LANGUAGE_IS_CHINESE ?@"NSUserDefaults的key列表":@"Allkeys of NSUserDefaults";
    self.view.backgroundColor = [UIColor whiteColor];
    [self addButtonItem];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.activityIndicatorView];
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - add button item
-(void)addButtonItem
{
    //添加按钮
    UIBarButtonItem *addItem  = [[UIBarButtonItem alloc] initWithTitle:SP_LANGUAGE_IS_CHINESE ?@"添加":@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(add)];
    
    [self.navigationItem setRightBarButtonItems:@[addItem]];
}

-(void)refreshData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.activityIndicatorView.hidden = NO;
        [self.activityIndicatorView startAnimating];
    });
    
    //延迟获取的原因是立即执行获取的数据不准确，比如移除的数据还存在
    [self performSelector:@selector(delayGetUserDefault) withObject:nil afterDelay:1.0f];
}

-(void)delayGetUserDefault
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        weakSelf.tableDataArr = [weakSelf.getUserDefaultDic allKeys];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            [weakSelf.activityIndicatorView stopAnimating];
        });
    });
}

#pragma mark - init ServerArray
-(NSArray*)tableDataArr
{
    if (!_tableDataArr) {
        _tableDataArr =[[NSArray alloc] init];
    }
    return _tableDataArr;
}

-(NSDictionary*)getUserDefaultDic
{
    NSString *str = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Preferences"];
    NSString *string = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString *url = [str stringByAppendingPathComponent:string];
    NSString *path =[NSString stringWithFormat:@"%@.plist",url];
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

#pragma mark - activityIndicatorView
-(UIActivityIndicatorView*)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0,50, 50)];
        _activityIndicatorView.center =self.view.center;
        _activityIndicatorView.hidden = YES;
        _activityIndicatorView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        _activityIndicatorView.layer.cornerRadius = 4;
        _activityIndicatorView.layer.masksToBounds =YES;
        _activityIndicatorView.hidesWhenStopped = YES;
    }
    return _activityIndicatorView;
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
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor redColor];
    label.numberOfLines = 2;
    label.text = @"注意，添加或删除刷新后有时候并不能马上显示在列表上，需要返回再次进入,可能是缓存引起的问题";
    return label;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
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
    NSObject *value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:key message:value.description preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *resetAction = [UIAlertAction actionWithTitle:SP_LANGUAGE_IS_CHINESE ?@"重置":@"Reset" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:key message:SP_LANGUAGE_IS_CHINESE ?@"你想要移除当前键值对吗":@"Do you want remove the Key-Value" delegate:self cancelButtonTitle:SP_LANGUAGE_IS_CHINESE ?@"取消": @"Cancel" otherButtonTitles:SP_LANGUAGE_IS_CHINESE ?@"确定": @"OK", nil];
        alert.tag = 102;
        [alert show];
        
    }];
    [alertVC addAction:resetAction];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:SP_LANGUAGE_IS_CHINESE ?@"修改": @"Alter" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:key message:SP_LANGUAGE_IS_CHINESE ?@"请输入要设置的值": @"Input the Value" delegate:self cancelButtonTitle:SP_LANGUAGE_IS_CHINESE ?@"取消": @"Cancel" otherButtonTitles:SP_LANGUAGE_IS_CHINESE ?@"确定": @"OK", nil];
        alert.tag = 103;
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        UITextField *valueField = [alert textFieldAtIndex:0];
        valueField.clearButtonMode = UITextFieldViewModeWhileEditing;
        valueField.placeholder = @"value";
        valueField.text = value.description;
        [alert show];
        
    }];
    [alertVC addAction:okAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:SP_LANGUAGE_IS_CHINESE ?@"取消": @"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVC addAction:cancelAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertVC animated:YES completion:nil];
    });
}

#pragma mark - add new key-Value
-(void)add
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:SP_LANGUAGE_IS_CHINESE ?@"添加一个键值对": @"Add key-Value" message:nil delegate:self cancelButtonTitle:SP_LANGUAGE_IS_CHINESE ?@"取消": @"Cancel" otherButtonTitles:SP_LANGUAGE_IS_CHINESE ?@"确定": @"OK", nil];
    alert.tag = 101;
    [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    [alert textFieldAtIndex:0].placeholder =@"key";
    [alert textFieldAtIndex:1].placeholder =@"value";
    [alert textFieldAtIndex:1].secureTextEntry = NO;
    [alert show];
}

#pragma mark - alertview delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
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
