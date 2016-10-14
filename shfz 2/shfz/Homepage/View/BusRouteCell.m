//
//  BusRouteCell.m
//  shfz
//
//  Created by shanghaifuzhong on 15/10/17.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "BusRouteCell.h"

@implementation BusRouteCell

- (void)awakeFromNib {
    // Initialization code
    self.sortTimeLabel.layer.masksToBounds = YES;
    layerCornerRadius(self.sortTimeLabel, 8);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
