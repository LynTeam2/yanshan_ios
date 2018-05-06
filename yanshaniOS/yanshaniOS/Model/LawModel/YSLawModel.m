//
//  YSLawModel.m
//  yanshaniOS
//
//  Created by 代健 on 2018/5/5.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSLawModel.h"

@implementation YSLawModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                    @"lawID":@"id",
                                                    @"createTime":@"createTime",
                                                    @"iconPath":@"iconPath",
                                                    @"updateTime":@"updateTime",
                                                    @"fileName":@"fileName",
                                                    @"filePath":@"filePath",
                                                    @"lawName":@"lawName",
                                                    @"lawType":@"lawType"}];
}

@end
