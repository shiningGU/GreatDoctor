//
//  MyQuestionTController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/10/12.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "MyQuestionTController.h"

@interface MyQuestionTController ()

@end

@implementation MyQuestionTController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *str = @"myquestion";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    cell.textLabel.text = @"非常奇怪，女儿每年一到这么个时间就会开始频繁的打喷嚏、流鼻血，现在天天早起打喷嚏，连着打";
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
