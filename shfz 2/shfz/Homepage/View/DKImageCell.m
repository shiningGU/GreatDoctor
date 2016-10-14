//
//  DKImageCell.m
//  shfz
//
//  Created by shanghaifuzhong on 15/8/6.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "DKImageCell.h"

@implementation DKImageCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.DKImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.DKImageView];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.DKImageView.image = nil;
}

@end
