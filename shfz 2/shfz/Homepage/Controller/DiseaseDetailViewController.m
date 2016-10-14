//
//  DiseaseDetailViewController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/8/21.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "DiseaseDetailViewController.h"

#import "KnowledgeTableController.h"
#import "QuestionTableController.h"

@interface DiseaseDetailViewController ()
{
    KnowledgeTableController *_knowledgeTable;
    QuestionTableController *_questionTable;
}
@end

@implementation DiseaseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
    [self initSegmentedControl];
}

#pragma mark - View
- (void)initView
{
    self.title = self.disease;
    self.view.backgroundColor = RGBACOLOR(245, 245, 245, 1.0);
}

- (void)initSegmentedControl
{
    // UISegmentedControl分段控制器
    NSArray *segmentedArr = [[NSArray alloc] initWithObjects:@"知识", @"问答", nil];
    UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:segmentedArr];
    segmented.frame = CGRectMake(0, 64, self.view.frame.size.width, 40);
    segmented.tintColor = RGBACOLOR(164, 211, 238, 1.0);
    segmented.selectedSegmentIndex = 0;
    [segmented addTarget:self action:@selector(segmentedAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmented];
    
    //知识视图
    _knowledgeTable = [[KnowledgeTableController alloc] initWithStyle:UITableViewStyleGrouped];
    _knowledgeTable.view.frame = CGRectMake(0, 64+40, self.view.frame.size.width, self.view.frame.size.height-48-64-40);
    [self addChildViewController:_knowledgeTable];
    [self.view addSubview:_knowledgeTable.view];
    
    //问答视图
    _questionTable = [[QuestionTableController alloc] initWithStyle:UITableViewStylePlain];
    _questionTable.view.frame = CGRectMake(0, 64+40, self.view.frame.size.width, self.view.frame.size.height-48-64-40);
    [self addChildViewController:_questionTable];
}

// 分段控制器的响应方法
- (void)segmentedAction:(UISegmentedControl *)seg
{
    NSInteger index = seg.selectedSegmentIndex;
    switch (index) {
        case 0:
            [UIView transitionFromView:_questionTable.view toView:_knowledgeTable.view duration:0.5 options:(UIViewAnimationOptionTransitionNone) completion:nil];
            break;
            
        case 1:
            [UIView transitionFromView:_knowledgeTable.view toView:_questionTable.view duration:0.5 options:(UIViewAnimationOptionTransitionNone) completion:nil];
            break;
            
        default:
            break;
    }
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
