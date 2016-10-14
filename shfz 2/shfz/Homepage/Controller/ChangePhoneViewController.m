//
//  ChangePhoneViewController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/10/5.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "ChangePhoneViewController.h"
#import "VerifyViewController.h"
#import "SubmitViewController.h"

#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/SMSSDKCountryAndAreaCode.h>
#import <SMS_SDK/SMSSDK+DeprecatedMethods.h>
#import <SMS_SDK/SMSSDK+ExtexdMethods.h>

@interface ChangePhoneViewController ()<UITextFieldDelegate, UIAlertViewDelegate>
{
    NSMutableArray* _areaArray;
    NSString* _str;
    BOOL _isAgree;
    NSInteger _currentTime;
    NSTimer * _timer;
}

@end

@implementation ChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
    layerCornerRadius(_smsBtn,20);
    layerCornerRadius(_callBtn, 20);
    layerCornerRadius(_phoneTextFile, 15);
    self.phoneTextFile.layer.borderWidth = 0.2;
    self.phoneTextFile.backgroundColor = [UIColor whiteColor];
    
    self.phoneTextFile.delegate = self;
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
    [_phoneTextFile resignFirstResponder];
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

#pragma  mark - 短信验证码
- (IBAction)getSMS:(id)sender {
    [self getCodeWithType:@"sms"];
}

#pragma mark - 语音验证码
- (IBAction)getCall:(id)sender {
    [self getCodeWithType:@"call"];
}

- (void)getCodeWithType:(NSString *)type
{
    [_phoneTextFile resignFirstResponder];
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
            BOOL isMatch = [pred evaluateWithObject:self.phoneTextFile.text];
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
        if (self.phoneTextFile.text.length!=11)
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
    
    NSString* str = [NSString stringWithFormat:@"%@:%@ %@",NSLocalizedString(@"willsendthecodeto", nil),@"+86",self.phoneTextFile.text];
    _str = [NSString stringWithFormat:@"%@",self.phoneTextFile.text];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"surephonenumber", nil)
                                                    message:str delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                          otherButtonTitles:NSLocalizedString(@"sure", nil), nil];
    if ([type isEqualToString:@"sms"]) {
        alert.tag = 1;
    }else if ([type isEqualToString:@"call"]){
        alert.tag = 0;
    }
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex && alertView.tag == 1)
    {
        VerifyViewController* verify = [[VerifyViewController alloc] init];
        if ([self.getWay isEqualToString:@"newphone"]) {
            verify.getWay = self.getWay;
        }
        NSString* str2 = [NSString stringWithFormat:@"86"];
        [verify setPhone:self.phoneTextFile.text AndAreaCode:str2];
        
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneTextFile.text zone:str2 customIdentifier:nil result:^(NSError *error)
         {
             if (!error)
             {
                 NSLog(@"验证码发送成功");
                 [self presentViewController:verify animated:YES completion:^{
                     self.title = @"绑定新手机";
                     self.getWay = @"newphone";
                     self.phoneTextFile.placeholder = @"请输入新的手机号";
                     self.phoneTextFile.text = nil;
                 }];
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
    }else if (1 == buttonIndex && alertView.tag == 0){
        SubmitViewController* verify = [[SubmitViewController alloc] init];
        if ([self.getWay isEqualToString:@"newphone"]) {
            verify.getWay = self.getWay;
        }
        NSString* str2 = [NSString stringWithFormat:@"86"];
        [verify setPhone:self.phoneTextFile.text AndAreaCode:str2];
        
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodVoice phoneNumber:self.phoneTextFile.text zone:str2 customIdentifier:nil result:^(NSError *error)
         {
             
             if (!error)
             {
                 [self presentViewController:verify animated:YES completion:^{
                     self.title = @"绑定新手机";
                     self.getWay = @"newphone";
                     self.phoneTextFile.placeholder = @"请输入新的手机号";
                     self.phoneTextFile.text = nil;
                 }];
             }
             else
             {
                 UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil)
                                                                 message:[NSString stringWithFormat:@"错误描述：%@",[error.userInfo objectForKey:@"getVerificationCode"]]
                                                                delegate:self
                                                       cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                       otherButtonTitles:nil, nil];
                 [alert show];
             }
             
         }];
    }
}
@end
