//
//  ViewController.m
//  SPDebugBar
//
//  Created by lishiping on 17/1/4.
//  Copyright © 2017年 lishiping. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic,strong)UILabel *firstLabel;
@property(nonatomic,strong)UILabel *secondLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.frame), 50)];
    self.firstLabel.text = _firstStr;
    self.firstLabel.textColor = [UIColor redColor];
    [self.view addSubview:self.firstLabel];
    
    self.secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, CGRectGetWidth(self.view.frame), 50)];
    self.secondLabel.text =_sceondStr;
    self.secondLabel.textColor = [UIColor redColor];
    [self.view addSubview:self.secondLabel];
    
}

-(void)refreshLabel
{
    self.firstLabel.text = _firstStr;
    self.secondLabel.text =_sceondStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
