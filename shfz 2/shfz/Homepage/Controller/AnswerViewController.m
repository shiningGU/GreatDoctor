//
//  AnswerViewController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/8/5.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "AnswerViewController.h"

@interface AnswerViewController ()<UIAlertViewDelegate,UIImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>{
    NSArray * imageArray;
    NSMutableArray * dataArray;
    
}
@property(nonatomic,copy) NSString *lastChosenMediaType;
@property(nonatomic, retain) UIImage *myImage;// 选中的图片

@end

@implementation AnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    [self initPhotoCollectionView];
    
    //增加监听，当键退出时收出消息
    [self keyboardHidden];
}

#pragma mark - View
- (void)initView
{
    self.title = @"我要提问";
    if (iPhone4 || iPhone5) {
        self.uploadLable.text = @"上传电子病历";
    }
    
    self.questionText.placeholder = @"详细描述您的问题，包括身体状况、疾病和症状等";
    layerCornerRadius(_questionText, 15);
    self.questionText.layer.borderWidth = 0.1;
    layerCornerRadius(_uploadBtn, 15);
    layerCornerRadius(_manBtn, _manBtn.frame.size.width/2);
    layerCornerRadius(_womenBtn, _womenBtn.frame.size.width/2);
    layerCornerRadius(_yearBtn, _yearBtn.frame.size.width/2);
    layerCornerRadius(_monthBtn, _monthBtn.frame.size.width/2);
    layerCornerRadius(_commitBtn, 20);
    
    self.ageText.delegate = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(commitAction:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 更新约束
- (void)updateViewConstraints
{
    [super updateViewConstraints];
    if (iPhone4) {
        self.viewHeight.constant = CGRectGetHeight([UIScreen mainScreen].bounds)*1.3;
    }else if(iPhone5) {
        self.viewHeight.constant = CGRectGetHeight([UIScreen mainScreen].bounds)*1.1;
    }else
    self.viewHeight.constant = CGRectGetHeight([UIScreen mainScreen].bounds)*1;
}

#pragma mark - PhotoCollectionView
- (void)initPhotoCollectionView
{
    self.photoCollectionView.dataSource = self;
    self.photoCollectionView.delegate = self;

    [self.photoCollectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"photoCollectView"];
    
    dataArray = [[NSMutableArray alloc]initWithObjects:
                 [UIImage imageNamed:@"iconfont-tianjia.png"],
                 nil];
}

#pragma mark - CollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *myCell = [collectionView
                                      dequeueReusableCellWithReuseIdentifier:@"photoCollectView"
                                      forIndexPath:indexPath];
    
    UIImage * imageName = [dataArray objectAtIndex:[indexPath row]];
    [myCell.photoImage setImage:imageName];
    myCell.photoImage.tag = [indexPath row];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProfileImage:)];
    singleTap.numberOfTapsRequired = 1;
    myCell.photoImage .userInteractionEnabled = YES;
    [myCell.photoImage  addGestureRecognizer:singleTap];
    myCell.closeBtn.tag = [indexPath row];
    if ([indexPath row] != (dataArray.count - 1)){
        [myCell.closeBtn setHidden:NO];
    }
    else {
        [myCell.closeBtn setHidden:YES];
    }
    
    [myCell.closeBtn addTarget:self action:@selector(deletePhoto:)
                 forControlEvents:UIControlEventTouchUpInside];
    return myCell;

}

