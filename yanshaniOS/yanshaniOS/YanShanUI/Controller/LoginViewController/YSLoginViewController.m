//
//  YSLoginViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2017/11/19.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSLoginViewController.h"
#import "AppDelegate+YSWelcome.h"

@interface YSLoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;

@end

@implementation YSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BOOL new = [[[NSUserDefaults standardUserDefaults] objectForKey:kNewApp] boolValue];
    if (!new) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        [UIApplication sharedApplication].keyWindow.rootViewController = [sb instantiateViewControllerWithIdentifier:@"welcomeVC"];
        return;
    }
    if ([[YSUserLoginModel shareInstance] userInformationComplete]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _username.text = [YSUserLoginModel shareInstance].userName;
        _password.text = @"*********";
    }
    _username.layer.borderWidth = _password.layer.borderWidth = 1.0;
    _username.layer.borderColor = _password.layer.borderColor = kRGBColor(229, 239, 235, 1).CGColor;
    UIButton *leftView1 = [UIButton buttonWithType:UIButtonTypeCustom];
    leftView1.frame = CGRectMake(0, 0, 30, 30);
    [leftView1 setImage:[UIImage imageNamed:@"alert"] forState:UIControlStateNormal];
    
    UIButton *leftView2 = [UIButton buttonWithType:UIButtonTypeCustom];
    leftView2.frame = CGRectMake(0, 0, 30, 30);
    [leftView2 setImage:[UIImage imageNamed:@"smile"] forState:UIControlStateNormal];
    
    leftView1.contentMode = leftView2.contentMode = UIViewContentModeScaleAspectFit;
    _username.leftView = leftView1;
    _password.leftView = leftView2;
    _username.leftViewMode = _password.leftViewMode = UITextFieldViewModeAlways;
    [[YSUserLoginModel shareInstance] userAutoLogin:^(BOOL success) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            [UIApplication sharedApplication].keyWindow.rootViewController = [sb instantiateViewControllerWithIdentifier:@"tabbarviewcontroller"];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action

- (IBAction)loginAction:(UIButton *)sender {
    if (_username.text.length == 0 || _password.text.length == 0) {
        [self.view makeToast:@"请输入用户名或密码" duration:2.0 position:@"center"];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   
    [[YSNetWorkEngine sharedInstance] userLoginWithUseName:_username.text password:_password.text  responseHandler:^(NSError *error, NSDictionary *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            NSString *msg = data[@"msg"] ? data[@"msg"] : @"用户名或密码错误";
            [self.view makeToast:msg duration:2.0 position:@"center"];
            return ;
        }
        if ([[data objectForKey:@"code"] boolValue]) {
            NSDictionary *res = [data objectForKey:@"results"];
            [[YSUserModel shareInstance] updateUserInformationWithData:res[@"user"]];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            [UIApplication sharedApplication].keyWindow.rootViewController = [sb instantiateViewControllerWithIdentifier:@"tabbarviewcontroller"];
            [[YSUserLoginModel shareInstance] saveUserLoginInformation:_username.text password:_password.text];
        }else{
            NSString *msg = data[@"msg"] ? data[@"msg"] : @"用户名或密码错误";
            [self.view makeToast:msg duration:2.0 position:@"center"];
        }
    }];
}
- (IBAction)endEditor:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

@end
