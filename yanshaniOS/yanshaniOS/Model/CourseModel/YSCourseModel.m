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
            @"id":@"courseId",
            @"mcList":@"mcList",
            @"scList":@"scList",
            @"tfList":@"tfList",
            @"updateTime":@"updateTime",           
            }];
}

@end
