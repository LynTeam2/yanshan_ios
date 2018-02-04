//
//  YSClassViewController.h
//  yanshaniOS
//
//  Created by 代健 on 2017/10/10.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSBaseViewController.h"

@interface YSClassViewController : YSBaseViewController

@end

@interface YSClassCollectionReusableView : UICollectionReusableView

@property (nonatomic, assign) NSInteger section;

- (void)setReusableViewTiltle:(NSString *)title;

- (void)reusableAddTarget:(id)target withAction:(SEL)action;

@end

@interface YSClassMenuCell : UICollectionViewCell

- (void)updateCellImage:(NSString *)imageName andTitle:(NSString *)title;

@end

@interface YSWrongItemCell : UICollectionViewCell

@property (nonatomic, strong) NSString *reusableTitle;


- (void)updateContent:(NSString *)content;

@end

