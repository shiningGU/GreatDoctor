//
//  RootTabBarController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/7/31.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "RootTabBarController.h"
#import "HomeViewController.h"
#import "MyTableViewController.h"

@interface RootTabBarController ()

@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 首页
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    UINavigationController *naviHome = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    // 导航栏颜色
    naviHome.navigationBar.barTintColor = RGBACOLOR(0, 178, 255, 1.0);
    // 导航栏标题颜色
    [naviHome.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    naviHome.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"iconfont-shouye.png"] tag:1];
     [naviHome.tabBarItem setBadgeValue:@"1"];
    homeViewController.title = @"首页";
//    // 隐藏导航栏
//    [naviHome setNavigationBarHidden:YES animated:NO];
    
    // 我的
    MyTableViewController *myTableViewController = [[MyTableViewController alloc] init];
    UINavigationController *naviMy = [[UINavigationController alloc] initWithRootViewController:myTableViewController];
    // 导航栏颜色
    naviMy.navigationBar.barTintColor = RGBACOLOR(0, 178, 255, 1.0);
    // 导航栏标题颜色
    [naviMy.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    naviMy.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:[UIImage imageNamed:@"my.png"] tag:2];
//    myTableViewController.title = @"我";
    
    //设定Tabbar的点击后的颜色
    [[UITabBar appearance] setTintColor:RGBACOLOR(0, 178, 255, 1.0)];
    // 设置tabbar的颜色 不设置 是透明的
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    
    // TabBar添加导航控制器
    self.viewControllers = @[naviHome, naviMy];
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
