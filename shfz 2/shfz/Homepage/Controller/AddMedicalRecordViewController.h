//
//  AddMedicalRecordViewController.h
//  shfz
//
//  Created by shanghaifuzhong on 15/10/8.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoCollectionViewCell.h"
#import "DKImageBrowser.h"
#import "DKModalImageBrowser.h"

@interface AddMedicalRecordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *womenBtn;
@property (weak, nonatomic) IBOutlet UITextField *ageText;
@property (weak, nonatomic) IBOutlet UIButton *yearBtn;
@property (weak, nonatomic) IBOutlet UIButton *monthBtn;
@property (weak, nonatomic) IBOutlet PlaceholderTextView *dieaseIntroduce;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UILabel *uploadLabel;
@property (weak, nonatomic) IBOutlet UITextField *wordNumber;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoCollectionHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saveBtnTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;


- (IBAction)upload:(id)sender;
- (IBAction)manAction:(id)sender;
- (IBAction)monthAction:(id)sender;
- (IBAction)recyclingKeyboard:(id)sender;
- (IBAction)womenAction:(id)sender;
- (IBAction)yearAction:(id)sender;
- (IBAction)save:(id)sender;

@end
