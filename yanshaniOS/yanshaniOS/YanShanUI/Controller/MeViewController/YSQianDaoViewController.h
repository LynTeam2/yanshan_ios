//
//  YSQianDaoViewController.h
//  yanshaniOS
//
//  Created by 代健 on 2017/11/19.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSBaseViewController.h"

typedef void(^QianDaoBlock)(BOOL success);

@interface YSQianDaoViewController : YSBaseViewController

@property (nonatomic, copy) QianDaoBlock QDBlock;


@end
