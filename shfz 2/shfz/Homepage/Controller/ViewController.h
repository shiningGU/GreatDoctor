//
//  ViewController.h
//  shfz
//
//  Created by shanghaifuzhong on 15/7/30.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)registerAction:(id)sender;
- (IBAction)loginAction:(id)sender;
- (IBAction)qqLogin:(id)sender;
- (IBAction)weiboLogin:(id)sender;
- (IBAction)weixinLogin:(id)sender;


@end

