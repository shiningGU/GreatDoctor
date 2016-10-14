//
//  RegisterViewController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/7/31.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserGuideViewController.h"

#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/SMSSDKCountryAndAreaCode.h>
#import <SMS_SDK/SMSSDK+DeprecatedMethods.h>
#import <SMS_SDK/SMSSDK+ExtexdMethods.h>

@interface RegisterViewController ()<UITextFieldDelegate, UIAlertViewDelegate>
{
    NSMutableArray* _areaArray;
    NSString* _str;
    BOOL _isAgree;
    NSInteger _currentTime;
    NSTimer * _timer;
    UIAlertView *_alert3;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _isAgree = YES;
    [self initView];
    
    //获取支持的地区列表
    [SMSSDK getCountryZone:^(NSError *error, NSArray *zonesArray) {
        
        if (!error) {
            
            NSLog(@"get the area code sucessfully");
            //区号数据
            _areaArray = [NSMutableArray arrayWithArray:zonesArray];
            //            NSLog(@"_areaArray_%@",_areaArray);
            
        }
        else
        {
            
            NSLog(@"failed to get the area code _%@",[error.userInfo objectForKey:@"getZone"]);
            
        }
        
    }];
}

#pragma mark - View
- (void)initView
{
    layerCornerRadius(_registerBtn,20);
    layerCornerRadius(_getKey, 10);
    layerCornerRadius(_phoneNumTF, 15);
    layerCornerRadius(_numberTF, 15);
    layerCornerRadius(_passwordTF, 15);
    self.phoneNumTF.layer.borderWidth = 0.2;
    self.numberTF.layer.borderWidth = 0.2;
    self.passwordTF.layer.borderWidth = 0.2;
    self.phoneNumTF.backgroundColor = [UIColor whiteColor];
    self.numberTF.backgroundColor = [UIColor whiteColor];
    self.passwordTF.backgroundColor = [UIColor whiteColor];
    
    self.phoneNumTF.delegate = self;
    self.numberTF.delegate = self;
    self.passwordTF.delegate = self;
}


#pragma mark - 设置该页面stusbar为黑色，退出后为白色
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
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
    [_phoneNumTF resignFirstResponder];
    [_numberTF resignFirstResponder];
    [_passwordTF resignFirstResponder];
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

#pragma mark - 获取短信验证码
- (IBAction)getKey:(id)sender {
    
    int compareResult = 0;
    for (int i = 0; i<_areaArray.count; i++)
    {
        NSDictionary* dict1 = [_areaArray objectAtIndex:i];
        NSString* code1 = [dict1 valueForKey:@"zone"];
        NSString* areaCode = [NSString stringWithFormat:@"+86"];
        if ([code1 isEqualToString:areaCode])
        {
            compareResult = 1;
            NSString* rule1 = [dict1 valueForKey:@"rule"];
            NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",rule1];
            BOOL isMatch = [pred evaluateWithObject:self.phoneNumTF.text];
            if (!isMatch)
            {
                //手机号码不正确
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"notice", nil)
                                                                message:NSLocalizedString(@"errorphonenumber", nil)
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                      otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            break;
        }
    }
    
    if (!compareResult)
    {
        if (self.phoneNumTF.text.length!=11)
        {
            //手机号码不正确
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"notice", nil)
                                                            message:NSLocalizedString(@"errorphonenumber", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                  otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    
    NSString* str = [NSString stringWithFormat:@"%@:%@ %@",NSLocalizedString(@"willsendthecodeto", nil),@"+86",self.phoneNumTF.text];
    _str = [NSString stringWithFormat:@"%@",self.phoneNumTF.text];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"surephonenumber", nil)
                                                    message:str delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                          otherButtonTitles:NSLocalizedString(@"sure", nil), nil];
    [alert show];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex)
    {
        NSString* str2 = [NSString stringWithFormat:@"86"];
        
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneNumTF.text zone:str2 customIdentifier:nil result:^(NSError *error)
         {
             if (!error)
             {
                 NSLog(@"验证码发送成功");
                 _currentTime = 10;
                 //开始倒计时
                 _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(timerCountDown)
                                                        userInfo:nil
                                                         repeats:YES];

             }
             else
             {
                 UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil)
                                                               message:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"getVerificationCode"]]
                                                              delegate:self
                                                     cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                     otherButtonTitles:nil, nil];
                 [alert show];
             }
             
         }];
    }
}

#pragma mark - 等待时间
-(void)timerCountDown{
    if (_currentTime>0) {
        _currentTime --;
        self.getKey.enabled = NO;
        [self.getKey setTitle:[NSString stringWithFormat:@"%ds",(int)_currentTime] forState:UIControlStateNormal];
    }else{
        self.getKey.enabled = YES;
        [self.getKey setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_timer invalidate];
    }
}


#pragma mark - 同意条例
- (IBAction)agreement:(id)sender {
    
    if (_isAgree == YES) {
        _isAgree = NO;
        [self.agreeBtn setImage:[UIImage imageNamed:@"iconfont-quan-2.png"] forState:UIControlStateNormal];
    }else {
        _isAgree = YES;
        [self.agreeBtn setImage:[UIImage imageNamed:@"iconfont-quan.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)userGuide:(id)sender {
    UserGuideViewController *ug = [[UserGuideViewController alloc] init];
    UINavigationController *naviUG = [[UINavigationController alloc] initWithRootViewController:ug];
    [self presentViewController:naviUG animated:YES completion:^{
        
    }];
    
}

#pragma mark - 提交验证码
- (void)submit
{
    if(self.numberTF.text.length != 4)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"notice", nil)
                                                        message:NSLocalizedString(@"verifycodeformaterror", nil)
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSString* str2 = [NSString stringWithFormat:@"86"];
        [SMSSDK commitVerificationCode:self.numberTF.text phoneNumber:self.phoneNumTF.text zone:str2 result:^(NSError *error)
        {
            if (!error)
            {
                NSLog(@"验证成功");
                NSString* str = [NSString stringWithFormat:NSLocalizedString(@"verifycoderightmsg", nil)];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"verifycoderighttitle", nil)
                                                                message:str
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                      otherButtonTitles:nil, nil];
                [alert show];
                _alert3 = alert;
            }
            else
            {
                NSLog(@"验证失败");
                NSString* str = [NSString stringWithFormat:NSLocalizedString(@"verifycodeerrormsg", nil)];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"verifycodeerrortitle", nil)
                                                                message:str
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                      otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }

}

#pragma mark - 注册
- (IBAction)registerAction:(id)sender {
    if (![self.phoneNumTF.text isEqualToString:@""]) {
        [self submit];
        if (![self.passwordTF.text isEqualToString:@""]) {
            if (self.passwordTF.text.length >= 6 && self.passwordTF.text.length <= 20) {
                
            }else {
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"请输入6~20位密码！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alter show];
            }
        }else {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"请输入6~20位密码！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alter show];
        }
    }else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"请输入手机号！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alter show];
    }
    
}

- (IBAction)backToLogin:(id)sender {
    [self dismissViewControllerAnimated:YES
completion:^{
    
}];
}
@end
