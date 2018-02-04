//
//  YSHistoryScoreViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2018/1/30.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSHistoryScoreViewController.h"

@interface YSHistoryScoreViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView *mainView;
}

@end

@implementation YSHistoryScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configView {
    
    mainView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    mainView.delegate = self;
    mainView.dataSource = self;
    mainView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mainView];
    if ([self.view respondsToSelector:@selector(safeAreaLayoutGuide)]) {
        [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view.mas_safeAreaLayoutGuide);
        }];
    }
    if ([UIViewController instancesRespondToSelector:@selector(topLayoutGuide)]) {
        [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    CGRect frame = self.view.frame;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 290)];
    mainView.tableHeaderView = headerView;
    
    UILabel *circleLabel = [[UILabel alloc] init];
    circleLabel.backgroundColor = [UIColor orangeColor];
    circleLabel.text = @"累计做题\n20次";
    circleLabel.numberOfLines = 0;
    circleLabel.layer.cornerRadius = 75;
    circleLabel.layer.masksToBounds = YES;
    circleLabel.layer.borderWidth = 5;
    circleLabel.layer.borderColor = kRandomColor.CGColor;
    circleLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:circleLabel];
    
    UIView *line = [[UILabel alloc] init];
    line.backgroundColor = [UIColor blueColor];
    [headerView addSubview:line];
    
    [circleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).offset(25);
        make.centerX.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(150, 150));
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(circleLabel.mas_bottom).offset(25);
        make.left.equalTo(headerView);
        make.right.equalTo(headerView);
        make.height.mas_equalTo(0.5);
    }];
    
    NSArray *array = @[@"28\n\n及格次数",@"28\n\n累计考试",@"28\n\n最高分"];
    for (int i = 0; i < array.count; i++) {
        UILabel *label = [[UILabel  alloc] init];
        label.text = array[i];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:label];
        label.backgroundColor = kRandomColor;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom);
            make.left.equalTo(headerView).offset(frame.size.width/3*i);
            make.bottom.equalTo(headerView);
            make.width.mas_equalTo(frame.size.width/3);
        }];
    }
}

- (void)configViewControllerParameter {
    
}

- (void)addNavigationItems {
    [self addPopViewControllerButtonWithTarget:self action:@selector(backViewController:)];
}

#pragma mark - UITableView delegate - datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    UILabel *scoreLabel = [[UILabel alloc] init];
    scoreLabel.text = @"99分";
    [cell.contentView addSubview:scoreLabel];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = @"90:00  2017.08.12 12:11";
    timeLabel.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:timeLabel];
    
    [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(20);
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"历史考试成绩";
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(-0.5, 0, self.view.frame.size.width+0.5, 44);
    label.layer.borderWidth = 0.5;
    label.layer.borderColor = kRandomColor.CGColor;
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

@end
