//
//  YSShopViewController.h
//  yanshaniOS
//
//  Created by 代健 on 2017/10/4.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSBaseViewController.h"

@interface YSShopViewController : YSBaseViewController

@end

@interface YSGoodsInfromationCell : UICollectionViewCell
{
    UIImageView *goodCover;
    UILabel *goodsNameLabel;
    UILabel *goodsPriceLabel;
    UILabel *goodsMarketPriceLabel;
    UIView *line;
}

- (void)updateGoodsContent:(id)model;

@end
