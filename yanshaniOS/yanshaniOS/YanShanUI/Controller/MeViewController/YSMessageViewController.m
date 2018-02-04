//
//  YSMessageViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2017/12/2.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSMessageViewController.h"
#import "YSMessageModel.h"
#import "YSMessageDetailViewController.h"

@interface YSMessageViewController ()

@end

@implementation YSMessageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self performSelector:@selector(reloadData) withObject:nil afterDelay:3];
}

- (void)reloadData {
    NSArray *arr = @[@{@"title":@"哈哈哈",@"messageDescription":@"这是一条空消息",@"isRead":@0},@{@"title":@"呵呵呵",@"messageDescription":@"这还是一条空消息",@"isRead":@1}];
    _datas = [YSMessageModel arrayOfModelsFromDictionaries:arr error:nil];
    [self reloadViewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - config view controller

- (void)configViewControllerParameter {
    [super configViewControllerParameter];
}

- (void)addNavigationItems {
    self.title = @"我的消息";
    [self addPopViewControllerButtonWithTarget:self action:@selector(backViewController:)];
}

#pragma mark - UITableView delegate - datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        UIImageView *accessView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightgraybackicon"]];
        accessView.frame = CGRectMake(0, 0, 9, 17);
        cell.accessoryView = accessView;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    YSMessageModel *model = _datas[indexPath.row];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.messageDescription;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YSMessageDetailViewController *detailVC = [[YSMessageDetailViewController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
