//
//  YSExaminationResultView.h
//  yanshaniOS
//
//  Created by 代健 on 2017/12/31.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSBaseView.h"

@interface YSExaminationResultView : YSBaseView

- (void)updateScoreValue:(NSString *)score costTime:(NSString *)costTime;

- (void)userPassTheExam:(BOOL)pass;

- (void)addTarget:(id)target andSEL:(SEL)action;

@end
