//
//  YSMessageModel.m
//  yanshaniOS
//
//  Created by 代健 on 2017/12/3.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSMessageModel.h"

@implementation YSMessageModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"title":@"title",
                                                                  @"messageDescription":@"messageDescription"}];
}

@end
