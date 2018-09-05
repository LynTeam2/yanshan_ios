//
//  YSUserModel.m
//  yanshaniOS
//
//  Created by 代健 on 2018/3/18.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSUserModel.h"
#import "YSExamManager.h"

static YSUserModel *model = nil;
@implementation YSUserModel

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[self alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:model selector:@selector(updateUserExaminationHistoryRecords:) name:kUnzipSuccessNotification object:nil];
    });
    return model;
}

- (void)updateUserInformationWithData:(NSDictionary *)data {
    _userId     = [data objectForKey:@"id"];
    _userIcon   = [data objectForKey:@"icon"];
    _userName   = [data objectForKey:@"userName"];
    _userRealName = [data objectForKey:@"realName"];
    _nickName     = data[@"nickname"];
    _beanCount    = [data[@"beanCount"] integerValue];
    _roleName     = data[@"roleName"];
    _courseProcessList = [NSArray arrayWithArray:data[@"courseProcessList"]];
    NSMutableArray *ids = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in _courseProcessList) {
        [ids addObject:@{@"id":dic[@"courseId"]}];
    }
    [[YSCourseManager sharedCourseManager] syncronizeSerVerCourseProcessData:ids];
    [[YSNetWorkEngine sharedInstance] getExamHistoryRecordsWithResponseHandler:^(NSError *error, id data) {
        if (!error) {
            [[YSExamManager sharedExamManager] syncrosizeUserExamHistory:[[data objectForKey:@"results"] objectForKey:@"examHistories"]];
        }
    }];
}

- (void)updateUserExaminationHistoryRecords:(NSNotification *)noti {
    [[YSNetWorkEngine sharedInstance] getExamHistoryRecordsWithResponseHandler:^(NSError *error, id data) {
        if (!error) {
            [[YSExamManager sharedExamManager] syncrosizeUserExamHistory:[[data objectForKey:@"results"] objectForKey:@"examHistories"]];
        }
    }];
}

@end
