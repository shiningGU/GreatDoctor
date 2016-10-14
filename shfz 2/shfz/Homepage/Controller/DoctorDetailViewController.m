//
//  DoctorDetailViewController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/10/10.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "DoctorDetailViewController.h"
#import "DoctorIntroduceController.h"
#import "AnsweredController.h"
#import "MyQuestionTController.h"

@interface DoctorDetailViewController ()
{
    DoctorIntroduceController *_doctorIntroduceVC;
    AnsweredController *_answeredVC;
    MyQuestionTController *_myQuestionVC;
}

@end

@implementation DoctorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    [self initSegmentedControl];
}

#pragma mark - initView
- (void)initView {
    self.title = @"专家在线";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *shareBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share.png"] style:UIBarButtonItemStyleDone target:self action:@selector(shareAction:)];
    UIBarButtonItem *collectBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"collect.png"] style:UIBarButtonItemStyleDone target:self action:@selector(collectAction:)];
    NSArray *arr = @[collectBarBtn, shareBarBtn];
    self.navigationItem.rightBarButtonItems = arr;
}

#pragma mark - uisegmentedcontrol
- (void)initSegmentedControl {
    if ([_type isEqualToString:@"online"]) {
        _segmented.selectedSegmentIndex = 0;
    }else {
        _segmented.selectedSegmentIndex = 1;
    }
    [_segmented addTarget:self action:@selector(segmentedAction:) forControlEvents:UIControlEventValueChanged];
    
    // 专家简介
    _doctorIntroduceVC = [[DoctorIntroduceController alloc] initWithStyle:UITableViewStylePlain];
    _doctorIntroduceVC.type = self.type;
    _doctorIntroduceVC.lastViewController = self;
    CGFloat segmentedY = _segmented.frame.origin.y+_segmented.frame.size.height;
    _doctorIntroduceVC.view.frame = CGRectMake(0, segmentedY, self.view.frame.size.width, self.view.frame.size.height - segmentedY - 48);
    [self addChildViewController:_doctorIntroduceVC];
    
    
    // 已回复
    _answeredVC = [[AnsweredController alloc] initWithStyle:UITableViewStylePlain];
    _answeredVC.view.frame = CGRectMake(0, segmentedY, self.view.frame.size.width, self.view.frame.size.height - segmentedY - 48);
    [self addChildViewController:_answeredVC];
    
    // 我的问题
    _myQuestionVC = [[MyQuestionTController alloc] initWithStyle:UITableViewStylePlain];
    _myQuestionVC.view.frame = CGRectMake(0, segmentedY, self.view.frame.size.width, self.view.frame.size.height - segmentedY - 48);
    [self addChildViewController:_myQuestionVC];
    
    if (_segmented.selectedSegmentIndex == 0) {
        [self.view addSubview:_doctorIntroduceVC.view];
    }else
        [self.view addSubview:_answeredVC.view];
}

// 分段控制器的响应方法
- (void)segmentedAction:(UISegmentedControl *)seg {
    NSInteger index = seg.selectedSegmentIndex;
    switch (index) {
        case 0:
            [UIView transitionFromView:_answeredVC.view toView:_doctorIntroduceVC.view duration:0.5 options:(UIViewAnimationOptionTransitionNone) completion:nil];
            [UIView transitionFromView:_myQuestionVC.view toView:_doctorIntroduceVC.view duration:0.5 options:(UIViewAnimationOptionTransitionNone) completion:nil];
            break;
            
        case 1:
            [UIView transitionFromView:_doctorIntroduceVC.view toView:_answeredVC.view duration:0.5 options:(UIViewAnimationOptionTransitionNone) completion:nil];
            [UIView transitionFromView:_myQuestionVC.view toView:_answeredVC.view duration:0.5 options:(UIViewAnimationOptionTransitionNone) completion:nil];
            break;
            
        case 2:
            [UIView transitionFromView:_doctorIntroduceVC.view toView:_myQuestionVC.view duration:0.5 options:(UIViewAnimationOptionTransitionNone) completion:nil];
            [UIView transitionFromView:_answeredVC.view toView:_myQuestionVC.view duration:0.5 options:(UIViewAnimationOptionTransitionNone) completion:nil];
            break;
            
        default:
            break;
    }
}

#pragma mark - uinavigationItem
- (void)shareAction:(UIBarButtonItem *)barBtn {
    
}

- (void)collectAction:(UIBarButtonItem *)barBtn {
    
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
