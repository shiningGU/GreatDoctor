//
//  NearbyHospitalController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/10/13.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "NearbyHospitalController.h"
#import "HospitalTableViewController.h"
#import "HospitalMapViewController.h"

#define MainViewControllerTitle @"附近医院"

@interface NearbyHospitalController ()
{
    BOOL _isMap;
    HospitalTableViewController *_hospitalTVC;
    HospitalMapViewController *_hospitalMapVC;
}

@end

@implementation NearbyHospitalController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
    [self initSelectHospitalNotificationCenter];
}

#pragma mark - initView
- (void)initView {
    _isMap = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list.png"] style:UIBarButtonItemStyleDone target:self action:@selector(changeMapView:)];
    
    _hospitalMapVC = [[HospitalMapViewController alloc] init];
    _hospitalMapVC.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    [self addChildViewController:_hospitalMapVC];
    [self.view addSubview:_hospitalMapVC.view];
    
    _hospitalTVC = [[HospitalTableViewController alloc] initWithStyle:UITableViewStylePlain];
    _hospitalTVC.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 48);
    [self addChildViewController:_hospitalTVC];
    
}

- (void)changeMapView:(UIBarButtonItem *)barbtn {
    if (_isMap == NO) {
        [barbtn setImage:[UIImage imageNamed:@"list.png"]];
        [UIView transitionFromView:_hospitalTVC.view toView:_hospitalMapVC.view duration:0.5 options:(UIViewAnimationOptionTransitionNone) completion:nil];
        _isMap = YES;
    }else {
        [barbtn setImage:[UIImage imageNamed:@"map.png"]];
        [UIView transitionFromView:_hospitalMapVC.view toView:_hospitalTVC.view duration:0.5 options:(UIViewAnimationOptionTransitionNone) completion:nil];
        _isMap = NO;
    }
}

#pragma  mark - 通知NSNotificationCenter 列表切换地图时点击的医院弹出窗口
- (void)initSelectHospitalNotificationCenter {
    NSNotificationCenter *getSelectHospitalCenter = [NSNotificationCenter defaultCenter];
    [getSelectHospitalCenter addObserver:self selector:@selector(getSelectHospitalNotification:) name:@"getSelectHospital" object:nil];
}

- (void)getSelectHospitalNotification:(NSNotification *)noti {
    if ([noti.object isEqualToString:@"NO"]) {
        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"list.png"]];
        [UIView transitionFromView:_hospitalTVC.view toView:_hospitalMapVC.view duration:0.5 options:(UIViewAnimationOptionTransitionNone) completion:nil];
        _isMap = YES;
    }
}

- (id)init
{
    if (self = [super init])
    {
        self.title = MainViewControllerTitle;
        
    }
    
    return self;
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
