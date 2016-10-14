//
//  QuestionButtonCell.h
//  shfz
//
//  Created by shanghaifuzhong on 15/10/12.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionButtonCell : UITableViewCell
@property (nonatomic, strong)UIViewController *lastViewController;
@property (nonatomic, strong)UIViewController *nextViewController;


@property (weak, nonatomic) IBOutlet UIButton *questionBtn;


- (IBAction)questionAction:(id)sender;
@end
