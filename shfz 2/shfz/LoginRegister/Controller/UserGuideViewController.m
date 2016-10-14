//
//  UserGuideViewController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/8/19.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "UserGuideViewController.h"

@interface UserGuideViewController ()

@end

@implementation UserGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

#pragma mark - View
- (void)initView
{
    self.view.backgroundColor = RGBACOLOR(245, 245, 245, 1.0);
    // 导航栏颜色
    self.navigationController.navigationBar.barTintColor = RGBACOLOR(0, 178, 255, 1.0);
    
    UIImage *leftImage = [UIImage imageNamed:@"iconfont-xiangzuo.png"];
    leftImage = [leftImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStyleDone target:self action:@selector(toBack:)];
}

- (void)toBack:(UIBarButtonItem *)barBtn
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
