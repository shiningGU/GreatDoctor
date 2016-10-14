//
//  BusDetailViewController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/10/21.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "BusDetailViewController.h"
#import "BusRouteViewController.h"
#import "WalkTableViewController.h"

@interface BusDetailViewController ()
{
    BOOL _isDidSelect;
    NSInteger _didSection;
    NSInteger _endSection;
    NSInteger _addCellNum;
    NSMutableDictionary *_cellDic;
}

@end

@implementation BusDetailViewController

#pragma mark - initCellTitle
- (NSString *)titleForIndexPath:(NSInteger)section
{
    NSString *title = nil;
    
    if (section < self.transit.segments.count*2) {
        
        AMapSegment *segment = self.transit.segments[(section-2)/2];
        AMapBusLine *busline = [segment.buslines firstObject];
        title = [NSString stringWithFormat:@"%@", busline.departureStop.name];
    }else if (section == self.transit.segments.count*2) {
        
        AMapSegment *segment = self.transit.segments[(section-4)/2];
        AMapBusLine *busline = [segment.buslines firstObject];
        title = [NSString stringWithFormat:@"%@", busline.arrivalStop.name];
        
    }else if (section == (self.transit.segments.count+1)*2) {
        title = @"步行";
    }
    
    return title;
}

- (NSString *)detailTitleForIndexPath:(NSInteger)section
{
    NSString *title = nil;
    if (section < self.transit.segments.count*2) {
        
        AMapSegment *segment = self.transit.segments[(section-2)/2];
        AMapBusLine *busline = [segment.buslines firstObject];
        title = [NSString stringWithFormat:@"%ld站", busline.viaBusStops.count];
    }
    return title;
}

#pragma mark - initUpView
- (void)initUpView {
    BusRouteViewController *busRoute = [[BusRouteViewController alloc] init];
    self.busLine.text = [busRoute setValueforCellWithTransit:_transit Type:@"routeLabel"];
    if (_transit.duration/60 >= 60) {
        self.busLineDetail.text = [busRoute setValueforCellWithTransit:_transit Type:@"routeDetailLabelHour"];
    }else {
        self.busLineDetail.text = [busRoute setValueforCellWithTransit:_transit Type:@"routeDetailLabelMinute"];
    }
}

#pragma mark - tableviewdataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.transit.segments.count + 1)*2+3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /* 遍历cellDic所有key获取被点击section设置row */
    NSArray* arr = [_cellDic allKeys];
    for(NSString* str in arr)
    {
        if (section == str.integerValue) {
            _addCellNum = [[_cellDic objectForKey:str] integerValue];
            return _addCellNum;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *str = @"busDetail";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"blueRing.png"];
    
    AMapSegment *segment = self.transit.segments[(indexPath.section-2)/2];
    AMapBusLine *busline = [segment.buslines firstObject];
    AMapBusStop *busStop = busline.viaBusStops[indexPath.row];
    cell.textLabel.text = busStop.name;
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    titleView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (titleView.frame.size.height-32)/2, 32, 32)];
    [titleView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 10, self.view.frame.size.width-97, 20)];
    [titleView addSubview:titleLabel];
    
    if (section%2 == 0 && section != 0 && section != (self.transit.segments.count + 1)*2+2) {
        if (section == (self.transit.segments.count+1)*2 ) {
            imageView.image = [UIImage imageNamed:@"man.png"];
        }else
            imageView.image = [UIImage imageNamed:@"bus.png"];
        titleLabel.text = [self titleForIndexPath:section];
        if (section < self.transit.segments.count*2 || section == (self.transit.segments.count+1)*2) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.frame = CGRectMake(self.view.frame.size.width-50, 0, 50, titleView.frame.size.height);
            btn.backgroundColor = [UIColor clearColor];
            [btn setTag:section];
            if (section == (self.transit.segments.count+1)*2) {
                [btn setTitle:@"路线" forState:UIControlStateNormal];
            }else
                [btn setTitle:[self detailTitleForIndexPath:section] forState:UIControlStateNormal];
            
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn addTarget:self action:@selector(addCell:) forControlEvents:UIControlEventTouchUpInside];
            [titleView addSubview:btn];
        }
    }else if (section == 0) {
        imageView.frame = CGRectMake(18, (titleView.frame.size.height-16)/2, 16, 16);
        imageView.image = [UIImage imageNamed:@"greenRing.png"];
        titleLabel.text = @"我的位置";
        titleLabel.textColor = RGBACOLOR(102, 205, 170, 1.0);
    }else if (section == (self.transit.segments.count + 1)*2+2) {
        imageView.frame = CGRectMake(18, (titleView.frame.size.height-16)/2, 16, 16);
        imageView.image = [UIImage imageNamed:@"redRing.png"];
        titleLabel.text = @"达到终点";
        titleLabel.textColor = RGBACOLOR(205, 106, 106, 1.0);
    }else {
        imageView.image = [UIImage imageNamed:@"xuxian.png"];
    }
    
    return titleView;
}

