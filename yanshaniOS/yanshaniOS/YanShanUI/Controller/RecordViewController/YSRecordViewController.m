//
//  YSRecordViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2017/10/4.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSRecordViewController.h"
#import "YSHistoryScoreViewController.h"

@interface YSRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
}
@end

@implementation YSRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - config view controller

- (void)configViewControllerParameter {
    self.title = @"成绩统计";
}

- (void)configView {
    
    UITableView *mainView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
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
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 320)];
    headerView.backgroundColor = [UIColor whiteColor];
    mainView.tableHeaderView = headerView;
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recordicon"]];
    [headerView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView);
        make.centerX.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(170*1.7, 140*1.7));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"90分 答错9题 成绩合格";
    label.backgroundColor = [UIColor redColor];
    label.textColor = [UIColor whiteColor];
    label.layer.cornerRadius = 33;
    label.layer.masksToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconView.mas_bottom).offset(10);
        make.centerX.equalTo(iconView);
        make.size.mas_equalTo(CGSizeMake(290, 66));
    }];
}

- (void)configContainer {
    
}

- (void)addNavigationItems {
    UIButton *sender = [self customNavgationBarItem:self.navigationItem.rightBarButtonItem withTitle:@"历史成绩"];
    [sender addTarget:self action:@selector(historyScore:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)historyScore:(UIButton *)sender {
    
    YSHistoryScoreViewController *scoreVC = [[YSHistoryScoreViewController alloc] init];
    scoreVC.title = @"历史成绩";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scoreVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - UITableView delegate - datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    NSArray *arr1 = @[@"单选题",@"多选题",@"判断题",@"视频题"];
    NSArray *arr2 = @[@"错题率10%",@"错题率20%",@"错题率30%",@"错题率10%"];
    cell.textLabel.text = arr1[indexPath.row];
    cell.detailTextLabel.text = arr2[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
