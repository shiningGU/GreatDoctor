//
//  AnsweredController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/10/12.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "AnsweredController.h"

@interface AnsweredController ()

@end

@implementation AnsweredController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"精彩回答";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *str = @"answered";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    cell.textLabel.text = @"我鼻出血有10年左右，家族中多人有此症状。在武汉人民附属五官科医院就诊多次，诊断为毛细血管扩";
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.numberOfLines = 2;
    cell.detailTextLabel.text = @"01月08日 20:08";
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

@end
