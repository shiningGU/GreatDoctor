//
//  BusRouteViewController.h
//  shfz
//
//  Created by shanghaifuzhong on 15/10/17.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface BusRouteViewController : UIViewController
@property (nonatomic, strong) AMapRoute *route;

- (NSString *)setValueforCellWithTransit:(AMapTransit *)transit Type:(NSString *)type;

@end
