//
//  AnswerViewController.h
//  shfz
//
//  Created by shanghaifuzhong on 15/8/5.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoCollectionViewCell.h"
#import "DKImageBrowser.h"
#import "DKModalImageBrowser.h"

@interface AnswerViewController : UIViewController

@property (weak, nonatomic) IBOutlet PlaceholderTextView *questionText;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
@property (weak, nonatomic) IBOutlet UILabel *uploadLable;
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *womenBtn;
@property (weak, nonatomic) IBOutlet UITextField *ageText;
@property (weak, nonatomic) IBOutlet UIButton *yearBtn;
@property (weak, nonatomic) IBOutlet UIButton *monthBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UILabel *selectSexLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoCollectionHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downViewTop;

- (IBAction)upload:(id)sender;
- (IBAction)manAction:(id)sender;
- (IBAction)monthAction:(id)sender;
- (IBAction)commitAction:(id)sender;
- (IBAction)recyclingKeyboard:(id)sender;
- (IBAction)womenAction:(id)sender;
- (IBAction)yearAction:(id)sender;
@end
