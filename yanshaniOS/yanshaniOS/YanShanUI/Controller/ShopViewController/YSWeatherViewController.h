//
//  YSShopViewController.h
//  yanshaniOS
//
//  Created by 代健 on 2017/10/4.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSBaseViewController.h"
#import "YSBaseView.h"

@interface YSWeatherViewController : YSBaseViewController

@end

@interface YSWeatherInformationItem : YSBaseView

- (void)updateInformation:(NSDictionary *)dic;

@end

@interface YSWeatherTimeView : YSBaseView

- (void)updateTimeWeatherData:(NSDictionary *)data;

@end

