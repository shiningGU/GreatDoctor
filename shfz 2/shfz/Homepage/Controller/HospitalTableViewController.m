//
//  HospitalTableViewController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/10/13.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "HospitalTableViewController.h"
#import "POIAnnotation.h"
#import "HospitalMapViewController.h"
#import "NearbyHospitalCell.h"

@interface HospitalTableViewController ()
@property (nonatomic, strong)NSMutableArray *annotations;// 附近医院标注点数组
@property (nonatomic, strong)MAUserLocation *myLocation;// 当前地点

@end

@implementation HospitalTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 获取附近医院的标注信息通知
    NSNotificationCenter *getAnnotationCenter = [NSNotificationCenter defaultCenter];
    [getAnnotationCenter addObserver:self selector:@selector(getAnnotationNotification:) name:@"getAnnotation" object:nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NearbyHospitalCell" bundle:nil] forCellReuseIdentifier:@"NearbyHospitalCell"];
}

- (void)getAnnotationNotification:(NSNotification *)noti {
    self.myLocation = [[NSMutableArray arrayWithArray:[(NSDictionary *)noti.object objectForKey:@"start"]] firstObject];
    self.annotations  = [NSMutableArray arrayWithArray:[(NSDictionary *)noti.object objectForKey:@"end"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%ld",self.annotations.count);
    for (int i = 0; i < self.annotations.count; i++) {
        NSLog(@"%d, %f, %f",i,[[self.annotations objectAtIndex:i] coordinate].latitude,[[self.annotations objectAtIndex:i] coordinate].longitude);
    }
    return self.annotations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *str = @"NearbyHospitalCell";
    NearbyHospitalCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    if (!cell) {
        cell = [[NearbyHospitalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    
    cell.hospitalName.text = [[self.annotations objectAtIndex:indexPath.row] title];
    cell.hospitalAddress.text = [[self.annotations objectAtIndex:indexPath.row] subtitle];
    
    //1.将两个经纬度点转成投影点
    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(self.myLocation.coordinate.latitude,self.myLocation.coordinate.longitude));
    POIAnnotation *annotation = [self.annotations objectAtIndex:indexPath.row];
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude));
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    cell.distance.text = [NSString stringWithFormat:@"%ld米", (NSInteger)distance];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = [NSString stringWithFormat:@"%ld", indexPath.row];
    // 利用通知传递弹出窗口
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getAnnotationWindow" object:str];
    
    // 利用通知跳转地图
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getSelectHospital" object:@"NO"];
}


@end
