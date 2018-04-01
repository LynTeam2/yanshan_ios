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
#import "YSRecordStatisticView.h"

@interface YSExamAnalyseViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *allExams;
    YSExaminationItemModel *examModel;
    UITableView *mainView;
    UILabel *scoreLabel;
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
        testResultLabel.text = [NSString stringWithFormat:@"答错%ld题 %@",examModel.wrongItemCount,examModel.examJudgement];
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
    
    CGFloat height = self.view.frame.size.height*0.55;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
    headerView.backgroundColor = kBlueColor;
    mainView.tableHeaderView = headerView;
    
    
    scoreLabel = [[UILabel alloc] init];
    scoreLabel.text = @"90分";
    scoreLabel.textColor = [UIColor whiteColor];
    scoreLabel.font = [UIFont systemFontOfSize:50];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:scoreLabel];
    
    testResultLabel = [[UILabel alloc] init];
    testResultLabel.text = @"暂无考试成绩统计";
    testResultLabel.textColor = [UIColor whiteColor];
    testResultLabel.layer.cornerRadius = 33;
    testResultLabel.layer.masksToBounds = YES;
    testResultLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:testResultLabel];
    if ([[YSExamManager sharedExamManager] getAllExams].count) {
        allExams = [NSArray arrayWithArray:[[YSExamManager sharedExamManager] getAllExams]];
        examModel = allExams[0];
        testResultLabel.text = [NSString stringWithFormat:@"答错%ld题 %@",examModel.wrongItemCount,examModel.examJudgement];
    }
    
    YSRecordStatisticView *statiscView1 = [[YSRecordStatisticView alloc] init];
    [headerView addSubview:statiscView1];
    
    YSRecordStatisticView *statiscView2 = [[YSRecordStatisticView alloc] init];
    [headerView addSubview:statiscView2];
    
    YSRecordStatisticView *statiscView3 = [[YSRecordStatisticView alloc] init];
    [headerView addSubview:statiscView3];
    
    [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.top.equalTo(headerView).offset(45);
        make.size.mas_equalTo(CGSizeMake(500, 50));
    }];
    [testResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.top.equalTo(scoreLabel.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(500, 30));
    }];
    [statiscView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.top.equalTo(testResultLabel.mas_bottom).offset(50);
        make.height.mas_equalTo(30);
        make.width.equalTo(headerView);
    }];
    [statiscView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.top.equalTo(statiscView1.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
        make.width.equalTo(headerView);
    }];
//    [statiscView3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(headerView);
//        make.top.equalTo(statiscView2.mas_bottom).offset(10);
//        make.height.mas_equalTo(30);
//        make.width.equalTo(headerView);
//    }];
    
    YSRecordStatisticButton *btn = [[YSRecordStatisticButton alloc] initWithButtonType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.top.equalTo(statiscView2.mas_bottom).offset(10);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(headerView.frame.size.width/2);
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
