//
//  YSUserModel.m
//  yanshaniOS
//
//  Created by 代健 on 2018/3/18.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSUserModel.h"
static YSUserModel *model = nil;
@implementation YSUserModel

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[self alloc] init];
    });
    return model;
}

- (void)updateUserInformationWithData:(NSDictionary *)data {
    _userId = [data objectForKey:@"id"];
    _userIcon = [data objectForKey:@"icon"];
    _userName = [data objectForKey:@"userName"];
    _userRealName = [data objectForKey:@"realName"];
}

@end
