//
//  HealthyTableController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/10/9.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "HealthyTableController.h"
#import "HealthynewsCell.h"
#import "HealthyDetailViewController.h"

@interface HealthyTableController ()

@end

@implementation HealthyTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"健康精选";
    [self.tableView registerNib:[UINib nibWithNibName:@"HealthynewsCell" bundle:nil] forCellReuseIdentifier:@"healthyNews"];
    self.tableView.sectionFooterHeight = 0;
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *str = @"healthyNews";
    HealthynewsCell *cell = [tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
    if (!cell) {
        cell = [[HealthynewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.typeLabel.layer.masksToBounds = YES;
    layerCornerRadius(cell.typeLabel, 10);
    cell.typeLabel.layer.borderWidth = 0.5;
    cell.typeLabel.layer.borderColor = RGBACOLOR(138, 43, 226, 1.0).CGColor;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
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
    dateLabel.text = @"10月9日";
    dateLabel.font = [UIFont systemFontOfSize:15];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.textColor = [UIColor whiteColor];
    [dateView addSubview:dateLabel];
    return dateView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HealthyDetailViewController *healthyDetailVC = [[HealthyDetailViewController alloc] init];
    [self.navigationController pushViewController:healthyDetailVC animated:YES];
}

@end
