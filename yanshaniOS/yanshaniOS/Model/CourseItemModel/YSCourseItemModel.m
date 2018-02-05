//
//  YSCourseItemModel.m
//  yanshaniOS
//
//  Created by 代健 on 2018/2/4.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSCourseItemModel.h"

@implementation YSCourseItemModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
            @"ajType":@"ajType",
            @"analysis":@"analysis",
            @"answer":@"answer",
            @"createTime":@"createTime",
            @"difficulty":@"difficulty",
            @"id":@"itemId",
            @"question":@"question",
            @"questionType":@"questionType",
            @"choiceA":@"choiceA",
            @"choiceB":@"choiceB",
            @"choiceC":@"choiceC",
            @"choiceD":@"choiceD",
            @"updateTime":@"updateTime"
            }];
}

- (NSArray *)getItemChoices {
    if ([_questionType isEqualToString:@"mc"]) {
        return @[[NSString stringWithFormat:@" %@",_choiceA],
                 [NSString stringWithFormat:@" %@",_choiceB],
                 [NSString stringWithFormat:@" %@",_choiceC],
                 [NSString stringWithFormat:@" %@",_choiceD]];
    }else if ([_questionType isEqualToString:@"sc"]){
        return @[[NSString stringWithFormat:@" %@",_choiceA],
                 [NSString stringWithFormat:@" %@",_choiceB],
                 [NSString stringWithFormat:@" %@",_choiceC],
                 [NSString stringWithFormat:@" %@",_choiceD]];
    }else{
        return @[@" 正确",@" 错误"];
    }
}

- (NSArray *)getMCAnswer {
    NSArray *answers = [_answer componentsSeparatedByString:@","];
    NSMutableArray *aws = [NSMutableArray arrayWithCapacity:0];
    for (NSString *str in answers) {
        if ([str isEqualToString:@"choiceA"]) {
            [aws addObject:_choiceA];
        }
        if ([str isEqualToString:@"choiceAB"]) {
            [aws addObject:_choiceB];
        }
        if ([str isEqualToString:@"choiceC"]) {
            [aws addObject:_choiceC];
        }
        if ([str isEqualToString:@"choiceD"]) {
            [aws addObject:_choiceD];
        }
    }
    return aws;
}

- (NSInteger)getSMAnswerOrTFAnswer {
     if ([_answer isEqualToString:@"choiceA"]) {
        return 0;
    }else if ([_answer isEqualToString:@"choiceB"]) {
        return 1;
    }else if ([_answer isEqualToString:@"choiceC"]) {
        return 2;
    }else if ([_answer isEqualToString:@"choiceD"]) {
        return 3;
    }else if ([_answer isEqualToString:@"正确"]) {
        return 0;
    }else{
        return 1;
    }
}

- (NSString *)getQuestionTypeString {
    if ([_questionType isEqualToString:@"mc"]) {
        return @"【多选】";
    }else if ([_questionType isEqualToString:@"sc"]){
        return @"【单选】";
    }else{
        return @"【判断】";
    }
}

- (BOOL)mcChoiceType {
    if ([_questionType isEqualToString:@"mc"]) {
        return YES;
    }else {
        return NO;
    }
}

@end
