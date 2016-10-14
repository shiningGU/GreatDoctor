//
//  ChangePswViewController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/9/30.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "ChangePswViewController.h"

@interface ChangePswViewController ()<UITextFieldDelegate>

@end

@implementation ChangePswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

#pragma mark - View
- (void)initView
{
    layerCornerRadius(_changePswBtn,20);
    layerCornerRadius(_originalPsw, 15);
    layerCornerRadius(_pswNew, 15);
    layerCornerRadius(_againNewPsw, 15);
    self.originalPsw.layer.borderWidth = 0.2;
    self.pswNew.layer.borderWidth = 0.2;
    self.againNewPsw.layer.borderWidth = 0.2;
    self.originalPsw.backgroundColor = [UIColor whiteColor];
    self.pswNew.backgroundColor = [UIColor whiteColor];
    self.againNewPsw.backgroundColor = [UIColor whiteColor];
    
    self.originalPsw.delegate = self;
    self.pswNew.delegate = self;
    self.againNewPsw.delegate = self;
}

#pragma mark - 点击空白处收回键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    [_originalPsw resignFirstResponder];
    [_pswNew resignFirstResponder];
    [_againNewPsw resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changePswAction:(id)sender {
}
@end
