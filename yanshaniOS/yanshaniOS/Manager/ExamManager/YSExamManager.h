//
//  YSExamManager.h
//  yanshaniOS
//
//  Created by 代健 on 2018/2/8.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSExaminationItemModel.h"

@interface YSExamManager : NSObject

+ (instancetype)sharedExamManager;

- (void)saveCurrentExam:(YSExaminationItemModel *)model;

- (NSArray *)getAllExams;

- (NSInteger)getPassCount;

@end
