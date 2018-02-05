//
//  YSExaminationItemViewController.h
//  yanshaniOS
//
//  Created by 代健 on 2017/12/31.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSBaseViewController.h"
#import "YSCourseItemModel.h"

typedef NS_ENUM(NSUInteger, RightItemType) {
    RightItemTypeNone = 0,
    RightItemTypeNext,
    RightItemTypeFinished
};

@class YSExaminationItemViewController;

@protocol YSExaminationItemViewControllerDelegate <NSObject>

- (void)selectAnwser:(YSExaminationItemViewController *)examinationItemController;

@end

@interface YSExaminationItemViewController : YSBaseViewController

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger selectChoice;

@property (nonatomic, assign) BOOL realExam;
@property (nonatomic, assign) BOOL isRight;
@property (nonatomic, assign) RightItemType itemType;
@property (nonatomic, strong) YSCourseItemModel *itemModel;
@property (nonatomic) id<YSExaminationItemViewControllerDelegate> delegate;

@end

@protocol YSExaminationChoiceCellDelegate <NSObject>

- (void)selectChoice:(NSInteger)selectIndex isRight:(BOOL)right;

- (void)selectChoice:(NSArray *)selectIndexs;

@end

@interface YSExaminationChoiceCell : UITableViewCell

@property (nonatomic, assign) NSInteger rightIndex;
@property (nonatomic, strong) NSArray *rightChoices;
@property (nonatomic, assign) BOOL mcChoice;
@property (nonatomic, strong) NSMutableArray *selectChoices;

@property (nonatomic, assign) id<YSExaminationChoiceCellDelegate> delegate;

- (void)createChoiceButton:(NSArray *)choices;

@end

@interface YSExaminationItemReslutsCell : UITableViewCell

- (void)showMCConfirmButton:(BOOL)show;

- (void)updateAwsChoice:(NSString *)awsChoice;

- (void)updateAwsAnalysis:(NSString *)analysis;

- (void)showResults:(BOOL)awsbool;

- (void)addTarget:(id)target confirmChoice:(SEL)choiceSEL;

@end
