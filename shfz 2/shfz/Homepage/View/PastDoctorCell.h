//
//  PastDoctorCell.h
//  shfz
//
//  Created by shanghaifuzhong on 15/10/10.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PastDoctorCell : UITableViewCell<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITableView *doctorTableView;

@property (nonatomic, strong)UIViewController *viewController;

@end
