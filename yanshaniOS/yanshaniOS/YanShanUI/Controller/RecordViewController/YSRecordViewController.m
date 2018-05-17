//
//  YSRecordViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2017/10/4.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSRecordViewController.h"
#import "YSHistoryScoreViewController.h"
#import "YSExamManager.h"
#import "YSExaminationItemModel.h"
#import "YSWrongItemsViewController.h"
#import "YSRecordStatisticView.h"

static NSString *redString     = @"ff6464";
static NSString *orangeString  = @"ffc664";
static NSString *blueString    = @"6490ff";

@interface YSRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
{
//    NSArray *allExams;
//    YSExaminationItemModel *examModel;
//    UITableView *mainView;
//    UILabel *testResultLabel;
    NSArray *allExams;
    YSExaminationItemModel *examModel;
    UITableView *mainView;
    UILabel *scoreLabel;
    UILabel *testResultLabel;
    YSRecordStatisticView *statiscView1;
    YSRecordStatisticView *statiscView2;
    YSRecordStatisticView *statiscView3;
    YSRecordStatisticButton *btn1;
    YSRecordStatisticButton *btn2;
    YSRecordStatisticButton *btn3;
    YSRecordStatisticButton *btn4;
}

@end

@implementation YSRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kLightGray;
}

- (void)viewWillAppear:(BOOL)animated {
    if ([[YSExamManager sharedExamManager] getAllExams].count) {
        allExams = [NSArray arrayWithArray:[[YSExamManager sharedExamManager] getAllExams]];
        examModel = allExams[0];
        testResultLabel.text = [NSString stringWithFormat:@"答错%ld题,未做%ld题,%@",examModel.wrongItemCount,[examModel undoItem],examModel.examJudgement];
        scoreLabel.text = [NSString stringWithFormat:@"%ld分",examModel.examScore];
        [statiscView1 updateContentUseStatisticData:examModel withViewType:(YSRecordStatisticViewTypeSimple)];
        [statiscView2 updateContentUseStatisticData:examModel withViewType:(YSRecordStatisticViewTypeMultable)];
        [statiscView3 updateContentUseStatisticData:examModel withViewType:(YSRecordStatisticViewTypeTOF)];
    }
    if ([[YSExamManager sharedExamManager] getAllExams].count) {
        testResultLabel.text = [NSString stringWithFormat:@"答错%ld题,未做%ld题 %@",examModel.wrongItemCount,[examModel undoItem],examModel.examJudgement];
        NSString *subTitle = [NSString stringWithFormat:@"做错%ld题,未做%ld题",examModel.wrongItemCount,[examModel undoItem]];
        NSDictionary *dic1 = @{@"image":@"newwrong",@"title":@"查看错题",@"subtitle":subTitle};
        [btn1 updateButtonContentWithData:dic1];
        subTitle = [NSString stringWithFormat:@"做错%ld题,未做%ld题",[examModel getAllWrongSCItem].count,[examModel getAllUndoSCItem].count];
        NSDictionary *dic2 = @{@"image":@"newsc",@"title":@"单选错题",@"subtitle":subTitle};
        [btn2 updateButtonContentWithData:dic2];
        subTitle = [NSString stringWithFormat:@"做错%ld题,未做%ld题",[examModel getAllWrongMCItem].count,[examModel getAllUndoMCItem].count];
        NSDictionary *dic3 = @{@"image":@"newmc",@"title":@"多选错题",@"subtitle":subTitle};
        [btn3 updateButtonContentWithData:dic3];
        subTitle = [NSString stringWithFormat:@"做错%ld题,未做%ld题",[examModel getAllWrongTFItem].count,[examModel getAllUndoTFItem].count];
        NSDictionary *dic4 = @{@"image":@"newtf",@"title":@"判断错题",@"subtitle":subTitle};
        [btn4 updateButtonContentWithData:dic4];
    }
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
    
    CGFloat height = self.view.frame.size.height*0.55;
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    UIView *secondSectionView = [[UIView alloc] init];
    secondSectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:secondSectionView];
                    
    if ([self.view respondsToSelector:@selector(safeAreaLayoutGuide)]) {
        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.mas_equalTo(height);
        }];
    }else if ([UIViewController instancesRespondToSelector:@selector(topLayoutGuide)]) {
        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_topLayoutGuide);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.mas_equalTo(height);
        }];
    }
    
    [secondSectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(headerView.mas_bottom).offset(10);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    UIImageView *chengjiBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chengjitongjibg"]];
    [headerView addSubview:chengjiBG];
    
    scoreLabel = [[UILabel alloc] init];
    scoreLabel.text = @"0分";
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
    
    statiscView1 = [[YSRecordStatisticView alloc] init];
    [statiscView1 proccessViewColor:[YSCommonHelper getUIColorFromHexString:redString]];
    [headerView addSubview:statiscView1];
    
    statiscView2 = [[YSRecordStatisticView alloc] init];
    [statiscView2 proccessViewColor:[YSCommonHelper getUIColorFromHexString:orangeString]];
    [headerView addSubview:statiscView2];
    
    statiscView3 = [[YSRecordStatisticView alloc] init];
    [statiscView3 proccessViewColor:[YSCommonHelper getUIColorFromHexString:blueString]];
    [headerView addSubview:statiscView3];
    
    [chengjiBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.top.equalTo(headerView);
        make.width.equalTo(headerView);
        make.height.mas_equalTo(180);
    }];
    
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
    [statiscView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.top.equalTo(statiscView2.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
        make.width.equalTo(headerView);
    }];
    
    CGFloat btnSpace = 20;
    CGFloat btnWidth = (self.view.frame.size.width-btnSpace*3)/2;
    CGFloat btnHeight = 60;
    btn1 = [[YSRecordStatisticButton alloc] initWithStatisticButtonType:StatisticButtonTypeDefault];
    [secondSectionView addSubview:btn1];
    
    btn2 = [[YSRecordStatisticButton alloc] initWithStatisticButtonType:StatisticButtonTypeSC];
    [secondSectionView addSubview:btn2];
    
    btn3 = [[YSRecordStatisticButton alloc] initWithStatisticButtonType:StatisticButtonTypeMC];
    [secondSectionView addSubview:btn3];
    
    btn4 = [[YSRecordStatisticButton alloc] initWithStatisticButtonType:StatisticButtonTypeTF];
    [secondSectionView addSubview:btn4];
    
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(secondSectionView).offset(btnSpace);
        make.top.equalTo(secondSectionView).offset(btnSpace);
        make.height.mas_equalTo(btnHeight);
        make.width.mas_equalTo(btnWidth);
    }];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(secondSectionView).offset(-btnSpace);
        make.top.equalTo(secondSectionView).offset(btnSpace);
        make.height.mas_equalTo(btnHeight);
        make.width.mas_equalTo(btnWidth);
    }];
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(secondSectionView).offset(btnSpace);
        make.top.equalTo(secondSectionView).offset(btnSpace*2+btnHeight);
        make.height.mas_equalTo(btnHeight);
        make.width.mas_equalTo(btnWidth);
    }];
    [btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(secondSectionView).offset(-btnSpace);
        make.top.equalTo(secondSectionView).offset(btnSpace*2+btnHeight);
        make.height.mas_equalTo(btnHeight);
        make.width.mas_equalTo(btnWidth);
    }];
    [btn1 addTarget:self andSel:@selector(btn1:)];
    [btn2 addTarget:self andSel:@selector(btn2:)];
    [btn3 addTarget:self andSel:@selector(btn3:)];
    [btn4 addTarget:self andSel:@selector(btn4:)];
    
}

