//
//  MedicalRecordController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/10/8.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "MedicalRecordController.h"
#import "AddMedicalRecordViewController.h"

@interface MedicalRecordController ()

@end

@implementation MedicalRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"电子病历";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"medicalRecord"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *str = @"medicalRecord";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"您还没有病历\n添加病历，医生可更好的帮助您";
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.textColor = [UIColor grayColor];
    }else if(indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"add.png"];
        cell.textLabel.text = @"添加新病历";
        cell.textLabel.textColor = RGBACOLOR(32, 166, 254, 1.0);
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0)
        return CGFLOAT_MIN;
    return tableView.sectionHeaderHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        AddMedicalRecordViewController *addMedicalRecordVC = [[AddMedicalRecordViewController alloc] init];
        [self.navigationController pushViewController:addMedicalRecordVC animated:YES];
    }
}

@end
