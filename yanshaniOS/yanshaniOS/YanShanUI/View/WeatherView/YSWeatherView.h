//
//  YSWeatherView.h
//  yanshaniOS
//
//  Created by 代健 on 2018/11/9.
//  Copyright © 2018 jiandai. All rights reserved.
//

#import "YSBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSWeatherView : YSBaseView


- (void)updateWeatherViewWith:(NSString *)city weatherData:(id)data;


@end

@interface YSWeatherInformationItem : YSBaseView

- (void)updateInformation:(NSDictionary *)dic;

@end


@interface YSWeatherTimeView : YSBaseView

- (void)updateTimeWeatherData:(NSDictionary *)data;

@end


NS_ASSUME_NONNULL_END
