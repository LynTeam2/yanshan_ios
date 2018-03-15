//
//  YSCourseCategoryModel.m
//  yanshaniOS
//
//  Created by 代健 on 2018/2/4.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSCourseCategoryModel.h"

@implementation YSCourseCategoryModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
            @"categoryName":@"categoryName",
            @"createTime":@"createTime",
            @"icon":@"icon",
            @"iconName":@"iconName",
            @"id":@"categoryId",
            @"introduction":@"introduction",
            @"jsonName":@"jsonName",
            @"parentId":@"parentId",
            @"subCategories":@"subCategories"
            }];
}

@end
