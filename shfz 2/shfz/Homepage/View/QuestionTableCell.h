//
//  QuestionTableCell.h
//  shfz
//
//  Created by shanghaifuzhong on 15/10/7.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *answerCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerText;
@property (weak, nonatomic) IBOutlet UILabel *timeText;

@end
