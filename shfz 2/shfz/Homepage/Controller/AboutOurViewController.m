//
//  AboutOurViewController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/9/30.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "AboutOurViewController.h"
#import "UserAgreementViewController.h"

@interface AboutOurViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation AboutOurViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createTableView];
}

#pragma mark - tableView
- (void)createTableView
{
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    [self.view addSubview:mainTableView];
}

#pragma mark - tableviewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *str = @"functionArrow";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSArray *arr = @[@"用户协议", @"联系我们", @"使用指南"];
        cell.textLabel.text = [arr objectAtIndex:indexPath.row];
        return cell;
    }else {
        static NSString *str = @"function";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        NSArray *arr = @[@"检查更新"];
        cell.textLabel.text = [arr objectAtIndex:indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserAgreementViewController *userAgreementVC = [[UserAgreementViewController alloc] init];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self.navigationController pushViewController:userAgreementVC animated:YES];
                break;
                
            case 1:
                
                break;
                
            default:
                break;
        }
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
