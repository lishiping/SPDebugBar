
//
//  SPServerListVC.m
//  e-mail:83118274@qq.com
//  Created by lishiping on 16/9/19.
//  Copyright © 2016年 lishiping. All rights reserved.
//
#import "SPServerListVC.h"

@interface SPServerListVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIAlertViewDelegate>
{
}

@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray *serverMArr;//服务器地址数组
@property (strong, nonatomic) NSMutableArray *selectMArr;//选中的服务器地址数组

@end

@implementation SPServerListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Server Table";
    
    [self.view addSubview:self.tableView];
    
    [self addButtonItem];
    
    [self serverMArr];
    
    [self selectMArr];
    
}

+(NSArray *)getSelectArrayWithServerArray:(NSArray*)serverArr
{
    NSMutableArray *selectMArr = [NSMutableArray arrayWithCapacity:0];
    
    //如果有缓存,先取缓存内的
    NSArray *oldSelectArr = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTSERVERLIST];
    if (oldSelectArr.count>0) {
        selectMArr = [NSMutableArray arrayWithArray:oldSelectArr];
        return selectMArr;
    }
    
    //如果没有就从给定地址取出每组的第一个
    NSArray *array = [serverArr copy];
    
    for (int i= 0; i<array.count; i++) {
        
        NSArray *anArray = array[i];
        
        if ([anArray isKindOfClass:[NSArray class]]&&anArray.count>0) {
            
            NSString *firstObj =array[i][0];
            if ([firstObj isKindOfClass:[NSString class]]&&firstObj.length>0) {
                
                [selectMArr addObject:firstObj];
            }
        }
    }
    
    //写入本地缓存
    if (selectMArr.count>0) {
        [[NSUserDefaults standardUserDefaults]  setObject:[selectMArr copy] forKey:SELECTSERVERLIST];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return selectMArr;
}

#pragma mark - add button item
-(void)addButtonItem
{
    //取消按钮
   UIBarButtonItem *cancelItem  = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    
    //清除按钮
   UIBarButtonItem *cleanItem  = [[UIBarButtonItem alloc] initWithTitle:@"Clean" style:UIBarButtonItemStylePlain target:self action:@selector(cleanUserDefault)];
    
    [self.navigationItem setLeftBarButtonItems:@[cancelItem,cleanItem]];
    
    //确定按钮
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStylePlain target:self action:@selector(confirm)] animated:YES];

}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)cleanUserDefault
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"你想要清除本地手动输入增加的服务地址吗？清除后地址列表恢复成给定地址列表" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)confirm
{
    if (self.selectMArr.count>0) {
        
        [[NSUserDefaults standardUserDefaults]  setObject:[self.selectMArr copy] forKey:SELECTSERVERLIST];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if (self.selectServerArrayBlock) {
        self.selectServerArrayBlock(self.selectMArr);
    }
    
    [self dismiss];
}

#pragma mark - 服务器数组里面是否存在新的地址
-(BOOL)serverArrIsExistUrl:(NSString*)tempUrl atIndex:(NSUInteger)index
{
    BOOL ret =NO;
    NSMutableArray *oldtemp = self.serverMArr[index];
    for (NSString *string in oldtemp) {
        if ([string isEqualToString:tempUrl]) {
            ret = YES;;
        }
    }
    return ret;
}

#pragma mark - init ServerArray
-(NSMutableArray*)serverMArr
{
    if (!_serverMArr) {
        //先从缓存读取，没有缓存，取给定的
        NSArray *temp = [[NSUserDefaults standardUserDefaults] objectForKey:DEBUGSERVERLIST];
        _serverMArr = [NSMutableArray arrayWithArray:temp];
        if (_serverMArr.count==0) {
            _serverMArr = [NSMutableArray arrayWithArray:_tempserverArr];
        }
    }
    return _serverMArr;
}

-(NSMutableArray*)selectMArr
{
    if (!_selectMArr) {
        NSArray *tem = [[self class] getSelectArrayWithServerArray:[self.serverMArr copy]];
        _selectMArr = [NSMutableArray arrayWithArray:tem];
    }
    return _selectMArr;
}

#pragma mark - tableview
-(UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.tableFooterView = [[UIView alloc] init];

    }
    return _tableView;
}

#pragma mark - UITableView Delgate and Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //这一步的目的是返回验证的每组合法的数据才有section
    return self.selectMArr.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.serverMArr objectAtIndex:section] count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* identify = @"ServerListCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.text = [[self.serverMArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITextField *text = [tableView viewWithTag:(indexPath.section +200)];
    text.text  =[[self.serverMArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [self.selectMArr replaceObjectAtIndex:indexPath.section withObject:text.text];
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *ary = [NSMutableArray arrayWithArray:[self.serverMArr objectAtIndex:indexPath.section]];
        [ary removeObjectAtIndex:indexPath.row];
        [self.serverMArr replaceObjectAtIndex:indexPath.section withObject:ary];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.serverMArr forKey:DEBUGSERVERLIST];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.tableView reloadData];
       
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 60)];
    headView.backgroundColor = [UIColor grayColor];
    
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(tableView.frame), 20)];
    headLabel.textColor = [UIColor yellowColor];
    headLabel.text =[NSString stringWithFormat:@"第%ld组选中的地址",(long)section+1];
    
    [headView addSubview:headLabel];
    
    UITextField *headTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, CGRectGetWidth(tableView.frame), 40)];
    headTextField.tag = section+200;
    headTextField.textColor = [UIColor greenColor];
    headTextField.text = [self.selectMArr objectAtIndex:section];
    headTextField.delegate = self;
    [headView addSubview:headTextField];
    
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    NSLog(@"第几个%ld",(long)textField.tag);
    
    //获取组索引
    NSUInteger section =textField.tag -200;
    
    if (textField.text.length>0) {
        
        //如果服务器地址里不存在该地址
        if (![self serverArrIsExistUrl:textField.text atIndex:section]) {
            //将新地址添加到服务器列表
            NSMutableArray *oldServerArr = [NSMutableArray arrayWithArray:self.serverMArr];
            
            NSMutableArray *oldtemp =[NSMutableArray arrayWithArray:oldServerArr[section]] ;
            
            [oldtemp addObject:textField.text];
            
            [oldServerArr replaceObjectAtIndex:section withObject:oldtemp];
            
            self.serverMArr = oldServerArr;
            
            //服务器地址重新写入
            [[NSUserDefaults standardUserDefaults] setObject:oldServerArr forKey:DEBUGSERVERLIST];
        }
        
        //旧地址替换成新地址
        [self.selectMArr replaceObjectAtIndex:section withObject:textField.text];
        [[NSUserDefaults standardUserDefaults] setObject:self.selectMArr forKey:SELECTSERVERLIST];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.tableView reloadData];

    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"服务器地址不能为空，请重新填写" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        
        //服务器地址重新写入
        [[NSUserDefaults standardUserDefaults] setObject:[self.tempserverArr copy] forKey:DEBUGSERVERLIST];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.serverMArr = [NSMutableArray arrayWithArray:self.tempserverArr];
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
