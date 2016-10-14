//
//  SetViewController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/9/30.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "SetViewController.h"
#import "TextSelectTableViewCell.h"
#import "ChangePswViewController.h"
#import "ChangePhoneViewController.h"

@interface SetViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的设置";
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *str = @"functionSelect";
        TextSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = (TextSelectTableViewCell *)[[[NSBundle mainBundle]loadNibNamed:@"TextSelectTableViewCell" owner:self options:nil] lastObject];
        }
        NSArray *arr = @[@"医生消息推送", @"系统消息推送"];
        cell.myLabel.text = [arr objectAtIndex:indexPath.row];
        return cell;
    }else {
        static NSString *str = @"functionArrow";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
        }
        NSArray *arr = @[@"修改密码", @"改绑手机"];
        cell.textLabel.text = [arr objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChangePswViewController *changePswVC = [[ChangePswViewController alloc] init];
    ChangePhoneViewController *changePhoneVC = [[ChangePhoneViewController alloc] init];
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                [self.navigationController pushViewController:changePswVC animated:YES];
                break;
                
            case 1:
                [self.navigationController pushViewController:changePhoneVC animated:YES];
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
