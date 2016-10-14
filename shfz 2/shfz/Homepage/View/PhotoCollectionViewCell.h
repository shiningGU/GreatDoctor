//
//  PhotoCollectionViewCell.h
//  shfz
//
//  Created by shanghaifuzhong on 15/8/6.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@end
