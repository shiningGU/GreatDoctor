//
//  HealthyDetailViewController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/10/9.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "HealthyDetailViewController.h"


@interface HealthyDetailViewController ()

@end

@implementation HealthyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

#pragma  mark - initView
- (void)initView {
    self.title = @"健康十分钟";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *shareBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share.png"] style:UIBarButtonItemStyleDone target:self action:@selector(shareAction:)];
    UIBarButtonItem *collectBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"collect.png"] style:UIBarButtonItemStyleDone target:self action:@selector(collectAction:)];
    self.navigationItem.rightBarButtonItems = @[collectBarBtn, shareBarBtn];
}

#pragma mark - uinavigationItem
- (void)shareAction:(UIBarButtonItem *)btn
{
    
}

- (void)collectAction:(UIBarButtonItem *)btn
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
