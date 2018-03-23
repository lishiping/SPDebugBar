//
//  SPDebugVC.m
//  SPDebugBar
//
//  Created by shiping li on 2018/3/9.
//  Copyright © 2018年 lishiping. All rights reserved.
//

#import "SPDebugVC.h"
#import "SPNSUserDefaultsVC.h"

@interface SPDebugVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray *tableDataMArr;//服务器地址数组
//@property (strong, nonatomic) NSMutableArray *selectMArr;//选中的服务器地址数组

@end

@implementation SPDebugVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"调试工具栏";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init ServerArray
-(NSMutableArray*)tableDataMArr
{
    if (!_tableDataMArr) {
        _tableDataMArr = @[@"选择服务器",@"设置NSUserDefaults"];
    }
    return _tableDataMArr;
}

//-(NSMutableArray*)selectMArr
//{
//    if (!_selectMArr) {
//        NSArray *tem = [[self class] getSelectArrayWithServerArray:[_tempserverArr copy]];
//        _selectMArr = [NSMutableArray arrayWithArray:tem];
//    }
//    return _selectMArr;
//}

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
    }
    return _tableView;
}

#pragma mark - UITableView Delgate and Datasource

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    //这一步的目的是返回验证的每组合法的数据才有section
//    return self.tableDataMArr.count;
//}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSDictionary *dic = [self.tableDataMArr objectAtIndex:section];
//
//    return ((NSArray*)[dic objectForKey:SP_SERVERLIST_KEY]).count;
    
        return self.tableDataMArr.count;

}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    NSString *text = [self.tableDataMArr objectAtIndex:indexPath.row];
    cell.textLabel.text =text;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self.view endEditing:YES];
    
    //找到字符串
//    NSDictionary *dic =(NSDictionary*)[self.serverMArr objectAtIndex:indexPath.section];
//    NSString *text =[(NSArray*)[dic objectForKey:SP_SERVERLIST_KEY] objectAtIndex:indexPath.row];
    
    if (indexPath.section==0)
    {
        if (indexPath.row==0) {
            //弹出配置页面
            SPServerListVC* serverListVC = [[SPServerListVC alloc] init];
            serverListVC.tempserverArr =self.tempserverArr;
            serverListVC.selectServerArrayBlock = self.selectServerArrayBlock;
            [self.navigationController pushViewController:serverListVC animated:YES];
        }
        else if (indexPath.row==1)
        {
            
            SPNSUserDefaultsVC *userDefaultsVC = [[SPNSUserDefaultsVC alloc] init];
            
            [self.navigationController pushViewController:userDefaultsVC animated:YES];
        }
    }
    else
    {
        
    }
    
}

//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 60)];
//    headView.backgroundColor = [UIColor lightTextColor];
//    headView.layer.borderWidth = 1;
//    headView.layer.borderColor = [UIColor darkGrayColor].CGColor;
//
//    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(tableView.frame), 20)];
//    headLabel.textColor = [UIColor redColor];
//    [headView addSubview:headLabel];
//
//    NSDictionary *dic = [self.serverMArr objectAtIndex:section];
//    NSString *title = [dic objectForKey:SP_TITLE_KEY];
//
//    if (title.length>0) {
//        headLabel.text = title;
//    }
//    else
//    {
//        headLabel.text =SP_LANGUAGE_IS_EN ? [NSString stringWithFormat:@"The %ld section of the selected address",(long)section+1] : [NSString stringWithFormat:@"第 %ld 组选中的地址",(long)section+1] ;
//    }
//
//    UITextField *headTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 25, CGRectGetWidth(tableView.frame)-10, 35)];
//    headTextField.tag = section+200;
//    headTextField.textColor = [UIColor redColor];
//    headTextField.textAlignment = NSTextAlignmentLeft;
//    headTextField.placeholder =SP_LANGUAGE_IS_EN ? @"Input URL!!" : @"输入地址";
//    headTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    headTextField.text = [self.selectMArr objectAtIndex:section];
//    headTextField.adjustsFontSizeToFitWidth = YES;
//    headTextField.delegate = self;
//    [headView addSubview:headTextField];
//
//    return headView;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}


@end
