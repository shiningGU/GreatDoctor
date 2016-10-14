//
//  MyTableViewCell.m
//  shfz
//
//  Created by shanghaifuzhong on 15/10/24.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.photoImage.layer.masksToBounds = YES;
    layerCornerRadius(self.photoImage, self.photoImage.frame.size.width/2);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
