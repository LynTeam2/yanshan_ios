//
//  YSUserLoginModel.h
//  yanshaniOS
//
//  Created by jianjiandai on 2018/3/27.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^UserLoginCallBack)(BOOL success);
@interface YSUserLoginModel : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userPassWord;

+ (instancetype)shareInstance;

- (void)userAutoLogin:(UserLoginCallBack)handler;

- (void)userLogout:(UserLoginCallBack)handler;

- (void)saveUserLoginInformation:(NSString *)userName password:(NSString *)pw;

@end
