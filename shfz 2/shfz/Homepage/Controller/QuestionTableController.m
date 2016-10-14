//
//  QuestionTableController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/10/7.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "QuestionTableController.h"
#import "QuestionTableCell.h"

@interface QuestionTableController ()

@end

@implementation QuestionTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"QuestionTableCell" bundle:nil] forCellReuseIdentifier:@"QuestionTableCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *str = @"QuestionTableCell";
    QuestionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[QuestionTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

@end