- (void) tapProfileImage:(UITapGestureRecognizer *)gestureRecognizer{
    UIImageView *tableGridImage = (UIImageView*)gestureRecognizer.view;
    NSInteger index = tableGridImage.tag;
    if (index == (dataArray.count -1))
    {
        if ((iPhone4 && index == 5)||(iPhone5 && index == 5)) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"对不起，图片已达上限" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }else if ((iPhone6 && index == 7)||(iPhone6Plus && index == 7)){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"对不起，图片已达上限" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }else{
        //here we just add a random image from local
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请选择图片来源" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照", @"从相册中选择", nil];
            alertView.tag = 100;
        [alertView show];
        }
    }
    else {
        //show a photo browser if it is normal photo
        DKModalImageBrowser *modalImageBrowser = [[DKModalImageBrowser alloc] init];
        // note: use modalImageBrowser.imageBrowser to set data source, customize
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:dataArray];
        [tempArr removeLastObject];
        NSMutableArray *browserArray = [NSMutableArray arrayWithArray:tempArr];
        modalImageBrowser.imageBrowser.DKImageDataSource = browserArray;
        [self presentViewController:modalImageBrowser animated:YES completion:nil];
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100||alertView.tag == 200) {
        if (buttonIndex == 1) {
            [self shootPictureOrVideo];
        }else if(buttonIndex == 2){
            [self selectExistingPictureOrVideo];
        }
    }
}
//拍照
- (void)shootPictureOrVideo{
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}
//相册
- (void)selectExistingPictureOrVideo{
    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark - 拍照模块
// 成功获得照片还是视频后的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.lastChosenMediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([_lastChosenMediaType isEqual:(NSString *)kUTTypeImage]) {
        UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
        self.myImage = chosenImage;
        [dataArray insertObject:chosenImage atIndex:[dataArray count] - 1];
        [self updateView];
        [self.photoCollectionView reloadData];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
// collectionview换行时视图的变化
- (void)updateView{
    if (iPhone4 || iPhone5) {
        if (dataArray.count > 3) {
            self.photoCollectionHeight.constant = 160;
            if (dataArray.count == 4) {
                self.downViewTop.constant += 80;
                self.viewHeight.constant += 80;
            }
            if (dataArray.count > 5) {
                self.uploadBtn.hidden = YES;
            }
        }
    }else {
        if (dataArray.count > 4) {
            self.photoCollectionHeight.constant = 160;
            if (dataArray.count == 5) {
                self.downViewTop.constant += 80;
                self.viewHeight.constant += 80;
            }
            if (dataArray.count > 7) {
                self.uploadBtn.hidden = YES;
            }
        }
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    NSArray *mediatypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    //返回的是字符串数组，kUTTypeImage表示静态图片，kUTTypeMovie表示视频。
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] && mediatypes.count > 0) {
        NSArray *mediatypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        //初始化图片选择控制器
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.mediaTypes = mediatypes;
        picker.delegate = self;
        //判断,图片是否允许修改
        picker.allowsEditing= YES;
        
        picker.sourceType=sourceType;
        
        NSString *requiredmediatype=(NSString *)kUTTypeImage;
        NSArray *arrmediatypes=[NSArray arrayWithObject:requiredmediatype];
        [picker setMediaTypes:arrmediatypes];
        [self presentViewController:picker animated:YES completion:^{}];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误信息!" message:@"当前设备不支持拍摄功能" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)deletePhoto: (UIButton *)sender{
    [dataArray removeObjectAtIndex:sender.tag];
    if (iPhone4 || iPhone5) {
        if (dataArray.count <= 5) {
            self.uploadBtn.hidden = NO;
            if (dataArray.count <= 3) {
                self.photoCollectionHeight.constant = 80;
                if (dataArray.count == 3) {
                    self.downViewTop.constant -= 80;
                    self.viewHeight.constant -= 80;
                }
            }
        }
    }else {
        if (dataArray.count <= 7) {
            self.uploadBtn.hidden = NO;
            if (dataArray.count <= 4) {
                self.photoCollectionHeight.constant = 80;
                if (dataArray.count == 4) {
                    self.downViewTop.constant -= 80;
                    self.viewHeight.constant -= 80;
                }
            }
        }
    }
    [self.photoCollectionView reloadData];
}

#pragma mark - 个人信息
- (IBAction)upload:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请选择图片来源" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照", @"从相册中选择", nil];
    alertView.tag = 200;
    [alertView show];
}

- (IBAction)manAction:(id)sender {
    self.womenBtn.titleLabel.textColor = RGBACOLOR(113, 113, 113, 1.0);
    self.womenBtn.backgroundColor = RGBACOLOR(214, 214, 214, 1.0);
    self.manBtn.backgroundColor = RGBACOLOR(32, 166, 254, 1.0);
}

- (IBAction)womenAction:(id)sender {
    self.manBtn.titleLabel.textColor = RGBACOLOR(113, 113, 113, 1.0);
    self.manBtn.backgroundColor = RGBACOLOR(214, 214, 214, 1.0);
    self.womenBtn.backgroundColor = RGBACOLOR(32, 166, 254, 1.0);
}

- (IBAction)yearAction:(id)sender {
    self.monthBtn.titleLabel.textColor = RGBACOLOR(113, 113, 113, 1.0);
    self.monthBtn.backgroundColor = RGBACOLOR(214, 214, 214, 1.0);
    self.yearBtn.backgroundColor = RGBACOLOR(32, 166, 254, 1.0);
}

- (IBAction)monthAction:(id)sender {
    self.yearBtn.titleLabel.textColor = RGBACOLOR(113, 113, 113, 1.0);
    self.yearBtn.backgroundColor = RGBACOLOR(214, 214, 214, 1.0);
    self.monthBtn.backgroundColor = RGBACOLOR(32, 166, 254, 1.0);
}

- (IBAction)commitAction:(id)sender {
}

#pragma mark - 键盘回收
- (IBAction)recyclingKeyboard:(id)sender {
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    _mainScrollView.contentOffset = CGPointMake(0, -64);
    [UIView commitAnimations];
    [_questionText resignFirstResponder];
    [_ageText resignFirstResponder];
}

//监听键盘退出
- (void)keyboardHidden {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    _mainScrollView.contentOffset = CGPointMake(0, -64);
    [UIView commitAnimations];
}

#pragma mark - 解决虚拟键盘挡住UITextField的方法

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y+ frame.size.height + 32 + self.downViewTop.constant - (self.view.frame.size.height - 260.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, offset,width,height);
        _mainScrollView.contentOffset = rect.origin;
    }
    [UIView commitAnimations];
}
@end
