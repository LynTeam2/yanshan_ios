//
//  YSExaminationItemModel.h
//  yanshaniOS
//
//  Created by 代健 on 2017/12/30.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import <JSONModel/JSONModel.h>

typedef NS_ENUM(NSUInteger, YSExaminationItemType) {
    YSExaminationItemTypeRadio,
    YSExaminationItemTypeMultipleChoice,
    YSExaminationItemTypeJudgment
};

@interface YSExaminationItemModel : JSONModel

@property (nonatomic, strong) NSString <Optional>*itemContent;

@property (nonatomic, strong) NSString <Optional>*itemImageUrl;

@property (nonatomic, assign) YSExaminationItemType itemType;

@property (nonatomic, strong) NSArray <Optional>*itemChoices;

@property (nonatomic, strong) NSArray <Optional>*selectItems;

@property (nonatomic, strong) NSArray <Optional>*rightItems;


@end
