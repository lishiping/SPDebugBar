
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
    
    self.title = SP_LANGUAGE_IS_CHINESE? @"服务器列表":@"Server Table" ;
    
    [self.view addSubview:self.tableView];
    
    [self addButtonItem];
    
    [self serverMArr];
    
    [self selectMArr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - check
//检查给定服务器地址是否合法,只检查了字符串，没检查url地址的正则表达式
+(BOOL)checkArray:(NSArray*)serverArr
{
    BOOL ret = NO;
    if ([serverArr isKindOfClass:[NSArray class]] && serverArr.count>0)
    {
        for (NSDictionary *dic in serverArr)
        {
            if ([dic isKindOfClass:[NSDictionary class]] && dic.count>0) {
                
                NSString *title = [dic objectForKey:@"title"];
                if ([title isKindOfClass:NSString.class]&& title.length>0)
                {
                    ret = YES;
                }
                else
                {
                    return NO;
                }
                
                NSArray *arr = [dic objectForKey:SP_ARRAY_KEY];
                if ([arr isKindOfClass:[NSArray class]]&&arr.count>0)
                {
                    for (NSString *string in arr) {
                        if ([string isKindOfClass:[NSString class]] && string.length>0)
                        {
                            //都是字符串，并有长度
                            ret = YES;
                        }else
                        {
                            //不是字符串就返回不通过
                            return NO;
                        }
                    }
                }
                else
                {
                    return NO;
                }
            }
            else
            {
                return NO;
            }
        }
    }
    else
    {
        return NO;
    }
    return ret;
}

+(NSArray *)getSelectArrayWithServerArray:(NSArray*)serverArr
{
    NSMutableArray *selectMArr = [NSMutableArray arrayWithCapacity:0];
    
    NSArray *oldServerArr = [[NSUserDefaults standardUserDefaults] objectForKey:SP_GIVENSERVERLIST];
    NSArray *oldSelectArr = [[NSUserDefaults standardUserDefaults] objectForKey:SP_SELECTSERVERLIST];
    
    //如果有缓存选择的地址,同时验证缓存内给定地址列表是否与新的给定地址列表相同,如果相同则本次取缓存选择的地址，如果不相同，说明给定地址变了，要全部重置
    if (oldSelectArr.count>0 && [oldServerArr isEqualToArray:serverArr]) {
        //返回缓存选择的地址
        return oldSelectArr;
    }
    
    //如果没有缓存或者给定地址有变化，就从给定地址取出每组的第一个
    NSArray *array = [serverArr copy];
    
    for (int i= 0; i<array.count; i++) {
        
        NSDictionary *anDic = array[i];
        
        if ([anDic isKindOfClass:[NSDictionary class]]&&anDic.count>0)
        {
            NSArray *serverArr = [anDic objectForKey:SP_ARRAY_KEY];
            NSString *firstObj =serverArr[0];
            if ([firstObj isKindOfClass:[NSString class]]&&firstObj.length>0)
            {
                [selectMArr addObject:firstObj];
            }
        }
    }
    
    //写入本地缓存
    if (selectMArr.count>0)
    {
        [[NSUserDefaults standardUserDefaults]  setObject:[selectMArr copy] forKey:SP_SELECTSERVERLIST];
        [[NSUserDefaults standardUserDefaults]  setObject:[serverArr copy] forKey:SP_GIVENSERVERLIST];
        [[NSUserDefaults standardUserDefaults]  setObject:[serverArr copy] forKey:SP_ALLSERVERLIST];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return selectMArr;
}

#pragma mark - add button item
-(void)addButtonItem
{    
    //确定按钮
    UIBarButtonItem *OKItem  = [[UIBarButtonItem alloc] initWithTitle:SP_LANGUAGE_IS_CHINESE? @"确定":@"OK" style:UIBarButtonItemStylePlain target:self action:@selector(confirm)];
    
    
    //清除按钮
    UIBarButtonItem *cleanItem  = [[UIBarButtonItem alloc] initWithTitle:SP_LANGUAGE_IS_CHINESE? @"清除":@"Clean" style:UIBarButtonItemStylePlain target:self action:@selector(cleanUserDefault)];
    
    NSArray *oldGivenArr = [[NSUserDefaults standardUserDefaults] objectForKey:SP_GIVENSERVERLIST];
    NSArray *oldAllArr = [[NSUserDefaults standardUserDefaults] objectForKey:SP_ALLSERVERLIST];
    
    //如果给定服务器地址和所有地址相同，说明没有后添加过，不需要清除
    if ([oldGivenArr isEqualToArray:oldAllArr]) {
        [self.navigationItem setRightBarButtonItems:@[OKItem]];
    }
    else
    {
        [self.navigationItem setRightBarButtonItems:@[OKItem,cleanItem]];
    }
    
}

-(void)cleanUserDefault
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:SP_LANGUAGE_IS_CHINESE? @"你想要移除本地手动添加的额外地址吗？移除之后恢复成初始化给定的列表":@"Do you want to remove the local manually enter additional service address?Remove address list after back to the given address list" delegate:self cancelButtonTitle:SP_LANGUAGE_IS_CHINESE? @"取消":@"Cancel" otherButtonTitles:SP_LANGUAGE_IS_CHINESE?@"确定":@"OK", nil];
    [alert show];
}

