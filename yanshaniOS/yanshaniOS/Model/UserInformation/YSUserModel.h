//
//  YSUserModel.h
//  yanshaniOS
//
//  Created by 代健 on 2018/3/18.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface YSUserModel : JSONModel

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userIcon;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userRealName;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, assign) NSInteger beanCount;
@property (nonatomic, strong) NSString *roleName;
@property (nonatomic, strong) NSArray *courseProcessList;


+ (instancetype)shareInstance;

- (void)updateUserInformationWithData:(NSDictionary *)data;

@end
