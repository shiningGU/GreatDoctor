//
//  DarkView.m
//  shfz
//
//  Created by shanghaifuzhong on 15/9/29.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "DarkView.h"
#import "OrderViewController.h"

@implementation DarkView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.2);
        self.funcArray = @[@"订单管理", @"我的设置", @"关于我们", @"注销"];
        self.picArray = @[@"dingdan.png", @"shezhi.png", @"yiliao.png", @"zhuxiao.png"];
        
        self.funcTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.size.width - 40, 64, 0, 0) style:UITableViewStylePlain];
        self.funcTableView.dataSource = self;
        self.funcTableView.delegate = self;
        [self addSubview:_funcTableView];
        // tableview出现动画
        [UIView animateWithDuration:0.3f animations:^{
            // 设置动画的速度曲线
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            self.funcTableView.frame = CGRectMake(self.frame.size.width - 120, 64, 130, 120);
            
        }];
        
        
    }
    return self;
}

#pragma mark - tableviewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"function";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    
    cell.imageView.image = [UIImage imageNamed:[self.picArray objectAtIndex:indexPath.row]];
    
    cell.textLabel.text = [self.funcArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = [UIColor grayColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getDark" object:@"light" userInfo:nil];
    switch (indexPath.row) {
        case 0:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"functionView" object:@"dingdan" userInfo:nil];
            break;
            
        case 1:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"functionView" object:@"shezhi" userInfo:nil];
            break;
            
        case 2:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"functionView" object:@"aboutUs" userInfo:nil];
            break;
            
        case 3:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"functionView" object:@"quit" userInfo:nil];
            break;
            
        default:
            break;
    }
}

#pragma mark - disappearDarkView notificationCenter
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // tableview隐藏动画
    [UIView animateWithDuration:0.4f animations:^{
        
        // 设置动画的速度曲线
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.funcTableView.alpha = 0;
        self.funcTableView.frame = CGRectMake(self.frame.size.width - 40, 64, 0, 0);
        
    } completion:^(BOOL finished) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getDark" object:@"light" userInfo:nil];
    }];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
