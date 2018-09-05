//
//  YSUserInformationEditorViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2018/5/4.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSUserInformationEditorViewController.h"

@interface YSUserInformationEditorViewController ()

@property (nonatomic, strong) UITextField *tf;

@end

@implementation YSUserInformationEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改个人信息";
    [self addPopViewControllerButtonWithTarget:self action:@selector(backViewController:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configView {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel:)];
    [self.view addGestureRecognizer:tap];
    _tf = [[UITextField alloc] init];
    _tf.text = [YSUserModel shareInstance].nickName;
    [self.view addSubview:_tf];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kLightGray;
    [self.view addSubview:line];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setBackgroundColor:kBlueColor];
    [btn addTarget:self action:@selector(confirmModify:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [self.view addSubview:btn];
    
    [_tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(40);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(_tf);
        make.bottom.equalTo(_tf);
        make.height.mas_equalTo(kLineHeight);
    }];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tf.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
}

- (void)configViewControllerParameter {
    
}

- (void)confirmModify:(UIButton *)sender {
    if (_tf.text.length == 0 || [_tf.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
        [self.view makeToast:@"昵称为空或含有特殊字符" duration:2.0 position:@"center"];
        return;
    }
    [[YSNetWorkEngine sharedInstance] modifyUserInformationWithParam:@{@"nickname":_tf.text} responseHandler:^(NSError *error, id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)data;
            if ([dic[@"code"] boolValue]) {
                [[UIApplication sharedApplication].keyWindow makeToast:@"修改成功" duration:2.0 position:@"center"];
                [YSUserModel shareInstance].nickName = _tf.text;
                [self backViewController:nil];
            }
        }
    }];
}

- (void)cancel:(UITapGestureRecognizer *)tap {
    [_tf resignFirstResponder];
}

@end
