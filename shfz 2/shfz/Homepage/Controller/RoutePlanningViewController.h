//
//  RoutePlanningViewController.h
//  shfz
//
//  Created by shanghaifuzhong on 15/10/15.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "POIAnnotation.h"

@interface RoutePlanningViewController : UIViewController
@property (nonatomic, strong) AMapPOI *poi;
@property (nonatomic, strong) MAUserLocation *myLocation;

typedef NS_ENUM(NSInteger, AMapRoutePlanningType)
{
    AMapRoutePlanningTypeDrive = 0,
    AMapRoutePlanningTypeWalk,
    AMapRoutePlanningTypeBus
};

@end
