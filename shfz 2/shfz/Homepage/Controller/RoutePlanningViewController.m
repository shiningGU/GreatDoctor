//
//  RoutePlanningViewController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/10/15.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "RoutePlanningViewController.h"
#import "RouteDetailViewController.h"
#import "BusRouteViewController.h"
#import "CommonUtility.h"
#import "MANaviRoute.h"
#import "APIKey.h"

const NSString *RoutePlanningViewControllerStartTitle       = @"我的位置";
const NSString *RoutePlanningViewControllerDestinationTitle = @"终点";
const NSInteger RoutePlanningPaddingEdge                    = 20;

@interface RoutePlanningViewController ()<MAMapViewDelegate, AMapSearchDelegate>
{
    MAMapView *_mapView;
    AMapSearchAPI *_search;
}

@property (nonatomic, strong) CLLocationManager *locationManager;

/* 路径规划类型 */
@property (nonatomic) AMapRoutePlanningType routePlanningType;

@property (nonatomic, strong) AMapRoute *route;

/* 当前路线方案索引值. */
@property (nonatomic) NSInteger currentCourse;
/* 路线方案个数. */
@property (nonatomic) NSInteger totalCourse;

@property (nonatomic, strong) UIBarButtonItem *previousItem;
@property (nonatomic, strong) UIBarButtonItem *nextItem;

/* 起始点经纬度. */
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;

/* 用于显示当前路线方案. */
@property (nonatomic) MANaviRoute * naviRoute;

@end

@implementation RoutePlanningViewController

- (void)initMapView {
    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager requestAlwaysAuthorization];
    }
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode  = MAUserTrackingModeFollow;
}

- (void)initSearch {
    [AMapSearchServices sharedServices].apiKey = (NSString *)APIKey;
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
}

/* 更新"上一个", "下一个"按钮状态. */
- (void)updateCourseUI
{
    /* 上一个. */
    self.previousItem.enabled = (self.currentCourse > 0);
    
    /* 下一个. */
    self.nextItem.enabled = (self.currentCourse < self.totalCourse - 1);
}

/* 更新"详情"按钮状态. */
- (void)updateDetailUI
{
    self.navigationItem.rightBarButtonItem.enabled = self.route != nil;
}

- (void)updateTotal
{
    NSUInteger total = 0;
    
    if (self.route != nil)
    {
        switch (self.routePlanningType)
        {
            case AMapRoutePlanningTypeDrive   :
            case AMapRoutePlanningTypeWalk    : total = self.route.paths.count;    break;
            case AMapRoutePlanningTypeBus     : total = self.route.transits.count; break;
            default: total = 0; break;
        }
    }
    
    self.totalCourse = total;
}

- (BOOL)increaseCurrentCourse
{
    BOOL result = NO;
    
    if (self.currentCourse < self.totalCourse - 1)
    {
        self.currentCourse++;
        
        result = YES;
    }
    
    return result;
}

- (BOOL)decreaseCurrentCourse
{
    BOOL result = NO;
    
    if (self.currentCourse > 0)
    {
        self.currentCourse--;
        
        result = YES;
    }
    
    return result;
}

/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    /* 公交路径规划. */
    if (self.routePlanningType == AMapRoutePlanningTypeBus)
    {
        if (self.route.transits.count != 0) {
            self.naviRoute = [MANaviRoute naviRouteForTransit:self.route.transits[self.currentCourse]];
        }else {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"没有公交路线" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    /* 步行，驾车路径规划. */
    else
    {
        MANaviAnnotationType type = self.routePlanningType == AMapRoutePlanningTypeDrive ? MANaviAnnotationTypeDrive : MANaviAnnotationTypeWalking;
        self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[self.currentCourse] withNaviType:type];
    }
    
    [self.naviRoute addToMapView:_mapView];
    
    /* 缩放地图使其适应polylines的展示. */
    [_mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
                        edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge)
                           animated:YES];
}

/* 清空地图上已有的路线. */
- (void)clear
{
    [self.naviRoute removeFromMapView];
}

