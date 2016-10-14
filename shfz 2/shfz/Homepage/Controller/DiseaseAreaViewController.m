//
//  DiseaseAreaViewController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/8/12.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "DiseaseAreaViewController.h"
#import "DiseaseDetailViewController.h"
#import "INSSearchBar.h"
#import "WWTagsCloudView.h"

@interface DiseaseAreaViewController ()<UISearchBarDelegate, INSSearchBarDelegate, WWTagsCloudViewDelegate>
{
    NSArray* _tags;// 标签数组
}
@property (nonatomic, strong) INSSearchBar *searchBarWithDelegate;
@property (nonatomic, strong)WWTagsCloudView *tagsCloudView;

@end

@implementation DiseaseAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSearchView];
    [self initTagsView];
}

#pragma mark - View
- (void)initSearchView
{
    self.view.backgroundColor = RGBACOLOR(245, 245, 245, 1.0);
    
    self.searchBarWithDelegate = [[INSSearchBar alloc] initWithFrame:CGRectMake(20.0, 100.0, 44.0, 34.0)];
    self.searchBarWithDelegate.delegate = self;
    
    [self.view addSubview:self.searchBarWithDelegate];
}

- (void)initTagsView
{
    NSArray *colorArr = @[RGBACOLOR(135, 206, 255, 1.0), RGBACOLOR(255, 130, 171, 1.0), RGBACOLOR(64, 224, 208, 1.0), RGBACOLOR(255, 215, 0, 1.0), RGBACOLOR(171, 130, 255, 1.0), RGBACOLOR(255, 140, 105, 1.0)];
    NSArray *fontArr = @[[UIFont systemFontOfSize:17],
                         [UIFont systemFontOfSize:22],
                         [UIFont systemFontOfSize:27]];
    _tags = @[@"鼻出血", @"急性鼻炎", @"声带息肉", @"外耳道炎", @"咽喉部外伤", @"耳鼻咽喉创伤", @"鼻窦炎", @"慢性咽炎", @"过敏性鼻炎", @"扁桃体炎"];
    self.tagsCloudView = [[WWTagsCloudView alloc] initWithFrame:CGRectMake(0.0, self.searchBarWithDelegate.frame.size.height+self.searchBarWithDelegate.frame.origin.y, self.view.frame.size.width, 240) andTags:_tags andTagColors:colorArr andFonts:fontArr andParallaxRate:1.7 andNumOfLine:4];
    self.tagsCloudView.delegate = self;
    [self.view addSubview:self.tagsCloudView];
}

#pragma WWTagsCloudViewDelegate
- (void)tagClickAtIndex:(NSInteger)tagIndex
{
//    NSLog(@"%@ be clicked.", _tags[tagIndex]);
    DiseaseDetailViewController *disDVC = [[DiseaseDetailViewController alloc] init];
    disDVC.disease = _tags[tagIndex];
    [self.navigationController pushViewController:disDVC animated:YES];
}

#pragma mark - 点击空白处收回键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_searchBarWithDelegate.searchField resignFirstResponder];
}

#pragma mark - search bar delegate

- (CGRect)destinationFrameForSearchBar:(INSSearchBar *)searchBar
{
    return CGRectMake(20.0, 100.0, CGRectGetWidth(self.view.bounds) - 40.0, 34.0);
}

- (void)searchBar:(INSSearchBar *)searchBar willStartTransitioningToState:(INSSearchBarState)destinationState
{
    // Do whatever you deem necessary.
}

- (void)searchBar:(INSSearchBar *)searchBar didEndTransitioningFromState:(INSSearchBarState)previousState
{
    // Do whatever you deem necessary.
}

- (void)searchBarDidTapReturn:(INSSearchBar *)searchBar
{
    // Do whatever you deem necessary.
    // Access the text from the search bar like searchBar.searchField.text
}

- (void)searchBarTextDidChange:(INSSearchBar *)searchBar
{
    // Do whatever you deem necessary.
    // Access the text from the search bar like searchBar.searchField.text
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
