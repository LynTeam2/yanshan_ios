//
//  YSExamManager.m
//  yanshaniOS
//
//  Created by 代健 on 2018/2/8.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSExamManager.h"
#import "YSExamModel.h"
#import "YSCourseItemModel.h"

static YSExamManager *manager = nil;

static NSString *examplist = @"exam.plist";

@implementation YSExamManager
{
    NSInteger passCount;
    NSInteger maxValue;
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
    if (model.examScore >= 0) {
        [dic setObject:@(model.examScore) forKey:@"score"];
    }
    if (model.examJudgement) {
        [dic setObject:model.examJudgement forKey:@"judgement"];
    }
    if (model.dateString) {
        [dic setObject:model.dateString forKey:@"date"];
    }
    if (model.rightItemCount >= 0) {
        [dic setObject:@(model.rightItemCount) forKey:@"rightcount"];
    }
    if (model.wrongItemCount >= 0) {
        [dic setObject:@(model.wrongItemCount) forKey:@"wrongcount"];
    }
    if (model.items.count) {
        NSArray *arr = [YSCourseItemModel arrayOfDictionariesFromModels:model.items];
        [dic setObject:arr forKey:@"items"];
    }
    if (model.examName) {
        [dic setObject:model.examName forKey:@"examName"];
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
    passCount = 0;
    NSString *filePath = [[YSFileManager sharedFileManager] getUnzipFilePathWithFileName:examplist andDocumentName:nil];
    NSArray *olderExams = [NSArray arrayWithContentsOfFile:filePath];
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
    if (olderExams.count) {
        for (int i = 0; i < olderExams.count; i++) {
            NSDictionary *dic = olderExams[i];
            YSExaminationItemModel *model = [[YSExaminationItemModel alloc] init];
            if (dic[@"score"]) {
                model.examScore = [dic[@"score"] integerValue];
                maxValue = maxValue > model.examScore ? maxValue : model.examScore;
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
                model.wrongItemCount = [dic[@"wrongcount"] integerValue];
            }
            if (dic[@"items"]) {
                NSArray *arr = [YSCourseItemModel arrayOfModelsFromDictionaries:dic[@"items"] error:nil];
                model.items = [arr copy];
            }
            if (dic[@"examName"]) {
                model.examName = dic[@"examName"];
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
- (NSInteger)getMaxScroce {
    if (maxValue) {
        return maxValue;
    }
    return 0;
}

- (BOOL)syncrosizeUserExamHistory:(NSArray *)datas {
    BOOL success = [[YSFileManager sharedFileManager] documentPathIsExecutableFile:@"upgrade"];
    if (success) {
        // exam.json no exist
        NSDictionary *jsonDic = [[YSFileManager sharedFileManager] JSONSerializationJsonFile:@"exam.json" atDocumentName:@"exam"];
        if (![jsonDic objectForKey:@"exams"]) {
            return NO;
        }
        //清空历史数据
        NSString *filePath = [[YSFileManager sharedFileManager] getUnzipFilePathWithFileName:examplist andDocumentName:nil];
        [@[] writeToFile:filePath atomically:YES];

        NSArray *exams = [YSExamModel arrayOfModelsFromDictionaries:jsonDic[@"exams"] error:nil];

        NSMutableArray *examedArray = [NSMutableArray array];
        NSMutableDictionary *examedDic = [NSMutableDictionary  dictionary];
        //获取已做考试试题
        for (int i = 0; i < datas.count; i++) {
            NSDictionary *tmpDic = datas[i];
            for (int j = 0; j < exams.count; j++) {
                YSExamModel *model = exams[j];
                if ([tmpDic[@"examId"] integerValue] == model.examId) {
                    [examedArray addObject:model];
                    [examedDic setObject:model forKey:[NSString stringWithFormat:@"%ld",model.examId]];
                    break;
                }
            }
        }
        //分析已考考试试题
        for (NSDictionary *dic in datas) {
            //创建考试结果model
            YSExaminationItemModel *examinationItemModel = [[YSExaminationItemModel alloc] init];
            NSString *examID = [NSString stringWithFormat:@"%ld",[dic[@"examId"] integerValue]];
            //获取相关试题
            if (examedDic[examID]) {
                YSExamModel *model = examedDic[examID];
                examinationItemModel.examID = model.examId;
                examinationItemModel.examName = model.examName;
                examinationItemModel.examScore = [dic[@"examScore"] integerValue];
                examinationItemModel.dateString = dic[@"createTime"];
                if (examinationItemModel.examScore < model.standard) {
                    examinationItemModel.examJudgement = @"成绩不合格";
                }else{
                    examinationItemModel.examJudgement = @"成绩合格";
                }
                NSMutableArray *items = [NSMutableArray array];
                NSArray *examDetailList = dic[@"examDetailList"];
                for (NSDictionary *item in examDetailList) {
                    NSArray *arr;
                    if ([item[@"questionType"] isEqualToString:@"sc"]) {
                        arr = [YSCourseItemModel arrayOfModelsFromDictionaries: model.scList error:nil];;
                    }
                    if ([item[@"questionType"] isEqualToString:@"mc"]) {
                        arr = [YSCourseItemModel arrayOfModelsFromDictionaries: model.mcList error:nil];;
                    }
                    if ([item[@"questionType"] isEqualToString:@"tf"]) {
                        arr = [YSCourseItemModel arrayOfModelsFromDictionaries: model.tfList error:nil];;
                    }
                    for (YSCourseItemModel *courseItemModel in arr) {
                        if ([item[@"questionId"] integerValue] == [courseItemModel.itemId integerValue]) {
                            if ([item[@"result"] integerValue] == 0) {
                                courseItemModel.doROW = @"n";
                                [examinationItemModel saveWrongItem:courseItemModel];
                            }
                            if ([item[@"result"] integerValue] == 1) {
                                courseItemModel.doROW = @"y";
                                [examinationItemModel saveRightItem:courseItemModel];
                            }
                            [items addObject:courseItemModel];
                        }
                    }
                    examinationItemModel.items = [items copy];
                    examinationItemModel.wrongItemCount = [examinationItemModel allWrongItems].count;
                }
                [self saveCurrentExam:examinationItemModel];
            }
        }
        
        
        
        
    }
    return success;
}

@end
