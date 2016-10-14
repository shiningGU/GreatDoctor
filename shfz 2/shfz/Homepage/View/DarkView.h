//
//  DarkView.h
//  shfz
//
//  Created by shanghaifuzhong on 15/9/29.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DarkView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain)UITableView *funcTableView;
@property (nonatomic, retain)NSArray *funcArray;
@property (nonatomic, retain)NSArray *picArray;

@end
