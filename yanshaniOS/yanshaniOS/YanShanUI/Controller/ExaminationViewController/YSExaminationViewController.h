//
//  YSExaminationViewController.h
//  yanshaniOS
//
//  Created by 代健 on 2017/12/30.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSBaseViewController.h"
#import "YSBaseView.h"

@interface YSExaminationViewController : YSBaseViewController

@end

@interface YSExaminationToolView : YSBaseView <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UIButton *icon1Btn;
    UIButton *icon2Btn;
    UIButton *icon3Btn;
    UIButton *icon4Btn;
    UIButton *title1Btn;
    UIButton *wrongItemBtn;
    UIButton *rightItemBtn;
    UIButton *currentItemBtn;
}

- (void)updateWrongChoiceCount:(NSInteger)count;

- (void)updateRightChoiceCount:(NSInteger)count;

- (void)updateCurrentItemIndex:(NSInteger)index;

- (void)updateitemCountWith:(NSInteger)count isRight:(BOOL)right;

- (void)addtarget:(id)target method:(SEL)action;

- (void)currentItemIndex:(NSInteger)index;

@end
