//
//  YSExamModel.m
//  yanshaniOS
//
//  Created by 代健 on 2018/4/15.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSExamModel.h"

@implementation YSExamModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:
                                        @{@"examId":@"id",
                                        @"createTime":@"createTime",
                                        @"updateTime":@"updateTime",
                                        @"endDate":@"endDate",
                                        @"examName":@"examName",
                                        @"introduction":@"introduction",
                                        @"examType":@"examType",
                                        @"examDuration":@"examDuration",
                                        @"role":@"role",
                                        @"standard":@"standard",
                                        @"startDate":@"startDate",
                                        @"scList":@"scList",
                                        @"mcList":@"mcList",
                                        @"bfList":@"bfList",
                                          @"tfList":@"tfList",@"courseList":@"courseList"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"examId"]) {
        return YES;
    }
    if ([propertyName isEqualToString:@"standard"]) {
        return YES;
    }
    return NO;
}

@end
