//
//  YSCourseItemModel.m
//  yanshaniOS
//
//  Created by 代健 on 2018/2/4.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSCourseItemModel.h"

@implementation YSCourseItemModel
{
    CGFloat questionHeight;
    CGFloat choiceAHeight;
    CGFloat choiceBHeight;
    CGFloat choiceCHeight;
    CGFloat choiceDHeight;
}
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
        if ([str isEqualToString:@"choiceB"]) {
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

- (CGFloat)getQuestionCellHeight {
    if (questionHeight == 0) {
        return [self heightForContent:_question];
    }
    return questionHeight;
}

- (CGFloat)getAllChoiceHeight {
    CGFloat height = [self heightForChoice:_choiceA] + [self heightForChoice:_choiceB] + [self heightForChoice:_choiceC] + [self heightForChoice:_choiceD];
    return height == 0 ? 44*2 : height;
}

- (CGFloat)getChoiceCellHeight:(NSString *)choice {
    choice = [choice stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([choice isEqualToString:_choiceA]) {
        if (choiceAHeight == 0) {
            return [self heightForChoice:_choiceA];
        }
        return choiceAHeight;
    }else if ([choice isEqualToString:_choiceB]) {
        if (choiceBHeight == 0) {
            return [self heightForChoice:_choiceB];
        }
        return choiceBHeight;
    }else if ([choice isEqualToString:_choiceC]) {
        if (choiceCHeight == 0) {
            return [self heightForChoice:_choiceC];
        }
        return choiceCHeight;
    }else if([choice isEqualToString:@"正确"]) {
        if (choiceAHeight == 0) {
            return [self heightForChoice:@"正确"];
        }
        return choiceAHeight;
    }else if ([choice isEqualToString:@"错误"]){
        if (choiceBHeight == 0) {
            return [self heightForChoice:@"错误"];
        }
        return choiceBHeight;
    }else{
        if (choiceDHeight == 0) {
            return [self heightForChoice:_choiceD];
        }
        return choiceDHeight;
    }
}

- (CGFloat)heightForContent:(NSString *)content {
    if (content == nil) {
        return 0;
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat heigt = [content boundingRectWithSize:CGSizeMake(width-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.f]} context:nil].size.height;
    return (heigt < 200 ? 200 : heigt);
}

- (CGFloat)heightForChoice:(NSString *)choice {
    if (choice == nil) {
        return 0;
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat heigt = [choice boundingRectWithSize:CGSizeMake(width-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.f]} context:nil].size.height;
    return (heigt < 44 ? 44 : heigt);
}

@end
