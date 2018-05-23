//
//  YSExaminationItemModel.h
//  yanshaniOS
//
//  Created by 代健 on 2017/12/30.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "YSCourseItemModel.h"

typedef NS_ENUM(NSUInteger, YSExaminationItemType) {
    YSExaminationItemTypeRadio,
    YSExaminationItemTypeMultipleChoice,
    YSExaminationItemTypeJudgment
};

@interface YSExaminationItemModel : NSObject

@property (nonatomic, assign) NSInteger examScore;

@property (nonatomic, strong) NSString *examJudgement;

@property (nonatomic, strong) NSArray <YSCourseItemModel *>*items;

@property (nonatomic, strong) NSString *dateString;

@property (nonatomic, assign) NSInteger rightItemCount;

@property (nonatomic, assign) NSInteger wrongItemCount;

@property (nonatomic, assign) NSInteger rightSMItemCount;

@property (nonatomic, assign) NSInteger rightMCItemCount;

@property (nonatomic, assign) NSInteger rightTFItemCount;


- (NSInteger)undoItem;

- (NSArray *)getSCItem;

- (NSArray *)getMCItem;

- (NSArray *)getTFItem;

- (NSArray *)getAllWrongSCItem;

- (NSArray *)getAllWrongMCItem;

- (NSArray *)getAllWrongTFItem;

- (NSArray *)getAllUndoSCItem;

- (NSArray *)getAllUndoMCItem;

- (NSArray *)getAllUndoTFItem;


- (void)saveWrongItem:(YSCourseItemModel *)model;

- (void)saveRightItem:(YSCourseItemModel *)model;

- (NSArray *)allWrongItems;

@end
