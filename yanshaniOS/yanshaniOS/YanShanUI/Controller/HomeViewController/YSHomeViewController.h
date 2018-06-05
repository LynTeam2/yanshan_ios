//
//  ViewController.h
//  yanshaniOS
//
//  Created by 代健 on 2017/9/24.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSBaseViewController.h"

typedef NS_ENUM(NSUInteger, NewsRequestStatue) {
    NewsRequestStatueLoading = 0,
    NewsRequestStatueDone,
    NewsRequestStatueFinished,
};

@interface YSHomeViewController : YSBaseViewController


@end

