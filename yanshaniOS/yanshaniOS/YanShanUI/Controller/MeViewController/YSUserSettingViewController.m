//
//  YSUserSettingViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2017/11/19.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSUserSettingViewController.h"
#import "UITableViewCell+YSCustomCell.h"
#import "YSUserInformationEditorViewController.h"

@interface YSUserSettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate>
{
    YSBaseTableView *_userSettingTableView;
    NSArray *_settings;
}

@end

@implementation YSUserSettingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_userSettingTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - config view controller

- (void)configViewControllerParameter {
    _settings = @[@"头像",@"昵称",@"修改密码",@"更新题库"];
}

- (void)configView {
    _userSettingTableView = [[YSBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _userSettingTableView.delegate = self;
    _userSettingTableView.dataSource = self;
    _userSettingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_userSettingTableView];
    _userSettingTableView.backgroundColor = [UIColor whiteColor];
    [_userSettingTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(-220);
    }];
    
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn setBackgroundColor:kBlueColor];
    [logoutBtn addTarget:self action:@selector(userLogout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
    logoutBtn.layer.cornerRadius = 25;
    logoutBtn.layer.masksToBounds = YES;
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.bottom.equalTo(self.view).offset(-160);
        make.height.mas_equalTo(50);
    }];
}

- (void)addNavigationItems {
    self.title = @"个人设置";
    [self addPopViewControllerButtonWithTarget:self action:@selector(backViewController:)];
}


#pragma mark - UITableView delegate - datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _settings.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *useableId = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:useableId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:useableId];
        UIImageView *accessView = [[UIImageView alloc] init];
        accessView.image = [UIImage imageNamed:@"rightgraybackicon"];
        accessView.frame = CGRectMake(0, 0, 8, 16);
        cell.accessoryView = accessView;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell addSeparatorLineWithLeftSpace:20];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self addCustomViewForCell:cell atIndexPath:indexPath];
    cell.textLabel.text = _settings[indexPath.row];
    return cell;
}

- (void)addCustomViewForCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            UIImageView *icon = [[UIImageView alloc] init];
            [icon sd_setImageWithURL:[NSURL URLWithString:[YSUserModel shareInstance].userIcon] placeholderImage:[UIImage imageNamed:@"headericon"]];
            icon.layer.cornerRadius = 15;
            icon.layer.masksToBounds = YES;
            [cell.contentView addSubview:icon];
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView).offset(-20);
                make.centerY.equalTo(cell.contentView);
                make.size.mas_equalTo(CGSizeMake(30, 30));
            }];
        }
            break;
        case 1:{
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentRight;
            label.textColor = [UIColor grayColor];
            label.text = [YSUserModel shareInstance].nickName;
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView).offset(-20);
                make.centerY.equalTo(cell.contentView);
                make.size.mas_equalTo(CGSizeMake(150, 30));
            }];
        }
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(1 == indexPath.row || 2 == indexPath.row) {
        YSUserInformationEditorViewController *edVC = [[YSUserInformationEditorViewController alloc] init];
        edVC.type = indexPath.row == 1 ? UserInformationTypeUserName : UserInformationTypePassword;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:edVC animated:YES];
    }else if (0 == indexPath.row){
        UIImagePickerController *imPC = [[UIImagePickerController alloc] init];
        imPC.delegate = self;
        [self presentViewController:imPC animated:YES completion:^{
            
        }];
    }else if (3 == indexPath.row) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[YSFileManager sharedFileManager] zipDoUpdateByHand:^(BOOL success) {
            if (success) {
                [[UIApplication sharedApplication].keyWindow makeToast:@"更新成功" duration:2.0 position:@"center"];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"%@",info);
    [picker dismissViewControllerAnimated:YES completion:nil];
    if ([info objectForKey:@"UIImagePickerControllerOriginalImage"]) {
        UIImage *img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[YSNetWorkEngine sharedInstance] modifyUserHeaderWithImage:img responseHandler:^(NSError *error, id data) {
            if (nil == error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.view makeToast:@"头像修改成功" duration:2.0 position:@"center"];
            }
            [_userSettingTableView reloadData];
        }];
        
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.view makeToast:@"头像修改失败" duration:2.0 position:@"center"];
}

#pragma mark - Button action

- (void)userLogout:(UIButton *)sender {
    [[YSUserLoginModel shareInstance] userLogout:^(BOOL success) {
        if (success) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            [UIApplication sharedApplication].keyWindow.rootViewController = [sb instantiateViewControllerWithIdentifier:@"loginViewController"];
        }
    }];
}


@end
