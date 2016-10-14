//
//  BusRouteViewController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/10/17.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "BusRouteViewController.h"
#import "BusDetailViewController.h"

#import "BusRouteCell.h"

@interface BusRouteViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BusRouteViewController

#pragma mark - setValueforCell
- (NSString *)setValueforCellWithTransit:(AMapTransit *)transit Type:(NSString *)type{
    NSInteger stationNum = 0;//几站
    NSString *busLinesName = [NSString string];//公交线路名称
    for (NSInteger i = 0; i < transit.segments.count-1; i++) {
        NSArray *segmentArr = transit.segments;
        NSArray *buslineArr = [[segmentArr objectAtIndex:i] buslines];
        NSArray *viaBusStopArr = [[buslineArr firstObject] viaBusStops];
        NSInteger temp = viaBusStopArr.count;
        stationNum += temp;
        NSString *tempStr = [[buslineArr firstObject] name];
        if (i == 0&&tempStr!=NULL) {
            busLinesName = tempStr;
        }else if(tempStr!=NULL) {
            busLinesName = [NSString stringWithFormat:@"%@-%@",busLinesName,tempStr];
        }
    }
    if ([type isEqualToString:@"routeLabel"]) {
        return busLinesName;
    }else if([type isEqualToString:@"routeDetailLabelHour"]) {
        return [NSString stringWithFormat:@"%ld小时%ld分钟 | %ld站 | 步行%ld米 | 车费%.f元", transit.duration/3600, transit.duration%3600/60, stationNum, transit.walkingDistance, transit.cost];
    }
    return [NSString stringWithFormat:@"%ld分钟 | %ld站 | 步行%ld米 | 车费%.f元", transit.duration/60, stationNum, transit.walkingDistance, transit.cost];
}

- (NSString *)setHiddenforCellSortTimeLabelWithTransit:(AMapTransit *)transit{
    /* 时间短&步行少 */
    AMapTransit *transitMin = [self.route.transits objectAtIndex:0];
    NSInteger durationMin = transitMin.duration;
    NSInteger walkMin = transitMin.walkingDistance;
    for (NSInteger i = 0; i < self.route.transits.count; i++) {
        AMapTransit *transitTemp = [self.route.transits objectAtIndex:i];
        NSInteger durationTemp = transitTemp.duration;
        NSInteger walkTemp = transitTemp.walkingDistance;
        if (durationTemp < durationMin) {
            durationMin = durationTemp;
        }
        if (walkTemp < walkMin) {
            walkMin = walkTemp;
        }
    }
    if (durationMin == transit.duration) {
        return @"sortTime";
    }
    if (walkMin == transit.walkingDistance && durationMin != transit.duration) { //时间短优先
        return @"sortWalk";
    }
    return nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.route.transits.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"推荐路线";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *str = @"busRouteCell";
    BusRouteCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[BusRouteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    
    AMapTransit *transit = [self.route.transits objectAtIndex:indexPath.row];//公交方案
    NSString *isSortTime = [self setHiddenforCellSortTimeLabelWithTransit:transit];
    if ([isSortTime isEqualToString:@"sortTime"]) {
        cell.sortTimeLabel.hidden = NO;
    }
    if ([isSortTime isEqualToString:@"sortWalk"]) { //时间短优先
        cell.sortTimeLabel.hidden = NO;
        cell.sortTimeLabel.backgroundColor = RGBACOLOR(255, 64, 64, 1.0);
        cell.sortTimeLabel.text = @"少步行";
    }
    /* 给cell赋值 */
    cell.routeLabel.text = [self setValueforCellWithTransit:transit Type:@"routeLabel"];
    if (transit.duration/60 >= 60) {
        cell.routeDetailLabel.text = [self setValueforCellWithTransit:transit Type:@"routeDetailLabelHour"];
    }else {
        cell.routeDetailLabel.text = [self setValueforCellWithTransit:transit Type:@"routeDetailLabelMinute"];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AMapTransit *transit = [self.route.transits objectAtIndex:indexPath.row];//公交方案
    BusDetailViewController *busDetailController = [[BusDetailViewController alloc] init];
    busDetailController.transit = transit;
    [self.navigationController pushViewController:busDetailController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark - Initialization

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BusRouteCell" bundle:nil] forCellReuseIdentifier:@"busRouteCell"];
}

- (void)initTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] init];
    
    titleLabel.backgroundColor  = [UIColor clearColor];
    titleLabel.textColor        = [UIColor whiteColor];
    titleLabel.text             = title;
    [titleLabel sizeToFit];
    
    self.navigationItem.titleView = titleLabel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTitle:@"公交路线"];
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