- (void)confirm
{
    [self.view endEditing:YES];
    
    if (self.selectMArr.count>0)
    {
        [[NSUserDefaults standardUserDefaults]  setObject:self.selectMArr forKey:SP_SELECTSERVERLIST];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (self.selectServerArrayBlock) {
            self.selectServerArrayBlock([self.selectMArr copy],nil);
        }
    }
    
    [self dismiss];
}

#pragma mark - 服务器数组里面是否存在新的地址
-(BOOL)serverArrIsExistURL:(NSString*)tempURL atIndex:(NSUInteger)index
{
    BOOL ret =NO;
    NSArray *oldtemp = [(NSDictionary*)(self.serverMArr[index]) objectForKey:SP_ARRAY_KEY];
    for (NSString *string in oldtemp) {
        if ([string isEqualToString:tempURL]) {
            ret = YES;
        }
    }
    return ret;
}

#pragma mark - init ServerArray
-(NSMutableArray*)serverMArr
{
    if (!_serverMArr) {
        //先从缓存读取，没有缓存，取给定的
        NSArray *temp = [[NSUserDefaults standardUserDefaults] objectForKey:SP_ALLSERVERLIST];
        _serverMArr = [NSMutableArray arrayWithArray:temp];
        if (_serverMArr.count==0) {
            _serverMArr = [NSMutableArray arrayWithArray:_tempserverArr];
            if (_serverMArr.count>0) {
                [[NSUserDefaults standardUserDefaults] setObject:[_tempserverArr copy] forKey:SP_ALLSERVERLIST];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }
    return _serverMArr;
}

-(NSMutableArray*)selectMArr
{
    if (!_selectMArr) {
        NSArray *tem = [[self class] getSelectArrayWithServerArray:[_tempserverArr copy]];
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
        _tableView.sectionFooterHeight = 1.0f;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:
         NSStringFromClass([UITableViewCell class])];
        
        //使用父类视图
        _tableView.tableFooterView = self.class.tableFooterView;
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
    NSDictionary *dic = [self.serverMArr objectAtIndex:section];
    
    return ((NSArray*)[dic objectForKey:SP_ARRAY_KEY]).count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    NSDictionary *dic = [self.serverMArr objectAtIndex:indexPath.section];
    NSArray *array = [dic objectForKey:SP_ARRAY_KEY];
    
    cell.textLabel.text =[array objectAtIndex:indexPath.row];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;

    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self.view endEditing:YES];
    
    //找到字符串
    NSDictionary *dic =(NSDictionary*)[self.serverMArr objectAtIndex:indexPath.section];
    NSString *text =[(NSArray*)[dic objectForKey:SP_ARRAY_KEY] objectAtIndex:indexPath.row];
    
    UITextField *textField = [tableView viewWithTag:(indexPath.section +200)];
    //有时候该方法找不到text，所以在tableview的subviews里面找
    if (!textField) {
        for (UIView *subview in tableView.subviews) {
            textField =[subview viewWithTag:(indexPath.section +200)];
            if (textField&&[textField isKindOfClass:[UITextField class]]) {
                break;
            }
        }
    }
    
    //换选中地址
    if (textField && text.length>0)
    {
        textField.text = text;
        [self.selectMArr replaceObjectAtIndex:indexPath.section withObject:text];
    }
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSMutableDictionary *mdic = [[self.serverMArr objectAtIndex:indexPath.section] mutableCopy];
        NSMutableArray *mArr = [[mdic objectForKey:SP_ARRAY_KEY] mutableCopy];
        [mArr removeObjectAtIndex:indexPath.row];
        
        [mdic setValue:mArr forKey:SP_ARRAY_KEY];
        [self.serverMArr replaceObjectAtIndex:indexPath.section withObject:mdic];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.serverMArr forKey:SP_ALLSERVERLIST];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.tableView reloadData];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 60)];
    headView.backgroundColor = [UIColor lightTextColor];
    headView.layer.borderWidth = 1;
    headView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(tableView.frame), 20)];
    headLabel.textColor = [UIColor redColor];
    [headView addSubview:headLabel];
    
    NSDictionary *dic = [self.serverMArr objectAtIndex:section];
    NSString *title = [dic objectForKey:SP_TITLE_KEY];
    
    if (title.length>0) {
        headLabel.text = title;
    }
    else
    {
        headLabel.text =SP_LANGUAGE_IS_CHINESE ?[NSString stringWithFormat:@"第 %ld 组选中的地址",(long)section+1]:[NSString stringWithFormat:@"The %ld section of the selected address",(long)section+1];
    }
    
    UITextField *headTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 25, CGRectGetWidth(tableView.frame)-10, 35)];
    headTextField.tag = section+200;
    headTextField.textColor = [UIColor redColor];
    headTextField.textAlignment = NSTextAlignmentLeft;
    headTextField.placeholder =SP_LANGUAGE_IS_CHINESE ?@"输入地址":@"Input URL!!";
    headTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    headTextField.text = [self.selectMArr objectAtIndex:section];
    headTextField.adjustsFontSizeToFitWidth = YES;
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
    if (textField.text.length>0)
    {
        //获取组索引
        NSUInteger section =textField.tag -200;
        //如果服务器地址里不存在该地址
        if (![self serverArrIsExistURL:textField.text atIndex:section])
        {
            //将新地址添加到服务器列表
            NSMutableDictionary *mdic =[self.serverMArr[section] mutableCopy];
            
            NSMutableArray *oldtempArr =[NSMutableArray arrayWithArray:[mdic objectForKey:SP_ARRAY_KEY]];
            
            [oldtempArr addObject:textField.text];
            
            [mdic setValue:oldtempArr forKey:SP_ARRAY_KEY];
            
            [self.serverMArr replaceObjectAtIndex:section withObject:mdic];
            
            //服务器地址重新写入
            [[NSUserDefaults standardUserDefaults] setObject:self.serverMArr forKey:SP_ALLSERVERLIST];
        }
        
        //旧地址替换成新地址
        [self.selectMArr replaceObjectAtIndex:section withObject:textField.text];
        [[NSUserDefaults standardUserDefaults] setObject:self.selectMArr forKey:SP_SELECTSERVERLIST];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.tableView reloadData];
        
        [self addButtonItem];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:SP_LANGUAGE_IS_CHINESE ?@"输入的地址不能为空，请重新输入":@"The address of the server can't be empty, please re-enter" delegate:nil cancelButtonTitle:SP_LANGUAGE_IS_CHINESE ?@"确定":@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //确认清除后添加的
    if (buttonIndex==1&&self.tempserverArr.count>0)
    {
        //服务器地址重新写入
        [[NSUserDefaults standardUserDefaults] setObject:self.tempserverArr forKey:SP_ALLSERVERLIST];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.serverMArr = [NSMutableArray arrayWithArray:self.tempserverArr];
        [self.tableView reloadData];
        
        [self addButtonItem];
    }
}


@end
