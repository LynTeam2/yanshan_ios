//
//  YSHomeReusableView.h
//  yanshaniOS
//
//  Created by 代健 on 2017/10/9.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSHomeReusableViewDelegate <NSObject>

@optional

- (void)clickMenuButton:(UIButton *)button;

- (void)clickBannerAtIndex:(NSInteger)index with:(id)model;

@end

@interface YSHomeReusableView : UICollectionReusableView

@property (nonatomic, weak) id<YSHomeReusableViewDelegate>delegate;

@end
