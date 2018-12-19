//
//  YSRegisterViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2018/11/20.
//  Copyright © 2018 jiandai. All rights reserved.
//

#import "YSRegisterViewController.h"

@interface YSRegisterViewController ()

@property (strong, nonatomic) IBOutlet UITextField *telephoneNumberTF;
@property (strong, nonatomic) IBOutlet UITextField *codeTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation YSRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (IBAction)userRegister:(UIButton *)sender {
    
    if (self.telephoneNumberTF.text.length < 11) {
        [self.view makeToast:@"手机号不正确" duration:2.0 position:@"center"];
        return;
    }
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)2.0*NSEC_PER_SEC);
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self.view makeToast:@"验证码发送成功" duration:2.0 position:@"center"];
    });
}

- (IBAction)registerUser:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.telephoneNumberTF.text.isEmptyString || self.codeTF.text.isEmptyString || self.passwordTF.text.isEmptyString) {
        [self.view makeToast:@"信息填写不完整" duration:2.0 position:@"center"];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
