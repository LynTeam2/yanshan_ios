//
//  YSLoginViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2017/11/19.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSLoginViewController.h"

@interface YSLoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;

@end

@implementation YSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[YSUserLoginModel shareInstance] userInformationComplete]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
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
//    if (_username.text.length == 0 || _password.text.length == 0) {
//        [self.view makeToast:@"请输入用户名或密码" duration:2.0 position:@"center"];
//        return;
//    }
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//   
//    [[YSNetWorkEngine sharedInstance] userLoginWithUseName:_username.text password:_password.text  responseHandler:^(NSError *error, NSDictionary *data) {
//        if (error) {
//            [self.view makeToast:@"用户名或密码错误" duration:2.0 position:@"center"];
//            return ;
//        }
//        if ([[data objectForKey:@"code"] boolValue]) {
//            NSDictionary *res = [data objectForKey:@"results"];
//            [[YSUserModel shareInstance] updateUserInformationWithData:res[@"user"]];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            [UIApplication sharedApplication].keyWindow.rootViewController = [sb instantiateViewControllerWithIdentifier:@"tabbarviewcontroller"];
//            [[YSUserLoginModel shareInstance] saveUserLoginInformation:_username.text password:_password.text];
//        }else{
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            [self.view makeToast:@"用户名或密码错误" duration:2.0 position:@"center"];
//        }
//    }];

}

@end
