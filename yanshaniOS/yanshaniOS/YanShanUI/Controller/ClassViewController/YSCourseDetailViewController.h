//
//  YSClassViewController.h
//  yanshaniOS
//
//  Created by 代健 on 2017/12/31.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSBaseViewController.h"
#import "YSCourseModel.h"

@interface YSCourseDetailViewController : YSBaseViewController

@property (nonatomic, strong) YSCourseModel *model;

- (void)setCoursesData:(NSArray *)datas;

@end
