//
//  YSWrongListViewController.h
//  yanshaniOS
//
//  Created by 代健 on 2018/9/27.
//  Copyright © 2018 jiandai. All rights reserved.
//

#import "YSBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class YSCourseItemModel;

typedef void(^doRight)(YSCourseItemModel *model);

@interface YSWrongListViewController : YSBaseViewController

@property(nonatomic, copy)doRight doRightBlock;

@property(nonatomic, assign) NSInteger selectIndex;

- (void)setCoursesData:(NSArray *)datas;

@end

NS_ASSUME_NONNULL_END
