//
//  YSNewsViewCell.h
//  yanshaniOS
//
//  Created by 代健 on 2017/10/8.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSNewsViewCell : UICollectionViewCell
{
    UIImageView *_coverImgView;
    UIImageView *_rightIndicator;
    UILabel *_titleLable;
    UILabel *_subTitleLabel;
    UIView *_seperateLine;
}

- (void)updateClassInformation:(id)model;

@end