- (void)addNavigationItems {
    UIButton *sender = [self customNavgationBarItem:self.navigationItem.rightBarButtonItem withTitle:@"历史成绩"];
    [sender addTarget:self action:@selector(historyScore:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - class method

- (void)btn1:(UIButton *)sender {
    YSWrongItemsViewController *itemsVC = [[YSWrongItemsViewController alloc] init];
    [itemsVC setWrongItemsData:[examModel allWrongItems]];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:itemsVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)btn2:(UIButton *)sender {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    if ([examModel getAllWrongSCItem].count) {
        [arr addObjectsFromArray:[examModel getAllWrongSCItem]];
    }
    if ([examModel getAllUndoSCItem]) {
        [arr addObjectsFromArray:[examModel getAllUndoSCItem]];
    }
    if (arr.count == 0) {
        return;
    }
    YSWrongItemsViewController *itemsVC = [[YSWrongItemsViewController alloc] init];
    [itemsVC setWrongItemsData:arr];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:itemsVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)btn3:(UIButton *)sender {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    if ([examModel getAllWrongMCItem].count) {
        [arr addObjectsFromArray:[examModel getAllWrongMCItem]];
    }
    if ([examModel getAllUndoMCItem]) {
        [arr addObjectsFromArray:[examModel getAllUndoMCItem]];
    }
    if (arr.count == 0) {
        return;
    }
    YSWrongItemsViewController *itemsVC = [[YSWrongItemsViewController alloc] init];
    [itemsVC setWrongItemsData:arr];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:itemsVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)btn4:(UIButton *)sender {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    if ([examModel getAllWrongTFItem].count) {
        [arr addObjectsFromArray:[examModel getAllWrongTFItem]];
    }
    if ([examModel getAllUndoTFItem]) {
        [arr addObjectsFromArray:[examModel getAllUndoTFItem]];
    }
    if (arr.count == 0) {
        return;
    }
    YSWrongItemsViewController *itemsVC = [[YSWrongItemsViewController alloc] init];
    [itemsVC setWrongItemsData:arr];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:itemsVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
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
    return examModel ? 3 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
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
    }
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
