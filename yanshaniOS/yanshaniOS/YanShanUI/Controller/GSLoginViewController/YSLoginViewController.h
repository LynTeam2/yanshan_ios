//
//  YSLoginViewController.h
//  yanshaniOS
//
//  Created by 代健 on 2017/11/19.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSBaseViewController.h"

typedef void(^userLoginSuccessBlock)(BOOL success);

@interface YSLoginViewController : YSBaseViewController

@property (nonatomic, weak) userLoginSuccessBlock userLoginResultBlock;


@end
