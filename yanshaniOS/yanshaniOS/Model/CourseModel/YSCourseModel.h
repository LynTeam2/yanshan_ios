//
//  YSCourseModel.h
//  yanshaniOS
//
//  Created by 代健 on 2018/2/4.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "YSCourseItemModel.h"

typedef NS_ENUM(NSInteger, CourseContentType) {
    CourseContentTypeArtical = 1,
    CourseContentTypeVideo,
    CourseContentTypeZhuanXiang,
};

@interface YSCourseModel : JSONModel

@property (nonatomic, strong) NSString <Optional>*ajType;
@property (nonatomic, strong) NSArray <Optional>*bfList;
@property (nonatomic, strong) NSString <Optional>*content;
@property (nonatomic, strong) NSString <Optional>*courseName;
@property (nonatomic, assign) NSInteger courseType;
@property (nonatomic, strong) NSString <Optional>*createTime;
@property (nonatomic, strong) NSString <Optional>*homePage;
@property (nonatomic, strong) NSString <Optional>*icon;
@property (nonatomic, strong) NSString <Optional>*iconName;
@property (nonatomic, strong) NSString <Optional>*courseId;
@property (nonatomic, strong) NSArray <YSCourseItemModel *><Optional>*mcList;
@property (nonatomic, strong) NSArray <YSCourseItemModel *><Optional>*scList;
@property (nonatomic, strong) NSArray <YSCourseItemModel *><Optional>*tfList;
@property (nonatomic, strong) NSString <Optional>*updateTime;
@property (nonatomic, strong) NSString <Optional>*video;
@property (nonatomic, strong) NSString <Optional>*courseContent;


@end
