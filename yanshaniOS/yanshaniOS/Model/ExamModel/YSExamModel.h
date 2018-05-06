//
//  YSExamModel.h
//  yanshaniOS
//
//  Created by 代健 on 2018/4/15.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface YSExamModel : JSONModel

@property (nonatomic, assign) NSInteger examId;

@property (nonatomic, strong) NSString <Optional>*createTime;

@property (nonatomic, strong) NSString <Optional>*updateTime;

@property (nonatomic, strong) NSString <Optional>*endDate;

@property (nonatomic, strong) NSString <Optional>*examName;

@property (nonatomic, strong) NSString <Optional>*introduction;

@property (nonatomic, strong) NSString <Optional>*examType;

@property (nonatomic, assign) NSInteger examDuration;

@property (nonatomic, strong) NSString <Optional>*role;

@property (nonatomic, assign) NSInteger standard;

@property (nonatomic, strong) NSString <Optional>*startDate;

@property (nonatomic, strong) NSArray <Optional>*scList;

@property (nonatomic, strong) NSArray <Optional>*mcList;

@property (nonatomic, strong) NSArray <Optional>*bfList;

@property (nonatomic, strong) NSArray <Optional>*tfList;

@end
