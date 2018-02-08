//
//  YSExamManager.m
//  yanshaniOS
//
//  Created by 代健 on 2018/2/8.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSExamManager.h"

static YSExamManager *manager = nil;

static NSString *examplist = @"exam.plist";

@implementation YSExamManager
{
    NSInteger passCount;
}
+ (instancetype)sharedExamManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        if (![[YSFileManager sharedFileManager] documentPathIsExecutableFile:examplist]) {
            [[YSFileManager sharedFileManager] createFileName:examplist atFilePath:[[YSFileManager sharedFileManager] getDocumentDirectoryPath]];
        }
    });
    return manager;
}

- (void)saveCurrentExam:(YSExaminationItemModel *)model {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    if (model.examScore) {
        [dic setObject:@(model.examScore) forKey:@"score"];
    }
    if (model.examJudgement) {
        [dic setObject:model.examJudgement forKey:@"judgement"];
    }
    if (model.dateString) {
        [dic setObject:model.dateString forKey:@"date"];
    }
    if (model.rightItemCount) {
        [dic setObject:@(model.rightItemCount) forKey:@"rightcount"];
    }
    if (model.wrongItemCount) {
        [dic setObject:@(model.rightItemCount) forKey:@"wrongcount"];
    }
    if (model.items.count) {
        NSArray *arr = [YSCourseItemModel arrayOfDictionariesFromModels:model.items];
        [dic setObject:arr forKey:@"items"];
    }
    if (dic.count) {
        NSString *filePath = [[YSFileManager sharedFileManager] getUnzipFilePathWithFileName:examplist andDocumentName:nil];
        NSArray *olderExams = [NSArray arrayWithContentsOfFile:filePath];
        NSMutableArray *allExams = [NSMutableArray arrayWithObject:dic];
        [allExams addObjectsFromArray:olderExams];
        [allExams writeToFile:filePath atomically:YES];
    }
}

- (NSArray *)getAllExams {
    NSString *filePath = [[YSFileManager sharedFileManager] getUnzipFilePathWithFileName:examplist andDocumentName:nil];
    NSArray *olderExams = [NSArray arrayWithContentsOfFile:filePath];
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
    if (olderExams.count) {
        for (int i = 0; i < olderExams.count; i++) {
            NSDictionary *dic = olderExams[i];
            YSExaminationItemModel *model = [[YSExaminationItemModel alloc] init];
            if (dic[@"score"]) {
                model.examScore = [dic[@"score"] integerValue];
            }
            if (dic[@"judgement"]) {
                model.examJudgement = dic[@"judgement"];
                if ([model.examJudgement isEqualToString:@"成绩合格"]) {
                    passCount++;
                }
            }
            if (dic[@"date"]) {
                model.dateString = dic[@"date"];
            }
            if (dic[@"rightcount"]) {
                model.rightItemCount = [dic[@"count"] integerValue];
            }
            if (dic[@"wrongcount"]) {
                model.rightItemCount = [dic[@"wrongcount"] integerValue];
            }
            if (dic[@"items"]) {
                NSArray *arr = [YSCourseItemModel arrayOfModelsFromDictionaries:dic[@"items"] error:nil];
                model.items = [arr copy];
            }
            [mArr addObject:model];
        }
    }
    return mArr;
}

- (NSInteger)getPassCount {
    if (passCount) {
        return passCount;
    }
    return 0;
}
@end
