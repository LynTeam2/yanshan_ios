//
//  YSCourseModel.m
//  yanshaniOS
//
//  Created by 代健 on 2018/2/4.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSCourseModel.h"

@implementation YSCourseModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
            @"ajType":@"ajType",
            @"bfList":@"bfList",
            @"content":@"content",
            @"courseName":@"courseName",
            @"courseType":@"courseType",
            @"createTime":@"createTime",
            @"homePage":@"homePage",
            @"icon":@"icon",
            @"iconName":@"iconName",
            @"courseId":@"id",
            @"mcList":@"mcList",
            @"scList":@"scList",
            @"tfList":@"tfList",
            @"updateTime":@"updateTime",
            @"video":@"video"}];
}

- (NSString<Optional> *)courseContent {
    if (_courseType == 1) {
        return self.content;
    }else{
        return self.video;
    }
}

- (NSArray<YSCourseItemModel *><Optional> *)scList {
    if (_courseId) {
        NSDictionary *dic =  [[[YSFileManager sharedFileManager] JSONSerializationJsonFile:[NSString stringWithFormat:@"%@.json",_courseId] atDocumentName:@"course"] objectForKey:@"course"];
        NSArray *arr = dic[@"scList"];
        return arr;
    }
    return nil;
}

- (NSArray<YSCourseItemModel *><Optional> *)mcList {
    if (_courseId) {
        NSDictionary *dic =  [[[YSFileManager sharedFileManager] JSONSerializationJsonFile:[NSString stringWithFormat:@"%@.json",_courseId] atDocumentName:@"course"] objectForKey:@"course"];
        NSArray *arr = dic[@"mcList"];
        return arr;
    }
    return nil;
}

- (NSArray<YSCourseItemModel *><Optional> *)tfList {
    if (_courseId) {
        NSDictionary *dic =  [[[YSFileManager sharedFileManager] JSONSerializationJsonFile:[NSString stringWithFormat:@"%@.json",_courseId] atDocumentName:@"course"] objectForKey:@"course"];
        NSArray *arr = dic[@"tfList"];
        return arr;
    }
    return nil;
}

@end
