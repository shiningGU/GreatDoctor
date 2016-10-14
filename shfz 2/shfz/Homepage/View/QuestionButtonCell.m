//
//  QuestionButtonCell.m
//  shfz
//
//  Created by shanghaifuzhong on 15/10/12.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "QuestionButtonCell.h"

@implementation QuestionButtonCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)questionAction:(id)sender {
    [_lastViewController.navigationController pushViewController:_nextViewController animated:YES];
}
@end
