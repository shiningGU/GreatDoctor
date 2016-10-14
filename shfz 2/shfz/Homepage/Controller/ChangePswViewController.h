//
//  ChangePswViewController.h
//  shfz
//
//  Created by shanghaifuzhong on 15/9/30.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePswViewController : BasicViewController
@property (weak, nonatomic) IBOutlet UITextField *originalPsw;
@property (weak, nonatomic) IBOutlet UITextField *pswNew;
@property (weak, nonatomic) IBOutlet UITextField *againNewPsw;
- (IBAction)changePswAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *changePswBtn;

@end
