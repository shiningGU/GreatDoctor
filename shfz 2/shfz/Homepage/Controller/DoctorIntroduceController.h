//
//  DoctorIntroduceController.h
//  shfz
//
//  Created by shanghaifuzhong on 15/10/12.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoctorIntroduceController : UITableViewController
@property (nonatomic, strong)NSString *type;// 是否在线专家
@property (nonatomic, strong)UIViewController *lastViewController;// 上一层viewcontroller

@end
