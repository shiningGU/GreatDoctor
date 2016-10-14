//
//  HomeCollectionViewCell.m
//  shfz
//
//  Created by shanghaifuzhong on 15/8/4.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@implementation HomeCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.homeCollectionImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.homeCollectionImage];
        
        self.homeLabel = [[UILabel alloc] init];
        self.homeLabel.textColor = [UIColor grayColor];
        self.homeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.homeLabel];
        
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    if (iPhone4) {
        
        self.homeCollectionImage.frame = CGRectMake(0, 0, self.contentView.frame.size.height-10, self.contentView.frame.size.height-10);
        self.homeCollectionImage.center = CGPointMake(self.contentView.frame.size.width/2, (self.contentView.frame.size.height-10)/2);
        self.homeLabel.frame = CGRectMake(0, self.homeCollectionImage.frame.size.height+5, self.contentView.frame.size.width, self.contentView.frame.size.height-self.homeCollectionImage.frame.size.height);
    }else{
        self.homeCollectionImage.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.width);
        self.homeLabel.frame = CGRectMake(0, self.homeCollectionImage.frame.size.height, self.contentView.frame.size.width, self.contentView.frame.size.height-self.homeCollectionImage.frame.size.height);
    }
    
}


@end
