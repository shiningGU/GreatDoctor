//
//  DoctorIntroduceController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/10/12.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "DoctorIntroduceController.h"
#import "AnswerViewController.h"
#import "DoctorIntroduceCell.h"
#import "QuestionButtonCell.h"

@interface DoctorIntroduceController ()
@property (nonatomic,retain)NSString *introduce;

@end

@implementation DoctorIntroduceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    _introduce = @"从事小儿耳鼻喉及儿童睡眠呼吸障碍性疾病的研究和临床工作近二十年。擅长小儿呼吸道异物、睡眠呼吸障碍性疾病以及儿童鼻窦炎、分泌性中耳炎的手术治疗。";
    [self.tableView registerNib:[UINib nibWithNibName:@"DoctorIntroduceCell" bundle:nil] forCellReuseIdentifier:@"doctorIntroduce"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QuestionButtonCell" bundle:nil] forCellReuseIdentifier:@"questionBtn"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    if ([self.type isEqualToString:@"online"]) {
        return 4;
    }
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *str = @"doctorIntroduce";
        DoctorIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
        if (!cell) {
            cell = [[DoctorIntroduceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        layerCornerRadius(cell.backView, 15);
        cell.backView.layer.borderWidth = 1;
        cell.backView.layer.borderColor = RGBACOLOR(255, 165, 0, 1.0).CGColor;
        return cell;
    }else if(indexPath.row == 3&&[self.type isEqualToString:@"online"]) {
        static NSString *str = @"questionBtn";
        QuestionButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[QuestionButtonCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
        }
        AnswerViewController *answerVC = [[AnswerViewController alloc] init];
        cell.lastViewController = _lastViewController;
        cell.nextViewController = answerVC;
        layerCornerRadius(cell.questionBtn, 15);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        static NSString *str = @"doctorintroduce";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"专家简介";
            cell.textLabel.textColor = RGBACOLOR(255, 165, 0, 1.0);
        }else {
            cell.textLabel.text = _introduce;
            cell.textLabel.numberOfLines = 0;
            [cell.textLabel sizeToFit];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height;// 计算简介文字高度
    if (indexPath.row == 0) {
        return 110;
    }else if (indexPath.row == 2) {
        NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
        CGRect rect = [_introduce boundingRectWithSize:CGSizeMake(tableView.frame.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        height = rect.size.height+15;
        return height;
    }else if (indexPath.row == 1) {
        return 30;
    }
    return 60;
}


@end
