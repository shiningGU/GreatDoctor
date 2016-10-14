//
//  RegisterViewController.h
//  shfz
//
//  Created by shanghaifuzhong on 15/7/31.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : BasicViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *getKey;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

- (IBAction)getKey:(id)sender;
- (IBAction)agreement:(id)sender;
- (IBAction)userGuide:(id)sender;
- (IBAction)registerAction:(id)sender;
- (IBAction)backToLogin:(id)sender;



@end
