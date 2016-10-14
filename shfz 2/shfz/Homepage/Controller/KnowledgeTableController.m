//
//  KnowledgeTableController.m
//  shfz
//
//  Created by shanghaifuzhong on 15/10/7.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "KnowledgeTableController.h"

@interface KnowledgeTableController ()
{
    NSInteger endSection;
    NSInteger didSection;
    BOOL ifOpen;
}
@property (nonatomic,retain)NSMutableArray *array;
@property (nonatomic,retain)NSString *introduce;
@end

@implementation KnowledgeTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    _introduce = @"“耳鼻咽喉科”是诊断治疗耳、鼻、咽喉、及其相关头颈区域的外科学科。随着科技的进步与发展，医学各科相互渗透和促进，拓展了耳鼻咽喉科的范畴，耳显微外科，耳神经外科，侧颅底外科，听力学及平衡科学，鼻内镜外科，鼻神经外科（鼻颅底外科），头颈外科，喉显微外科，嗓音与言语疾病科，小儿耳鼻咽喉科等的出现，大大丰富了耳鼻咽喉科的内容。";
    _array = [[NSMutableArray alloc]initWithObjects:@"综述", @"病因", @"症状", @"饮食保健", @"护理", @"治疗", @"检查", @"鉴别", @"并发症", nil];
    self.tableView.sectionFooterHeight = 10.0;
    didSection = _array.count+1;
    /*在当前线程中执行指定的方法，使用默认模式，并指定延迟。
    参数：
    aSelector：指定的方法。含义同上，不在赘述。
    anArgument：同上
    delay：指定延迟时间（秒）。
     */
    [self performSelector:@selector(firstOneClicked) withObject:self afterDelay:0.2f];
}

- (void)firstOneClicked{
    didSection = 0;
    endSection = 0;
    [self didSelectCellRowFirstDo:YES nextDo:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == didSection) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *str = @"knowledge";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _introduce;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = RGBACOLOR(105, 105, 105, 1.0);
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel sizeToFit];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == didSection) {
        NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
        CGRect rect = [_introduce boundingRectWithSize:CGSizeMake(tableView.frame.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        return rect.size.height+50;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
    titleView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 20)];
    for (NSInteger i = 0; i < _array.count; i++) {
        if (section == i) {
            titleLabel.text = [_array objectAtIndex:i];
        }
    }
    [titleView addSubview:titleLabel];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = titleView.bounds;
    btn.backgroundColor = [UIColor clearColor];
    [btn setTag:section];
    [btn addTarget:self action:@selector(addCell:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:btn];
    return titleView;
}

- (void)addCell:(UIButton *)bt{
    endSection = bt.tag;
    if (didSection==_array.count+1) {
        ifOpen = NO;
        didSection = endSection;
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
    else{
        if (didSection==endSection) {
            [self didSelectCellRowFirstDo:NO nextDo:NO];
        }
        else{
            [self didSelectCellRowFirstDo:NO nextDo:YES];
        }
    }
}

- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert{
    [self.tableView beginUpdates];
    ifOpen = firstDoInsert;
    NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:didSection];
    [rowToInsert addObject:indexPath];
    if (!ifOpen) {
        didSection = _array.count+1;
        [self.tableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationFade];
    }else{
        [self.tableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.tableView endUpdates];
    if (nextDoInsert) {
        didSection = endSection;
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
}

@end
