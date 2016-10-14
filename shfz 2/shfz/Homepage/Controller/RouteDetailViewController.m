//
//  RouteDetailViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-19.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "RouteDetailViewController.h"
#import "RouteDetailCell.h"

@interface RouteDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RouteDetailViewController
@synthesize tableView   = _tableView;
@synthesize route       = _route;


#pragma mark - Utility

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    
    AMapPath *path = self.route.paths[0];
    AMapStep *step = path.steps[indexPath.row-1];
    
    title = step.instruction;
    
    return title;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        /* 步行, 驾车方案. */
        AMapPath *path = self.route.paths[0];
        return path.steps.count+2;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"";
    }
    else
    {
        /* 步行方案. */
        if (self.routePlanningType == AMapRoutePlanningTypeWalk)
        {
            return @"步行 路线方案列表";
        }
        /* 驾车方案. */
        else
        {
            return @"驾车 路线方案列表";
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *str = @"routeDetail";
        RouteDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[RouteDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.routeLabel.text = [NSString stringWithFormat:@"我的位置>%@", self.poi.name];
        cell.routeLabel.textColor = RGBACOLOR(255, 165, 0, 1.0);
        AMapPath *myPath = [self.route.paths objectAtIndex:0];
        if (myPath.duration/60 >= 60) {
            cell.timeLabel.text = [NSString stringWithFormat:@"%ld小时%ld分钟",myPath.duration/3600, myPath.duration%3600/60];
        }else {
            cell.timeLabel.text = [NSString stringWithFormat:@"%ld分钟",myPath.duration/60];
        }
        cell.distanceLabel.text = [NSString stringWithFormat:@"%ld米", myPath.distance];
        cell.payLabel.text = [NSString stringWithFormat:@"%.f元", self.route.taxiCost];
        return cell;
    }else {
        AMapPath *path = self.route.paths[0];
        if (indexPath.row == 0) {
            static NSString *str = @"myLocation";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.imageView.image = [UIImage imageNamed:@"greenRing.png"];
            cell.textLabel.text = @"我的位置";
            cell.textLabel.textColor = RGBACOLOR(102, 205, 170, 1.0);
            
            return cell;
        }else if (indexPath.row == path.steps.count+1) {
            static NSString *str = @"mudidi";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.imageView.image = [UIImage imageNamed:@"redRing.png"];
            cell.textLabel.text = @"达到终点";
            cell.textLabel.textColor = RGBACOLOR(205, 106, 106, 1.0);
            return cell;
        }else {
            static NSString *pathDetailCellIdentifier = @"pathDetailCellIdentifier";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pathDetailCellIdentifier];
            
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:pathDetailCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType  = UITableViewCellAccessoryNone;
            cell.textLabel.text         = [self titleForIndexPath:indexPath];
            return cell;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    }
    return 45;
}

#pragma mark - Initialization

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RouteDetailCell" bundle:nil] forCellReuseIdentifier:@"routeDetail"];
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

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTitle:@"导航方案"];
    
    [self initTableView];
}

@end