- (void)addCell:(UIButton *)btn{
    if (btn.tag == (self.transit.segments.count+1)*2) {
        WalkTableViewController *walkTableviewController = [[WalkTableViewController alloc] init];
        AMapSegment *segment = [self.transit.segments lastObject];
        walkTableviewController.walking = segment.walking;
        [self.navigationController pushViewController:walkTableviewController animated:YES];
    }
    
    if (btn.tag%2 == 0 && btn.tag != 0 && btn.tag != (self.transit.segments.count + 1)*2+2) {
        
        NSArray* arr = [_cellDic allKeys];
        if (arr.count == 0) {
            _isDidSelect = NO;
            [self didSelectCellRowFirstDo:_isDidSelect button:btn];
            
        }else {
            if ([arr indexOfObject:[NSString stringWithFormat:@"%ld", btn.tag]] != NSNotFound) {
                _isDidSelect = YES;
                [self didSelectCellRowFirstDo:_isDidSelect button:btn];
            }else {
                _isDidSelect = NO;
                [self didSelectCellRowFirstDo:_isDidSelect button:btn];
            }
        }
    }
}

- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert button:(UIButton *)btn{
    if (btn.tag != (self.transit.segments.count+1)*2) {
        [self.busLineTableView beginUpdates];
        
        AMapSegment *segment = self.transit.segments[(btn.tag-2)/2];
        AMapBusLine *busline = [segment.buslines firstObject];
        NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < busline.viaBusStops.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:btn.tag];
            [rowToInsert addObject:indexPath];
        }
        _addCellNum = busline.viaBusStops.count;
        if (firstDoInsert == YES) {
            
            [_cellDic removeObjectForKey:[NSString stringWithFormat:@"%ld", btn.tag]];
            [self.busLineTableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationFade];
        }else {
            
            NSString *count = [NSString stringWithFormat:@"%ld", busline.viaBusStops.count];
            NSString *section = [NSString stringWithFormat:@"%ld", btn.tag];
            [_cellDic setObject:count forKey:section];
            [self.busLineTableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationFade];
        }
        
        [self.busLineTableView endUpdates];
    }
}

#pragma mark - initToolBar
- (void)initToolBar {
    UIBarButtonItem *flexbleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *collectItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"collect.png"] style:UIBarButtonItemStyleDone target:self action:@selector(collectAction)];
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share.png"] style:UIBarButtonItemStyleDone target:self action:@selector(shareAction)];
    
    self.toolbarItems = [NSArray arrayWithObjects:flexbleItem, collectItem, flexbleItem, shareItem, flexbleItem, nil];
}

- (void)collectAction {
    
}

- (void)shareAction {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _cellDic = [NSMutableDictionary dictionary];
    [self initUpView];
    [self initToolBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.toolbar.barStyle      = UIBarStyleDefault;
    self.navigationController.toolbar.translucent   = YES;
    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:animated];
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