/* 将selectedIndex 转换为响应的AMapRoutePlanningType. */
- (AMapRoutePlanningType)searchTypeForSelectedIndex:(NSInteger)selectedIndex
{
    AMapRoutePlanningType navitgationType = 0;
    
    switch (selectedIndex)
    {
        case 0: navitgationType = AMapRoutePlanningTypeDrive;   break;
        case 1: navitgationType = AMapRoutePlanningTypeWalk; break;
        case 2: navitgationType = AMapRoutePlanningTypeBus;     break;
        default:NSAssert(NO, @"%s: selectedindex = %ld is invalid for RoutePlanning", __func__, (long)selectedIndex); break;
    }
    
    return navitgationType;
}

/* 进入详情页面. */
- (void)gotoDetailForRoute:(AMapRoute *)route type:(AMapRoutePlanningType)type
{
    if (type == 2) {
        BusRouteViewController *busRouteViewController = [[BusRouteViewController alloc] init];
        busRouteViewController.route = route;
        [self.navigationController pushViewController:busRouteViewController animated:YES];
    }else {
        RouteDetailViewController *routeDetailViewController = [[RouteDetailViewController alloc] init];
        routeDetailViewController.poi = self.poi;
        routeDetailViewController.route      = route;
        routeDetailViewController.routePlanningType = type;
        
        [self.navigationController pushViewController:routeDetailViewController animated:YES];
    }
}

#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        
        polylineRenderer.lineWidth   = 7;
        polylineRenderer.strokeColor = [UIColor blueColor];
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        
        polylineRenderer.lineWidth = 8;
        
        if (naviPolyline.type == MANaviAnnotationTypeWalking)
        {
            polylineRenderer.strokeColor = self.naviRoute.walkingColor;
        }
        else
        {
            polylineRenderer.strokeColor = self.naviRoute.routeColor;
        }
        
        return polylineRenderer;
    }
    
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *routePlanningCellIdentifier = @"RoutePlanningCellIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[_mapView dequeueReusableAnnotationViewWithIdentifier:routePlanningCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:routePlanningCellIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        
        if ([annotation isKindOfClass:[MANaviAnnotation class]])
        {
            switch (((MANaviAnnotation*)annotation).type)
            {
                case MANaviAnnotationTypeBus:
                    poiAnnotationView.image = [UIImage imageNamed:@"bus"];
                    break;
                    
                case MANaviAnnotationTypeDrive:
                    poiAnnotationView.image = [UIImage imageNamed:@"car"];
                    break;
                    
                case MANaviAnnotationTypeWalking:
                    poiAnnotationView.image = [UIImage imageNamed:@"man"];
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
            /* 起点. */
            if ([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerStartTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"startPoint"];
            }
            /* 终点. */
            else if([[annotation title] isEqualToString:self.poi.name])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"endPoint"];
            }
            
        }
        
        return poiAnnotationView;
    }
    
    return nil;
}

#pragma mark - AMapSearchDelegate

/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        return;
    }
    
    self.route = response.route;
    [self updateTotal];
    self.currentCourse = 0;
    
    [self updateCourseUI];
    [self updateDetailUI];
    
    [self presentCurrentCourse];
}

#pragma mark - RoutePlanning Search

/* 公交路径规划搜索. */
- (void)searchRoutePlanningBus
{
    AMapTransitRouteSearchRequest *navi = [[AMapTransitRouteSearchRequest alloc] init];
    
    navi.requireExtension = YES;
    navi.city             = @"beijing";
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    
    [_search AMapTransitRouteSearch:navi];
}

/* 步行路径规划搜索. */
- (void)searchRoutePlanningWalk
{
    AMapWalkingRouteSearchRequest *navi = [[AMapWalkingRouteSearchRequest alloc] init];
    
    /* 提供备选方案*/
    navi.multipath = 1;
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    
    [_search AMapWalkingRouteSearch:navi];
}

/* 驾车路径规划搜索. */
- (void)searchRoutePlanningDrive
{
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    
    navi.requireExtension = YES;
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    
    [_search AMapDrivingRouteSearch:navi];
}

