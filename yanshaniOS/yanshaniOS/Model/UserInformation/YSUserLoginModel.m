//
//  YSUserLoginModel.m
//  yanshaniOS
//
//  Created by jianjiandai on 2018/3/27.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSUserLoginModel.h"

static YSUserLoginModel *loginModel = nil;

@implementation YSUserLoginModel

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginModel = [[self alloc] init];
    });
    return loginModel;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        self.userPassWord = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    }
    return self;
}


- (void)userAutoLogin:(UserLoginCallBack)handler {
    if (!_userName || !_userPassWord) {
        handler(NO);
        return;
    }
    if (_userName && _userPassWord) {
        [[YSNetWorkEngine sharedInstance] userLoginWithUseName:_userName password:_userPassWord responseHandler:^(NSError *error, id data) {
            if ([[data objectForKey:@"code"] boolValue]) {
                handler(YES);
                NSDictionary *res = [data objectForKey:@"results"];
                [[YSUserModel shareInstance] updateUserInformationWithData:res[@"user"]];
            }else{
                handler(NO);
            }
        }];
    }
}

- (void)userLogout:(UserLoginCallBack)handler {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
    handler(YES);
}

- (BOOL)userInformationComplete {
    if (_userName && _userPassWord) {
        return YES;
    }
    return NO;
}

- (void)saveUserLoginInformation:(NSString *)userName password:(NSString *)pw {
    
    if (userName) {
        [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"username"];
    }
    if (pw) {
        [[NSUserDefaults standardUserDefaults] setObject:pw forKey:@"password"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
