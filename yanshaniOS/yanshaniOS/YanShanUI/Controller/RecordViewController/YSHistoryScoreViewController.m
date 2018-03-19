//
//  YSHistoryScoreViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2018/1/30.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSHistoryScoreViewController.h"
#import "YSExamManager.h"
#import "YSExaminationItemModel.h"
#import "YSExamAnalyseViewController.h"

@interface YSHistoryScoreViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView *mainView;
    NSArray *allExams;
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
    mainView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    circleLabel.backgroundColor = [UIColor whiteColor];
    circleLabel.text = @"累计做题\n0次";
    circleLabel.numberOfLines = 0;
    circleLabel.layer.cornerRadius = 75;
    circleLabel.layer.masksToBounds = YES;
    circleLabel.layer.borderWidth = 5;
    circleLabel.layer.borderColor = kRandomColor.CGColor;
    circleLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:circleLabel];
    
    UIView *line = [[UILabel alloc] init];
    line.backgroundColor = [UIColor grayColor];
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
        make.height.mas_equalTo(kLineHeight);
    }];
    if ([[YSExamManager sharedExamManager] getAllExams].count) {
        allExams = [NSArray arrayWithArray:[[YSExamManager sharedExamManager] getAllExams]];
        circleLabel.text = [NSString stringWithFormat:@"累计做题\n%ld次",allExams.count];
    }
    YSExamManager *manager = [YSExamManager sharedExamManager];
    NSArray *array = @[
      [NSString stringWithFormat:@"%ld\n\n及格次数",[manager getPassCount]],
      [NSString stringWithFormat:@"%ld\n\n累计考试",[manager getAllExams].count],
      [NSString stringWithFormat:@"%ld\n\n最高分",[manager getMaxScroce]]];
    for (int i = 0; i < array.count; i++) {
        UILabel *label = [[UILabel  alloc] init];
        label.text = array[i];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:label];
        label.backgroundColor = [UIColor whiteColor];
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
    return allExams.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    YSExaminationItemModel *model = allExams[indexPath.row];
    UILabel *scoreLabel = [[UILabel alloc] init];
    scoreLabel.text = [NSString stringWithFormat:@"答错%ld题",model.wrongItemCount];
    [cell.contentView addSubview:scoreLabel];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = [NSString stringWithFormat:@"%@  %@",model.examJudgement,model.dateString];
    timeLabel.adjustsFontSizeToFitWidth = YES;
    timeLabel.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:timeLabel];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kLightGray;
    [cell.contentView addSubview:line];
    
    [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(20);
        make.top.equalTo(cell.contentView);
        make.height.equalTo(cell.contentView);
        make.width.mas_offset(100);
    }];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scoreLabel.mas_right).offset(20);
        make.top.equalTo(cell.contentView);
        make.height.equalTo(cell.contentView);
        make.right.equalTo(cell.contentView).offset(-10);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(20);
        make.bottom.equalTo(cell.contentView);
        make.height.mas_equalTo(kLineHeight);
        make.right.equalTo(cell.contentView);
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YSExaminationItemModel *model = allExams[indexPath.row];
    YSExamAnalyseViewController *analyseVC = [[YSExamAnalyseViewController alloc] init];
    [analyseVC setExamAnalyseModel:model];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:analyseVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"历史考试成绩";
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(-0.5, 0, self.view.frame.size.width+0.5, 44);
    label.layer.borderWidth = 0.5;
    label.layer.borderColor = [UIColor grayColor].CGColor;
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

@end
