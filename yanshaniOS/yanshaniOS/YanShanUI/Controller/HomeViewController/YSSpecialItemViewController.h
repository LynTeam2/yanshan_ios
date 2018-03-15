//
//  YSSpecialItemViewController.h
//  yanshaniOS
//
//  Created by 代健 on 2018/1/30.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSBaseViewController.h"

@interface YSSpecialItemViewController : YSBaseViewController

@property (nonatomic, strong) NSArray *leixingoneArray;
@property (nonatomic, strong) NSArray *leixingtwoArray;
@property (nonatomic, strong) NSArray *leixingthreeArray;

@property (nonatomic, strong) NSMutableArray *allArray;


@end

@interface YSSpecialItemCell : UICollectionViewCell

@property (nonatomic, assign) BOOL isSelect;

- (void)updateIndex:(NSString *)index andTitle:(NSString *)title;

@end
