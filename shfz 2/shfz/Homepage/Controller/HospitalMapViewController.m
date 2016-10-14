//
//  HospitalMapViewController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/10/14.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "HospitalMapViewController.h"
#import "APIKey.h"
#import "POIAnnotation.h"
#import "RoutePlanningViewController.h"
#import "JSONKit.h"

#define ReturnString(object) object == nil?@"":object

@interface HospitalMapViewController ()<MAMapViewDelegate, AMapSearchDelegate>
{
    MAMapView *_mapView;
    AMapSearchAPI *_search;
    
    NSArray *_annotationArr;// 标注点数组
    
    MAUserLocation *_myLocation;
}

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation HospitalMapViewController

- (void)initMapView {
    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager requestWhenInUseAuthorization];
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

#pragma mark - MAMapViewDelegate

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        [self searchPoiByCenterCoordinateWith:userLocation];
        _myLocation = userLocation;
//        //取出当前位置的坐标
//        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    id<MAAnnotation> annotation = view.annotation;
    
    if ([annotation isKindOfClass:[POIAnnotation class]])
    {
        POIAnnotation *poiAnnotation = (POIAnnotation*)annotation;
        
        RoutePlanningViewController *routePlan = [[RoutePlanningViewController alloc] init];
        UINavigationController *naviRoutePlan = [[UINavigationController alloc] initWithRootViewController:routePlan];
        routePlan.poi = poiAnnotation.poi;
        routePlan.myLocation = _myLocation;
        
        /* 进入POI详情页面. */
        [self presentViewController:naviRoutePlan animated:YES completion:^{
            
        }];
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[POIAnnotation class]])
    {
        static NSString *poiIdentifier = @"poiIdentifier";
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[_mapView dequeueReusableAnnotationViewWithIdentifier:poiIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:poiIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return poiAnnotationView;
    }
    
    return nil;
}

#pragma mark - AMapSearchDelegate
/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        [poiAnnotations addObject:[[POIAnnotation alloc] initWithPOI:obj]];
    }];
    
    /* 将结果以annotation的形式加载到地图上. */
    [_mapView addAnnotations:poiAnnotations];
    
    // 标注点数组
    _annotationArr = [NSMutableArray arrayWithArray:poiAnnotations];
    
    MAUserLocation *myLocation = _mapView.userLocation;
    NSArray *arr = @[myLocation];

    NSDictionary *dic = @{ @"end": poiAnnotations, @"start": arr};
    
    // 利用通知传递标注信息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getAnnotation" object:dic];
    [_mapView selectAnnotation:[poiAnnotations objectAtIndex:0] animated:YES];
    
    /* 如果只有一个结果，设置其为中心点. */
    if (poiAnnotations.count == 1)
    {
        [_mapView setCenterCoordinate:[poiAnnotations[0] coordinate]];
    }
    /* 如果有多个结果, 设置地图使所有的annotation都可见. */
    else
    {
        [_mapView showAnnotations:poiAnnotations animated:NO];
    }
}

/* 根据中心点坐标来搜周边的POI. */
- (void)searchPoiByCenterCoordinateWith:(MAUserLocation *)myLocation
{
//    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];

    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location            = [AMapGeoPoint locationWithLatitude:myLocation.coordinate.latitude longitude:myLocation.coordinate.longitude];
//    request.location            = [AMapGeoPoint locationWithLatitude:39.942425 longitude:116.481476];
    request.keywords            = @"医院";
    request.types = @"医疗保健服务";
    /* 按照距离排序. */
    request.sortrule            = 1;
    request.requireExtension    = YES;
    
    [_search AMapPOIAroundSearch:request];
    
//    request.keywords            = @"医院";
//    request.city                = @"010";
//    request.requireExtension    = YES;
//    [_search AMapPOIKeywordsSearch:request];
}

- (void)getAnnotationWindowNotification:(NSNotification *)noti {
    if (noti) {
        NSString *index = noti.object;
        [_mapView selectAnnotation:[_annotationArr objectAtIndex:index.integerValue] animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initMapView];
    [self initSearch];
}

- (void)viewDidAppear:(BOOL)animated {
    // 标注弹出窗口通知
    NSNotificationCenter *getAnnotationWindowCenter = [NSNotificationCenter defaultCenter];
    [getAnnotationWindowCenter addObserver:self selector:@selector(getAnnotationWindowNotification:) name:@"getAnnotationWindow" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
