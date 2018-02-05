//
//  YSCourseManager.h
//  yanshaniOS
//
//  Created by 代健 on 2018/2/5.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YSCourseItemModel.h"

@interface YSCourseManager : NSObject

+ (instancetype)sharedCourseManager;

- (void)saveCourseItem:(YSCourseItemModel *)model;

- (NSArray *)recentWrongCourseItem;

- (NSArray *)allWrongCourseItem;

- (void)mergeCourseItem;

@end
