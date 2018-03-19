//
//  YSExamAnalyseViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2018/2/25.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSExamAnalyseViewController.h"
#import "YSExamManager.h"
#import "YSExaminationItemModel.h"
#import "YSWrongItemsViewController.h"

@interface YSExamAnalyseViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *allExams;
    YSExaminationItemModel *examModel;
    UITableView *mainView;
    UILabel *testResultLabel;
}
@end

@implementation YSExamAnalyseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    if ([[YSExamManager sharedExamManager] getAllExams].count) {
        allExams = [NSArray arrayWithArray:[[YSExamManager sharedExamManager] getAllExams]];
        examModel = allExams[0];
        testResultLabel.text = [NSString stringWithFormat:@"%ld分 答错%ld题 %@",examModel.examScore,examModel.wrongItemCount,examModel.examJudgement];
        [mainView reloadData];
    }
}

#pragma mark - config view controller

- (void)configViewControllerParameter {
    self.title = @"成绩统计";
}

- (void)configView {
    
    mainView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
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
    
    testResultLabel = [[UILabel alloc] init];
    testResultLabel.text = @"暂无考试成绩统计";
    testResultLabel.backgroundColor = [UIColor redColor];
    testResultLabel.textColor = [UIColor whiteColor];
    testResultLabel.layer.cornerRadius = 33;
    testResultLabel.layer.masksToBounds = YES;
    testResultLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:testResultLabel];
    if ([[YSExamManager sharedExamManager] getAllExams].count) {
        allExams = [NSArray arrayWithArray:[[YSExamManager sharedExamManager] getAllExams]];
        examModel = allExams[0];
        testResultLabel.text = [NSString stringWithFormat:@"%ld分 答错%ld题 %@",examModel.examScore,examModel.wrongItemCount,examModel.examJudgement];
    }
    [testResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconView.mas_bottom).offset(10);
        make.centerX.equalTo(iconView);
        make.size.mas_equalTo(CGSizeMake(290, 66));
    }];
}

- (void)configContainer {
    
}

- (void)addNavigationItems {
    [self addPopViewControllerButtonWithTarget:self action:@selector(backViewController:)];
}

- (void)setExamAnalyseModel:(YSExaminationItemModel *)model {
    examModel = model;
}

#pragma mark - UITableView delegate - datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return examModel ? 3 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *line = [[UILabel alloc] init];
    line.backgroundColor = kLightGray;
    [cell.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(20);
        make.right.equalTo(cell.contentView);
        make.bottom.equalTo(cell.contentView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    NSArray *arr1 = @[@"单选题",@"多选题",@"判断题"];
    NSArray *arr2 = @[[NSString stringWithFormat:@"错题%ld道",[examModel getSCItem].count],
                      [NSString stringWithFormat:@"错题%ld道",[examModel getMCItem].count],
                      [NSString stringWithFormat:@"错题%ld道",[examModel getTFItem].count]];
    cell.textLabel.text = arr1[indexPath.row];
    cell.detailTextLabel.text = arr2[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YSWrongItemsViewController *itemsVC = [[YSWrongItemsViewController alloc] init];
    if (indexPath.row == 0 && [examModel getSCItem].count) {
        [itemsVC setWrongItemsData:[examModel getSCItem]];
    }
    if (indexPath.row == 1 && [examModel getMCItem].count) {
        [itemsVC setWrongItemsData:[examModel getMCItem]];
    }
    if (indexPath.row == 2 && [examModel getTFItem].count) {
        [itemsVC setWrongItemsData:[examModel getTFItem]];
    }
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:itemsVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

@end