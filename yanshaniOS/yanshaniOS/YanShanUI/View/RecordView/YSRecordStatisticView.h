//
//  YSRecordStatisticView.h
//  yanshaniOS
//
//  Created by 代健 on 2017/12/30.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSBaseView.h"
#import "YSExaminationItemModel.h"

typedef NS_ENUM(NSUInteger, YSRecordStatisticViewType) {
    YSRecordStatisticViewTypeSimple = 0,
    YSRecordStatisticViewTypeMultable,
    YSRecordStatisticViewTypeTOF,
};

@interface YSRecordStatisticView : YSBaseView


- (void)proccessViewColor:(UIColor *)color;

- (void)updateContentUseStatisticData:(YSExaminationItemModel *)model withViewType:(YSRecordStatisticViewType)type;


@end


@interface YSRecordStatisticButton : YSBaseView

- (instancetype)initWithButtonType:(UIButtonType)type;

- (void)updateButtonContentWithData:(NSDictionary *)dic;

- (void)addTarget:(id)target andSel:(SEL)sel;

@end
