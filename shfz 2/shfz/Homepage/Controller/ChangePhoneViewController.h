//
//  ChangePhoneViewController.h
//  shfz
//
//  Created by shanghaifuzhong on 15/10/5.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePhoneViewController : BasicViewController
@property (nonatomic, retain)NSString *getWay;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextFile;
@property (weak, nonatomic) IBOutlet UIButton *smsBtn;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
- (IBAction)getSMS:(id)sender;
- (IBAction)getCall:(id)sender;


@end
