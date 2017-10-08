//
//  YSClassViewCell.h
//  yanshaniOS
//
//  Created by 代健 on 2017/10/8.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSClassViewCell : UICollectionViewCell

{
    UIImageView *_coverImgView;
    UILabel *_inforLabel;
}

- (void)updateClassCellWith:(id)model;

@end
