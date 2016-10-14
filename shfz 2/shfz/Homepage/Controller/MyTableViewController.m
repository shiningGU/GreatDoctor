//
//  MyTableViewController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/10/24.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "MyTableViewController.h"
#import "MyTableViewCell.h"

#import "MedicalRecordController.h"
#import "ChangePswViewController.h"
#import "ChangePhoneViewController.h"
#import "SectionsViewControllerFriends.h"

#import <AddressBook/AddressBook.h>
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/SMSSDK+AddressBookMethods.h>
#import <SMS_SDK/SMSSDK+DeprecatedMethods.h>
#import <SMS_SDK/SMSSDK+ExtexdMethods.h>

@interface MyTableViewController ()
{
    NSArray *_titleArr;
    NSArray *_imageArr;
}

@end

@implementation MyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    _titleArr = @[@"我的提问", @"我的收藏", @"电子病历", @"修改密码", @"绑定手机", @"邀请通讯录好友"];
    _imageArr = @[@"ask.png", @"shoucang.png", @"bingli.png", @"mima.png", @"shouji.png", @"friend.png"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:nil] forCellReuseIdentifier:@"mytableviewcell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *str = @"mytableviewcell";
        MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        return cell;
    }
    static NSString *str = @"set";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.imageView.image = [UIImage imageNamed:[_imageArr objectAtIndex:indexPath.row]];
    cell.textLabel.text = [_titleArr objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 120;
    }
    return 45;
}

- (void)getFriends {
    
    SectionsViewControllerFriends* friendsController = [[SectionsViewControllerFriends alloc] init];
    
    [SMSSDK getAllContactFriends:1 result:^(NSError *error, NSArray *friendsArray) {
        
        if (!error) {
            
            [friendsController setMyData:[NSMutableArray arrayWithArray:friendsArray]];
            
            [self presentViewController:friendsController animated:YES completion:^{
                ;
            }];
        }
    }];
    
    if(ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized)
    {
        NSString* str = [NSString stringWithFormat:NSLocalizedString(@"authorizedcontact", nil)];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"notice", nil)
                                                        message:str
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MedicalRecordController *medicalRecord = [[MedicalRecordController alloc] init];
    
    ChangePswViewController *changePswViewController = [[ChangePswViewController alloc] init];
    
    ChangePhoneViewController *changePhoneViewController = [[ChangePhoneViewController alloc] init];
    
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 2:
                [self.navigationController pushViewController:medicalRecord animated:YES];
                break;
                
            case 3:
                [self.navigationController pushViewController:changePswViewController animated:YES];
                break;
            
            case 4:
                [self.navigationController pushViewController:changePhoneViewController animated:YES];
                break;
                
            case 5:
                [self getFriends];
                break;
                
            default:
                break;
        }
    }
}


@end
