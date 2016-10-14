//
//  HomeViewController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/8/4.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCollectionViewCell.h"
#import "AnswerViewController.h"
#import "DiseaseAreaViewController.h"
#import "OrderViewController.h"
#import "SetViewController.h"
#import "AboutOurViewController.h"
#import "MedicalRecordController.h"
#import "HealthyTableController.h"
#import "OnlineDoctorController.h"
#import "NearbyHospitalController.h"

@interface HomeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, retain)UICollectionView *homeCollectionView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBACOLOR(245, 245, 245, 1.0);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"scan.png"] style:UIBarButtonItemStyleDone target:self action:@selector(scanZBar:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more.png"] style:UIBarButtonItemStyleDone target:self action:@selector(moreAction:)];
    [self initRoubotImageView];
    [self initCollectionView];
    
    // 侧边功能视图跳转添加灰色背景view通知
    NSNotificationCenter *functionCenter = [NSNotificationCenter defaultCenter];
    [functionCenter addObserver:self selector:@selector(functionNotification:) name:@"functionView" object:nil];
}
#pragma mark - uinavigation
- (void)scanZBar:(UIBarButtonItem *)barBtn
{
    
}

- (void)moreAction:(UIBarButtonItem *)barBtn
{
    // 发出通知 添加灰色背景view
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getDark" object:@"dark" userInfo:nil];
}

#pragma mark - functionView跳转通知
- (void)functionNotification:(NSNotification *)noti
{
    if ([noti.object isEqualToString:@"dingdan"]) {
        OrderViewController *orderVC = [[OrderViewController alloc] init];
        [self.navigationController pushViewController:orderVC animated:YES];
    }else if ([noti.object isEqualToString:@"shezhi"]){
        SetViewController *setVC = [[SetViewController alloc] init];
        [self.navigationController pushViewController:setVC animated:YES];
    }else if ([noti.object isEqualToString:@"aboutUs"]){
        AboutOurViewController *aboutOurVC = [[AboutOurViewController alloc] init];
        [self.navigationController pushViewController:aboutOurVC animated:YES];
    }else{
        //注销登录
    }
}

#pragma mark - View
- (void)initRoubotImageView
{
    UIImageView *robotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height*1/3)];
    robotImageView.image = [UIImage imageNamed:@"robot.png"];
    robotImageView.userInteractionEnabled = YES;
    [self.view addSubview:robotImageView];
    
    UITapGestureRecognizer *tapRobot = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(askRobotAction:)];
    [robotImageView addGestureRecognizer:tapRobot];
}

- (void)askRobotAction:(UITapGestureRecognizer *)tap
{
    AnswerViewController *askViewController = [[AnswerViewController alloc] init];
    [self.navigationController pushViewController:askViewController animated:YES];
}

- (void)initCollectionView
{
    // 电影列表的布局
    UICollectionViewFlowLayout *scanLayout = [[UICollectionViewFlowLayout alloc] init];
    // 每个小块的大小
    scanLayout.itemSize = CGSizeMake((self.view.frame.size.width-100)/3, (self.view.frame.size.height*2/3-200)/2);
    // 最小行间距
    scanLayout.minimumLineSpacing = 20;
    // 最小块间距
    scanLayout.minimumInteritemSpacing = 5;
    // 距离边缘的大小
    scanLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    
    // collection
    self.homeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height*1/3+74, self.view.bounds.size.width-20, self.view.frame.size.height*2/3-132) collectionViewLayout:scanLayout];
    _homeCollectionView.backgroundColor = [UIColor whiteColor];
    _homeCollectionView.delegate = self;
    _homeCollectionView.dataSource = self;
    [self.view addSubview:_homeCollectionView];
    
//    // 注册
//    [_homeCollectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"robotCollectView"];
    
    // 注册
    [_homeCollectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"robotCollectView"];
}

#pragma mark - UICollectionViewDelegate
// 设块数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

// 创建cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"robotCollectView" forIndexPath:indexPath];
    
    switch (indexPath.item) {
        case 0:
            cell.homeCollectionImage.image = [UIImage imageNamed:@"iconfont-jibingzicha.png"];
            cell.homeLabel.text = @"疾病专区";
            break;
        case 1:
            cell.homeCollectionImage.image = [UIImage imageNamed:@"iconfont-kefu.png"];
            cell.homeLabel.text = @"名医在线";
            break;
        case 2:
            cell.homeCollectionImage.image = [UIImage imageNamed:@"iconfont-pengyou.png"];
            cell.homeLabel.text = @"健康精选";
            break;
        case 3:
            cell.homeCollectionImage.image = [UIImage imageNamed:@"iconfont-yiyuan.png"];
            cell.homeLabel.text = @"附近医院";
            break;
        case 4:
            cell.homeCollectionImage.image = [UIImage imageNamed:@"iconfont-chicangdan.png"];
            cell.homeLabel.text = @"电子病历";
            break;
        case 5:
            cell.homeCollectionImage.image = [UIImage imageNamed:@"iconfont-jingkongshangcheng.png"];
            cell.homeLabel.text = @"药品商城";
            break;
            
        default:
            break;
    }
    return cell;
}

// collectionView跳转详情页面
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DiseaseAreaViewController *diseaseAreaVC = [[DiseaseAreaViewController alloc] init];
    
    OnlineDoctorController *onlineDoctorVC = [[OnlineDoctorController alloc] initWithStyle:UITableViewStyleGrouped];
    
    HealthyTableController *healthyNewsVC = [[HealthyTableController alloc] initWithStyle:UITableViewStyleGrouped];
    
    NearbyHospitalController *nearbyHospital = [[NearbyHospitalController alloc] init];
    
    MedicalRecordController *medicalRecordVC = [[MedicalRecordController alloc] initWithStyle:UITableViewStyleGrouped];
    
    switch (indexPath.item) {
        case 0:
            [self.navigationController pushViewController:diseaseAreaVC animated:YES];
            break;
            
        case 1:
            [self.navigationController pushViewController:onlineDoctorVC animated:YES];
            break;
            
        case 2:
            [self.navigationController pushViewController:healthyNewsVC animated:YES];
            break;
            
        case 3:
            [self.navigationController pushViewController:nearbyHospital animated:YES];
            break;
            
        case 4:
            [self.navigationController pushViewController:medicalRecordVC animated:YES];
            break;
            
        default:
            break;
    }
    
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
