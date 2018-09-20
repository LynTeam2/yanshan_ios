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
    
    mainView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    mainView.delegate = self;
    mainView.dataSource = self;
    mainView.backgroundColor = [UIColor whiteColor];
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
    
    
    UIView *waveView = [[UIView alloc] init];
    waveView.layer.cornerRadius = 75;
    waveView.layer.masksToBounds = YES;
    waveView.layer.borderWidth = kLineHeight*2;
    waveView.layer.borderColor = kLightGray.CGColor;
    [headerView addSubview:waveView];
    
    CAShapeLayer *slayer = [CAShapeLayer layer];
    slayer.frame = CGRectMake(0, 0, 150, 150);
    slayer.path = [self drawWaterwaveWithLayerFrame:slayer.bounds];
    slayer.fillColor = kBlueColor.CGColor;
    [waveView.layer addSublayer:slayer];
    
    UILabel *circleLabel = [[UILabel alloc] init];
    circleLabel.backgroundColor = [UIColor clearColor];
    circleLabel.text = @"累计做题\n0次";
    circleLabel.numberOfLines = 0;
    circleLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:circleLabel];
    
    [circleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).offset(25);
        make.centerX.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(150, 150));
    }];
    
    [waveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.bottom.equalTo(circleLabel);
    }];;
    
    if ([[YSExamManager sharedExamManager] getAllExams].count) {
        NSMutableArray *m = [NSMutableArray arrayWithCapacity:0];
        allExams = [[[YSExamManager sharedExamManager] getAllExams] copy];
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
            make.top.equalTo(circleLabel.mas_bottom);
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
    scoreLabel.text = [NSString stringWithFormat:@"%ld分",model.examScore];
    [cell.contentView addSubview:scoreLabel];
    
    UILabel *resultLabel = [[UILabel alloc] init];
    resultLabel.text = [model.dateString substringWithRange:NSMakeRange(0, model.dateString.length-3)];
    resultLabel.adjustsFontSizeToFitWidth = YES;
    resultLabel.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:resultLabel];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = model.examName;
    timeLabel.adjustsFontSizeToFitWidth = YES;
    timeLabel.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:timeLabel];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kLightGray;
    [cell.contentView addSubview:line];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightgoicon"]];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    icon.frame = CGRectMake(0, 0, 20, 20);
    cell.accessoryView = icon;
    [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(20);
        make.top.equalTo(cell.contentView);
        make.height.equalTo(cell.contentView);
        make.width.mas_equalTo(80);
    }];
//    scoreLabel.backgroundColor = kRandomColor;
//    resultLabel.backgroundColor = kRandomColor;
//    timeLabel.backgroundColor = kRandomColor;
    [resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scoreLabel.mas_right);
        make.top.equalTo(cell.contentView);
        make.height.equalTo(cell.contentView);
        make.width.mas_equalTo(120);
    }];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(resultLabel.mas_right).offset(10);
        make.top.equalTo(cell.contentView);
        make.height.equalTo(cell.contentView);
        make.right.equalTo(cell.contentView);
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
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"历史考试成绩";
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(-10, 10, self.view.frame.size.width+20, 44);
    label.layer.borderWidth = 0.5;
    label.layer.borderColor = kLightGray.CGColor;
    label.backgroundColor = [UIColor whiteColor];
    [view addSubview:label];
    view.backgroundColor = kLightGray;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 54;
}


#pragma mark - draw water

- (void)addWaterwaveView {
    CAShapeLayer *slayer = [CAShapeLayer layer];
    slayer.frame = CGRectMake(self.view.frame.size.width/2, 25, 150, 150);
    slayer.path = [self drawWaterwaveWithLayerFrame:slayer.bounds];
    slayer.fillColor = kBlueColor.CGColor;
    [mainView.tableHeaderView.layer addSublayer:slayer];
}


- (CGPathRef)drawWaterwaveWithLayerFrame:(CGRect)frame {
    
    UIBezierPath *waterwavePath = [UIBezierPath bezierPath];
    CGFloat baseNumber = allExams.count;
    [waterwavePath moveToPoint:CGPointMake(0, 130-baseNumber)];
    for (int x = 0; x < frame.size.width; x++) {
        CGFloat y = 10 * sin(-x/frame.size.width*M_PI)+(130-baseNumber);
        [waterwavePath addLineToPoint:CGPointMake(x, y)];
    }
    [waterwavePath addLineToPoint:CGPointMake(frame.size.width, frame.size.height)];
    [waterwavePath addLineToPoint:CGPointMake(0, frame.size.height)];
    [waterwavePath closePath];
    return waterwavePath.CGPath;
}


@end