/* 根据routePlanningType来执行响应的路径规划搜索*/
- (void)SearchNaviWithType:(AMapRoutePlanningType)searchType
{
    switch (searchType)
    {
        case AMapRoutePlanningTypeDrive:
        {
            [self searchRoutePlanningDrive];
            
            break;
        }
        case AMapRoutePlanningTypeWalk:
        {
            [self searchRoutePlanningWalk];
            
            break;
        }
        case AMapRoutePlanningTypeBus:
        {
            [self searchRoutePlanningBus];
            
            break;
        }
    }
}

#pragma mark - Handle Action

/* 切换路径规划搜索类型. */
- (void)searchTypeAction:(UISegmentedControl *)segmentedControl
{
    self.routePlanningType = [self searchTypeForSelectedIndex:segmentedControl.selectedSegmentIndex];
    
    self.route = nil;
    self.totalCourse   = 0;
    self.currentCourse = 0;
    
    [self updateDetailUI];
    [self updateCourseUI];
    
    [self clear];
    
    /* 发起路径规划搜索请求. */
    [self SearchNaviWithType:self.routePlanningType];
}

/* 切到上一个方案路线. */
- (void)previousCourseAction
{
    if ([self decreaseCurrentCourse])
    {
        [self clear];
        
        [self updateCourseUI];
        
        [self presentCurrentCourse];
    }
}

/* 切到下一个方案路线. */
- (void)nextCourseAction
{
    if ([self increaseCurrentCourse])
    {
        [self clear];
        
        [self updateCourseUI];
        
        [self presentCurrentCourse];
    }
}

/* 进入详情页面. */
- (void)detailAction
{
    if (self.route == nil)
    {
        return;
    }
    
    [self gotoDetailForRoute:self.route type:self.routePlanningType];
}

- (void)goBack {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Initialization

- (void)initNavigationBar
{
    // 导航栏颜色
    self.navigationController.navigationBar.barTintColor = RGBACOLOR(0, 178, 255, 1.0);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"zuojiantou.png"] style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"路线规划" style:UIBarButtonItemStyleDone target:self action:@selector(detailAction)];
}

- (void)initToolBar
{
    UIBarButtonItem *flexbleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    /* 导航类型. */
    UISegmentedControl *searchTypeSegCtl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"  驾 车  ",@"  步 行  ",@"  公 交  ",nil]];
    [searchTypeSegCtl addTarget:self action:@selector(searchTypeAction:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *searchTypeItem = [[UIBarButtonItem alloc] initWithCustomView:searchTypeSegCtl];
    
    /* 上一个. */
    UIBarButtonItem *previousItem = [[UIBarButtonItem alloc] initWithTitle:@"上一个" style:UIBarButtonItemStyleDone target:self action:@selector(previousCourseAction)];
    self.previousItem = previousItem;
    
    /* 下一个. */
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithTitle:@"下一个" style:UIBarButtonItemStyleDone target:self action:@selector(nextCourseAction)];
    self.nextItem = nextItem;
    
    self.toolbarItems = [NSArray arrayWithObjects:flexbleItem, searchTypeItem, flexbleItem, previousItem, flexbleItem, nextItem, flexbleItem, nil];
}

- (void)addDefaultAnnotations
{
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = self.startCoordinate;
    startAnnotation.title      = (NSString*)RoutePlanningViewControllerStartTitle;
//    startAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.startCoordinate.latitude, self.startCoordinate.longitude];
    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = self.destinationCoordinate;
    destinationAnnotation.title      = self.poi.name;
    destinationAnnotation.subtitle   = self.poi.address;
    
    [_mapView addAnnotation:startAnnotation];
    [_mapView addAnnotation:destinationAnnotation];
}

#pragma mark - Life Cycle

- (void)initCoordinate
{
    self.startCoordinate = CLLocationCoordinate2DMake(_myLocation.coordinate.latitude,_myLocation.coordinate.longitude);
    self.destinationCoordinate = CLLocationCoordinate2DMake(_poi.location.latitude, _poi.location.longitude);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initCoordinate];
    [self initMapView];
    [self initSearch];
    [self initNavigationBar];
    [self initToolBar];
    [self addDefaultAnnotations];
    [self updateCourseUI];
    [self updateDetailUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barStyle    = UIBarStyleDefault;
    self.navigationController.navigationBar.translucent = NO;
    
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
