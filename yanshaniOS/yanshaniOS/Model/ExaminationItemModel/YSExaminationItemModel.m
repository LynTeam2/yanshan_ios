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
        _rightSMItemCount = 0;
        _rightMCItemCount = 0;
        _rightTFItemCount = 0;
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

- (NSArray *)getAllWrongSCItem {
    NSMutableArray *marr = [NSMutableArray arrayWithCapacity:0];
    for (YSCourseItemModel *m in [self getSCItem]) {
        if([m.doROW isEqual:@"n"]) {
            [marr addObject:m];
        }
    }
    return marr;
}

- (NSArray *)getAllWrongMCItem {
    NSMutableArray *marr = [NSMutableArray arrayWithCapacity:0];
    for (YSCourseItemModel *m in [self getMCItem]) {
        if([m.doROW isEqual:@"n"]) {
            [marr addObject:m];
        }
    }
    return marr;
}

- (NSArray *)getAllWrongTFItem {
    NSMutableArray *marr = [NSMutableArray arrayWithCapacity:0];
    for (YSCourseItemModel *m in [self getTFItem]) {
        if([m.doROW isEqual:@"n"]) {
            [marr addObject:m];
        }
    }
    return marr;
}

- (NSArray *)getAllUndoSCItem {
    NSMutableArray *marr = [NSMutableArray arrayWithCapacity:0];
    for (YSCourseItemModel *m in [self getSCItem]) {
        if(m.doROW.length == 0) {
            [marr addObject:m];
        }
    }
    return marr;
}

- (NSArray *)getAllUndoMCItem {
    NSMutableArray *marr = [NSMutableArray arrayWithCapacity:0];
    for (YSCourseItemModel *m in [self getMCItem]) {
        if(m.doROW.length == 0) {
            [marr addObject:m];
        }
    }
    return marr;
}

- (NSArray *)getAllUndoTFItem {
    NSMutableArray *marr = [NSMutableArray arrayWithCapacity:0];
    for (YSCourseItemModel *m in [self getTFItem]) {
        if(m.doROW.length == 0) {
            [marr addObject:m];
        }
    }
    return marr;
}

- (void)saveWrongItem:(YSCourseItemModel *)model {
    for (YSCourseItemModel *m in _items) {
        if ([model.question isEqual:m.question]) {
            m.doROW = @"n";
            model.doROW = @"n";
        }
    }
    [wrongItems addObject:model];
}

- (NSArray *)allWrongItems {
    return wrongItems;
}
- (void)saveRightItem:(YSCourseItemModel *)model {
    for (YSCourseItemModel *m in _items) {
        if ([model.question isEqual:m.question]) {
            m.doROW = @"y";
            model.doROW = @"y";
        }
    }
    if ([model.questionType isEqualToString:@"sc"]) {
        _rightSMItemCount ++;
    }else if ([model.questionType isEqualToString:@"mc"]) {
        _rightMCItemCount ++;
    }else if ([model.questionType isEqualToString:@"tf"]) {
        _rightTFItemCount ++;
    }
    [rightItems addObject:model];
}

- (NSInteger)undoItem {
    return _items.count - rightItems.count - wrongItems.count;
}

@end
