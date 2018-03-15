//
//  YSCourseCategoryModel.h
//  yanshaniOS
//
//  Created by 代健 on 2018/2/4.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface YSCourseCategoryModel : JSONModel

@property (nonatomic, strong) NSString <Optional>*categoryName;
@property (nonatomic, strong) NSString <Optional>*createTime;
@property (nonatomic, strong) NSString <Optional>*icon;
@property (nonatomic, strong) NSString <Optional>*iconName;
@property (nonatomic, strong) NSString <Optional>*categoryId;
@property (nonatomic, strong) NSString <Optional>*introduction;
@property (nonatomic, strong) NSString <Optional>*jsonName;
@property (nonatomic, strong) NSString <Optional>*parentId;
@property (nonatomic, strong) NSArray <Optional>*subCategories;

@end
