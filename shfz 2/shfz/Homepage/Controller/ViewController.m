//
//  ViewController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/7/30.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "ViewController.h"
#import "ABCIntroView.h"
#import "RegisterViewController.h"
#import "RootTabBarController.h"

@interface ViewController ()<ABCIntroViewDelegate>
@property ABCIntroView *introView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initView];
    [self initABCView];
}

#pragma mark - View
- (void)initView
{
    layerCornerRadius(_loginBtn, 20);
    layerCornerRadius(_username, 15);
    layerCornerRadius(_password, 15);
    self.username.layer.borderWidth = 0.2;
    self.password.layer.borderWidth = 0.2;
    self.username.backgroundColor = [UIColor whiteColor];
    self.password.backgroundColor = [UIColor whiteColor];
}

#pragma mark - ABCIntroViewDelegate Methods

- (void)initABCView
{
    self.introView = [[ABCIntroView alloc] initWithFrame:self.view.frame];
    self.introView.delegate = self;
    self.introView.backgroundColor = RGBACOLOR(135, 206, 250, 1.0);
    [self.view addSubview:self.introView];

}

#pragma mark - 点击空白处收回键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_username resignFirstResponder];
    [_password resignFirstResponder];
}


-(void)onDoneButtonPressed{
    
    //    Uncomment so that the IntroView does not show after the user clicks "DONE"
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.introView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.introView removeFromSuperview];
    }];
}

#pragma mark - 显示tabbar
//- (void)showTabBar
//
//{
//    if (self.tabBarController.tabBar.hidden == NO)
//    {
//        return;
//    }
//    UIView *contentView;
//    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
//        
//        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
//    
//    else
//        
//        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
//    contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
//    self.tabBarController.tabBar.hidden = NO;
//    
//}
//

#pragma mark - 设置该页面stusbar为黑色，退出后为白色
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Login and Register
- (IBAction)registerAction:(id)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self presentViewController:registerVC animated:YES completion:^{
        
    }];
}
- (IBAction)loginAction:(id)sender {
    RootTabBarController *rootTBC = [[RootTabBarController alloc] init];
    [self presentViewController:rootTBC animated:YES completion:nil];
}

- (IBAction)qqLogin:(id)sender {
}

- (IBAction)weiboLogin:(id)sender {
}

- (IBAction)weixinLogin:(id)sender {
}
@end
