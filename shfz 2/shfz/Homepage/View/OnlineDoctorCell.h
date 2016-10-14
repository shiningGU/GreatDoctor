//
//  OnlineDoctorCell.h
//  shfz
//
//  Created by shanghaifuzhong on 15/10/10.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnlineDoctorCell : UITableViewCell
@property (nonatomic, strong)UIViewController *lastViewController;
@property (nonatomic, strong)UIViewController *nextViewController;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *professionLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *officeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *questionBtn;

- (IBAction)questionAction:(id)sender;

@end
