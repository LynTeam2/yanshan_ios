//
//  YSExamToolView.h
//  yanshaniOS
//
//  Created by 代健 on 2018/4/4.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSBaseView.h"

#define kJiaoJuanTag     2000
#define kTiMuTag         2001

typedef NS_ENUM(NSUInteger, ExamToolViewType) {
    ExamToolViewTypeExam = 0,
    ExamToolViewTypeWrongItem,
};


@interface YSExamToolView : YSBaseView <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UIButton *icon1Btn;
    UIButton *icon2Btn;
    UIButton *icon3Btn;
    UIButton *icon4Btn;
    UIButton *commitBtn;
    UIButton *wrongItemBtn;
    UIButton *rightItemBtn;
    UIButton *currentItemBtn;
}

@property (nonatomic, assign) NSInteger itemsCount;

- (instancetype)initWithFrame:(CGRect)frame withType:(ExamToolViewType)viewType;

- (void)updateWrongChoiceCount:(NSInteger)count;

- (void)updateRightChoiceCount:(NSInteger)count;

- (void)updateCurrentItemIndex:(NSString *)index;

- (void)updateitemCountWith:(NSInteger)count isRight:(BOOL)right;

- (void)addtarget:(id)target method:(SEL)action;

- (void)currentItemIndex:(NSInteger)index;

@end
