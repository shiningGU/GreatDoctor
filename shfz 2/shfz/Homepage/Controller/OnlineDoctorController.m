//
//  OnlineDoctorController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/10/9.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "OnlineDoctorController.h"
#import "AnswerViewController.h"
#import "DoctorDetailViewController.h"

#import "OnlineDoctorCell.h"
#import "PastDoctorCell.h"

@interface OnlineDoctorController ()

@end

@implementation OnlineDoctorController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专家在线";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerCell];
    
}

#pragma mark - registerCell
- (void)registerCell {
    [self.tableView registerNib:[UINib nibWithNibName:@"OnlineDoctorCell" bundle:nil] forCellReuseIdentifier:@"onlineDoctor"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PastDoctorCell" bundle:nil] forCellReuseIdentifier:@"pastdoctor"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *str = @"onlineDoctor";
        OnlineDoctorCell *cell = [tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
        
        if (!cell) {
            cell = [[OnlineDoctorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        layerCornerRadius(cell.questionBtn, 10);
        AnswerViewController *answerVC = [[AnswerViewController alloc] init];
        cell.lastViewController = self;
        cell.nextViewController = answerVC;
        return cell;
    }else {
        static NSString *str = @"pastdoctor";
        PastDoctorCell *cell = [tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
        if (!cell) {
            cell = [[PastDoctorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.viewController = self;
        layerCornerRadius(cell.backView, 20);
        cell.backView.layer.borderWidth = 1;
        cell.backView.layer.borderColor = RGBACOLOR(135, 206, 255, 1.0).CGColor;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 180;
    }
    return 280;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 25)];
    dateLabel.center = CGPointMake(dateView.frame.size.width/2, dateView.frame.size.height/2);
    dateLabel.backgroundColor = RGBACOLOR(205, 201, 201, 1.0);
    dateLabel.layer.masksToBounds = YES;
    layerCornerRadius(dateLabel, 12);
    if (section == 0) {
        dateLabel.text = @"在线专家";
    }else {
        dateLabel.text = @"往期回顾";
    }
    dateLabel.font = [UIFont systemFontOfSize:15];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.textColor = [UIColor whiteColor];
    [dateView addSubview:dateLabel];
    return dateView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DoctorDetailViewController *doctorVC = [[DoctorDetailViewController alloc] init];
    if (indexPath.section == 0) {
        doctorVC.type = @"online";
    }else {
        doctorVC.type = @"offline";
    }
    [self.navigationController pushViewController:doctorVC animated:YES];
}

@end
