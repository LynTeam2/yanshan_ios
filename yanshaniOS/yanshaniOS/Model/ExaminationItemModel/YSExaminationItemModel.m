//
//  YSExaminationItemModel.m
//  yanshaniOS
//
//  Created by 代健 on 2017/12/30.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSExaminationItemModel.h"

@implementation YSExaminationItemModel
{
    NSMutableArray *wrongItems;
    NSMutableArray *rightItems;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        wrongItems = [NSMutableArray arrayWithCapacity:0];
        rightItems = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}
- (NSArray *)getSCItem {
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < _items.count; i++) {
        YSCourseItemModel *model = _items[i];
        if ([model.questionType isEqualToString:@"sc"]) {
            [mArr addObject:model];
        }
    }
    return mArr;
}

- (NSArray *)getMCItem {
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < _items.count; i++) {
        YSCourseItemModel *model = _items[i];
        if ([model.questionType isEqualToString:@"mc"]) {
            [mArr addObject:model];
        }
    }
    return mArr;
}

- (NSArray *)getTFItem {
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < _items.count; i++) {
        YSCourseItemModel *model = _items[i];
        if ([model.questionType isEqualToString:@"tf"]) {
            [mArr addObject:model];
        }
    }
    return mArr;
}

- (void)saveWrongItem:(YSCourseItemModel *)model {
    [wrongItems addObject:model];
}

- (void)saveRightItem:(YSCourseItemModel *)model {
    [rightItems addObject:model];
}

- (NSArray<YSCourseItemModel *> *)items {
    return wrongItems;
}

@end
