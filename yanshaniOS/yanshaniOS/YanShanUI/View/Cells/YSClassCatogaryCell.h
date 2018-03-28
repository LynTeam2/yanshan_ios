//
//  YSClassCatogaryCell.h
//  yanshaniOS
//
//  Created by jianjiandai on 2018/3/28.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSClassCatogaryCell : UICollectionViewCell
{
    UIImageView *_coverImgView;
    UIImageView *_rightIndicator;
    UILabel *_titleLable;
    UILabel *_subTitleLabel;
    UIView *_seperateLine;
}

@property (nonatomic, strong) id data;


- (void)updateClassInformation:(id)model;

@end
