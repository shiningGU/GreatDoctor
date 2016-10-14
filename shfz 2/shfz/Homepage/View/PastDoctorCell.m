//
//  PastDoctorCell.m
//  shfz
//
//  Created by shanghaifuzhong on 15/10/10.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "PastDoctorCell.h"
#import "OnlineDoctorCell.h"
#import "DoctorDetailViewController.h"
#import "AnsweredController.h"

@implementation PastDoctorCell

- (void)awakeFromNib {
    // Initialization code
    self.doctorTableView.delegate = self;
    self.doctorTableView.dataSource = self;
    self.doctorTableView.scrollEnabled =NO;
    
    [self.doctorTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"doctorTableviewCell"];
    [self.doctorTableView registerNib:[UINib nibWithNibName:@"OnlineDoctorCell" bundle:nil] forCellReuseIdentifier:@"onlineDoctor"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - tableviewDataSource & tableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *str = @"onlineDoctor";
        OnlineDoctorCell *cell = [tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
        
        if (!cell) {
            cell = [[OnlineDoctorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        [cell.questionBtn removeFromSuperview];
        return cell;
    }else if (indexPath.row == 1){
        static NSString *str = @"TextArrowTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"精彩回答";
        cell.textLabel.textColor = RGBACOLOR(255, 165, 0, 1.0);
        return cell;
    }else {
        static NSString *str = @"doctorTableviewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        NSArray *arr = @[@"鼻炎晚上睡觉鼻内有粘液流入口腔为何？", @"慢性饮食作息要怎么做才能缓解", @"过敏性鼻炎有没有什么好的治疗方法"];
        cell.textLabel.text = [arr objectAtIndex:indexPath.row - 2];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 140;
    }
    return (self.doctorTableView.frame.size.height - 140)/4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DoctorDetailViewController *doctorVC = [[DoctorDetailViewController alloc] init];
    AnsweredController *answeredVC = [[AnsweredController alloc] initWithStyle:UITableViewStylePlain];
    if (indexPath.row == 0) {
        doctorVC.type = @"offline";
        [_viewController.navigationController pushViewController:doctorVC animated:YES];
    }else if (indexPath.row == 1) {
        [_viewController.navigationController pushViewController:answeredVC animated:YES];
    }
    
}

@end
