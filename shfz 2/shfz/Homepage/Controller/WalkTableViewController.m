//
//  WalkTableViewController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/10/24.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "WalkTableViewController.h"

@interface WalkTableViewController ()

@end

@implementation WalkTableViewController

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
    return self.walking.steps.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *str = @"steps";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    AMapStep *step = self.walking.steps[indexPath.row];
    cell.textLabel.text = step.instruction;
    
    return cell;
}


@end
