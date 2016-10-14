//
//  NearbyHospitalCell.h
//  shfz
//
//  Created by shanghaifuzhong on 15/10/16.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearbyHospitalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hospitalName;
@property (weak, nonatomic) IBOutlet UILabel *hospitalAddress;
@property (weak, nonatomic) IBOutlet UILabel *distance;

@end
