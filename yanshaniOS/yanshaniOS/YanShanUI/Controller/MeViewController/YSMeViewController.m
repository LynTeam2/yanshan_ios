//
//  YSMeViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2017/10/4.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSMeViewController.h"
#import "YSUserSettingViewController.h"
#import "YSQianDaoViewController.h"
#import "UITableViewCell+YSCustomCell.h"

@interface YSMeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    YSBaseTableView *_loginView;
    NSArray *titles;
    NSArray *icons;
}
@end

@implementation YSMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configViewControllerParameter {
    titles = @[@"个人设置",@"签到有礼",@"我的消息"];
    icons = @[@"setting",@"qiandao",@"message"];
}

- (void)configView {
    self.title = @"我";
    _loginView = [[YSBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _loginView.delegate = self;
    _loginView.dataSource = self;
    _loginView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_loginView];
    [_loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
}

#pragma mark - UITableView delegate - datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [self initCell:cell indexPath:indexPath];
    return cell;
}

- (void)initCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:icons[indexPath.row]];
    [cell.contentView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.left.equalTo(cell).offset(20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = titles[indexPath.row];
    [cell.contentView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.left.equalTo(imageView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
    [cell addSeparatorLineWithLeftSpace:20];
    
    UIImageView *accessView = [[UIImageView alloc] init];
    accessView.frame = CGRectMake(0, 0, 8, 16);
    accessView.image = [UIImage imageNamed:@"rightgraybackicon"];
    cell.accessoryView = accessView;
    cell.accessoryType = UITableViewCellAccessoryNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 170;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, 0, 0);
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *headerIcon = [[UIImageView alloc] init];
    headerIcon.image = [UIImage imageNamed:@"headericon"];
    [headerView addSubview:headerIcon];
    
    UILabel *nickNameLabel = [[UILabel alloc] init];
    nickNameLabel.textAlignment = NSTextAlignmentCenter;
    nickNameLabel.text = @"闪乱神乐";
    [headerView addSubview:nickNameLabel];
    
    UILabel *balanceLabel = [[UILabel alloc] init];
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    balanceLabel.text = @"财富值:100安全豆";
    [headerView addSubview:balanceLabel];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor grayColor];
    [headerView addSubview:line];
    
    [headerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.top.equalTo(headerView).offset(20);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerIcon.mas_bottom).offset(5);
        make.centerX.equalTo(headerView);
        make.width.equalTo(headerView);
        make.height.mas_equalTo(20);
    }];
    [balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nickNameLabel.mas_bottom).offset(5);
        make.centerX.equalTo(headerView);
        make.width.equalTo(headerView);
        make.height.mas_equalTo(20);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headerView.mas_bottom);
        make.centerX.equalTo(headerView);
        make.width.equalTo(headerView);
        make.height.mas_equalTo(0.5);
    }];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    switch (indexPath.row) {
        case 0:{
            YSUserSettingViewController *userSettingVC = [[YSUserSettingViewController alloc] init];
            [self.navigationController pushViewController:userSettingVC animated:YES];
        }
            break;
        case 1:{
            YSQianDaoViewController *qiandaoVC = [[YSQianDaoViewController alloc] init];
            [self.navigationController pushViewController:qiandaoVC animated:YES];
        }
            break;
        case 2:
            
            break;
        default:
            break;
    }
    self.hidesBottomBarWhenPushed = NO;
}

@end
