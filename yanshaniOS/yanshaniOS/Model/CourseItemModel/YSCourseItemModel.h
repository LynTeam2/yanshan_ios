//
//  YSCourseItemModel.h
//  yanshaniOS
//
//  Created by 代健 on 2018/2/4.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface YSCourseItemModel : JSONModel

@property (nonatomic, strong) NSString <Optional>*ajType;
@property (nonatomic, strong) NSString <Optional>*analysis;
@property (nonatomic, strong) NSString <Optional>*answer;
@property (nonatomic, strong) NSString <Optional>*createTime;
@property (nonatomic, strong) NSString <Optional>*difficulty;
@property (nonatomic, strong) NSString <Optional>*itemId;
@property (nonatomic, strong) NSString <Optional>*question;
@property (nonatomic, strong) NSString <Optional>*questionType;
@property (nonatomic, strong) NSString <Optional>*updateTime;
@property (nonatomic, strong) NSString <Optional>*choiceA;
@property (nonatomic, strong) NSString <Optional>*choiceB;
@property (nonatomic, strong) NSString <Optional>*choiceC;
@property (nonatomic, strong) NSString <Optional>*choiceD;
@property (nonatomic, strong) NSString <Optional>*doROW;    //对或错
@property (nonatomic, assign) BOOL hasDone;//是否已经作答


- (NSArray *)getItemChoices;

- (NSArray *)getMCAnswer;

- (NSInteger)getSMAnswerOrTFAnswer;

- (NSString *)getQuestionTypeString;

- (BOOL)mcChoiceType;

- (CGFloat)getQuestionCellHeight;

- (CGFloat)getAllChoiceHeight;

- (CGFloat)getChoiceHeight:(NSString *)choice;

@end
