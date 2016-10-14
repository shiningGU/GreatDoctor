//
//  BusDetailViewController.h
//  shfz
//
//  Created by shanghaifuzhong on 15/10/21.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface BusDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)AMapTransit *transit;

@property (weak, nonatomic) IBOutlet UILabel *busLine;
@property (weak, nonatomic) IBOutlet UILabel *busLineDetail;
@property (weak, nonatomic) IBOutlet UITableView *busLineTableView;


@end
