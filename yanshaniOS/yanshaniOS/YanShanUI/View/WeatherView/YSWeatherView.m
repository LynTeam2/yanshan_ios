//
//  YSWeatherView.m
//  yanshaniOS
//
//  Created by 代健 on 2018/11/9.
//  Copyright © 2018 jiandai. All rights reserved.
//

#import "YSWeatherView.h"

@implementation YSWeatherView
{
    UILabel *titleLabel;
    UILabel *infoLabel;
    UILabel *dateLabel;
    UILabel *FLabel;
    UIImageView *imageV;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    if (titleLabel) {
        return;
    }
    titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"--";
    titleLabel.font = [UIFont systemFontOfSize:20.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:titleLabel];

    //    @"9月03日  周日 农历七月十三"
    infoLabel = [[UILabel alloc] init];
    infoLabel.numberOfLines = 2;
    infoLabel.text = @"空气质量:--";
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:infoLabel];
    
    FLabel = [[UILabel alloc] init];
    FLabel.text = @"--°";
    FLabel.textAlignment = NSTextAlignmentCenter;
    FLabel.textColor = [UIColor whiteColor];
    FLabel.font = [UIFont systemFontOfSize:90.f];
    [self addSubview:FLabel];
    
    dateLabel = [[UILabel alloc] init];
    dateLabel.text = @"--";
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.textColor = [UIColor whiteColor];
    [self addSubview:dateLabel];
    
    imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weatherbgnew"]];
    [self addSubview:imageV];
}

- (void)layoutSubviews {
    
    CGRect bounds = self.bounds;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(10);
        make.width.mas_equalTo(bounds.size.width-40);
        make.height.mas_equalTo(30);
    }];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(64);
        make.width.mas_equalTo(bounds.size.width-40);
        make.height.mas_equalTo(40);
    }];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_centerY).offset(70);
        make.width.mas_equalTo(bounds.size.width-40);
        make.height.mas_lessThanOrEqualTo(220);
        make.bottom.equalTo(self).offset(-20).with.priority(751);
    }];
    [FLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(infoLabel.mas_bottom).offset(20);
        make.width.mas_equalTo(bounds.size.width-40);
        make.height.mas_equalTo(70);
    }];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(FLabel.mas_bottom).offset(20);
        make.width.mas_equalTo(bounds.size.width-40);
        make.height.mas_equalTo(20);
    }];
}

#pragma mark - api

- (void)updateWeatherViewWith:(NSString *)city weatherData:(id)data {
    
    NSDictionary *resultDic = [data copy];
    
    NSArray *weatherArr = [resultDic objectForKey:@"daily_forecast"];
    NSDictionary *lifestyleDic = [[resultDic objectForKey:@"lifestyle"] firstObject];
    NSDictionary *nowDic = [resultDic objectForKey:@"now"];
    
    titleLabel.text = city;
    
    FLabel.text = [NSString stringWithFormat:@"%@°",[nowDic objectForKey:@"tmp"]];
    infoLabel.text = lifestyleDic[@"txt"];
    
    [imageV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[YSWeatherTimeView class]]) {
            [view removeFromSuperview];
        }
    }
    
    CGRect bounds = self.bounds;
    NSArray *hourWeatherArr = resultDic[@"hourly"];
    CGFloat timeViewWidth = (bounds.size.width-40)/5;
    for (int i = 0; i < (hourWeatherArr.count < 5 ? hourWeatherArr.count:5); i++) {
        NSDictionary *dic = hourWeatherArr[i];
        NSString *time = [YSCommonHelper timeFromNowWithTimeInterval:i*30*60 dateFormat:@"hh:mm"];
        UIImage *icon = [YSCommonHelper weatherIcon:dic[@"cond_txt"] state:UIControlStateNormal];
        NSString *tmp = [NSString stringWithFormat:@"%@°",dic[@"tmp"]];
        NSDictionary *dataDic = @{@"time":time,@"image":icon,@"c":tmp};
        YSWeatherTimeView *timeView = [[YSWeatherTimeView alloc] init];
        [timeView updateTimeWeatherData:dataDic];
        [self addSubview:timeView];
        [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20+timeViewWidth*i);
            make.top.equalTo(dateLabel.mas_bottom).offset(20);
            make.width.mas_equalTo(timeViewWidth);
            make.height.mas_equalTo(100);
        }];
    }
    
    for (int i = 0; i < (weatherArr.count > 5 ? 5:weatherArr.count); i++) {
        NSDictionary *dic = weatherArr[i];
        if (i == 0) {
            dateLabel.text = [YSCommonHelper getWeekDayFromDateString:dic[@"date"]];
        }
        YSWeatherInformationItem *item = [[YSWeatherInformationItem alloc] init];
        [item updateInformation:dic];
        [imageV addSubview:item];
        CGFloat topSpace = [YSCommonHelper iPhone5Device] ? 15 : 20;
        CGFloat height = [YSCommonHelper iPhone5Device] ? 25 : 35;
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageV).offset(topSpace+height*i);
            make.left.equalTo(imageV);
            make.width.equalTo(imageV);
            make.height.mas_equalTo(height);
        }];
    }
}

@end

@implementation YSWeatherInformationItem

{
    UIImageView *dotImg;
    UILabel *dateLabel;
    UILabel *weatherLabel;
    UILabel *FLabel;
    UIImageView *weatherImg;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        dotImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"orangedot"]];
        [self addSubview:dotImg];
        
        dateLabel = [[UILabel alloc] init];
        dateLabel.text = @"--";
        dateLabel.font = [UIFont systemFontOfSize:16.f];
        [self addSubview:dateLabel];
        
        weatherLabel = [[UILabel alloc] init];
        weatherLabel.font = [UIFont systemFontOfSize:13.f];
        weatherLabel.textAlignment = NSTextAlignmentRight;
        weatherLabel.textColor = [UIColor grayColor];
        [self addSubview:weatherLabel];
        
        FLabel = [[UILabel alloc] init];
        FLabel.text = @"--°";
        FLabel.font = [UIFont systemFontOfSize:13.f];
        FLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:FLabel];
        
        weatherImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sunandcloud"]];
        [self addSubview:weatherImg];
    }
    return self;
}

- (void)layoutSubviews {
    [dotImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(5, 5));
    }];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dotImg.mas_right).offset(10);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(90, 20));
    }];
    [weatherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_centerX).offset(-20);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 10));
    }];
    [FLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weatherImg.mas_left).offset(-30);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    [weatherImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)updateInformation:(NSDictionary *)dic {
    NSString *date = [dic objectForKey:@"date"];//星期
    NSString *weekDay = [YSCommonHelper getWeekDayFromDateString:date];
    dateLabel.text = weekDay;
    weatherLabel.text = [dic objectForKey:@"cond_txt_d"];//天气
    NSString *lowstr = [dic objectForKey:@"tmp_min"];//最低气温
    NSString *highstr = [dic objectForKey:@"tmp_max"];//最高气温
    if (lowstr) {
        lowstr = [lowstr stringByReplacingOccurrencesOfString:@"低温" withString:@""];
        lowstr = [lowstr stringByReplacingOccurrencesOfString:@".0℃" withString:@""];
    }
    if (highstr) {
        highstr = [highstr stringByReplacingOccurrencesOfString:@"高温" withString:@""];
        highstr = [highstr stringByReplacingOccurrencesOfString:@".0℃" withString:@""];
    }
    FLabel.text = [NSString stringWithFormat:@"%@°~%@°",lowstr,highstr];
    weatherImg.image = [YSCommonHelper weatherIcon:dic[@"cond_txt_d"] state:UIControlStateSelected];
}

@end


@implementation YSWeatherTimeView

{
    UILabel *timeLabel;
    UIImageView *weatherIcon;
    UILabel *Flabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    timeLabel = [[UILabel alloc] init];
    timeLabel.text = [YSCommonHelper timeFromNowWithTimeInterval:30*60 dateFormat:@"hh:mm"];//@"现在"
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.font = [UIFont systemFontOfSize:14.f];
    timeLabel.textColor = [UIColor whiteColor];
    [self addSubview:timeLabel];
    
    weatherIcon = [[UIImageView alloc] init];
    weatherIcon.image = [YSCommonHelper weatherIcon:@"多云" state:UIControlStateSelected];
    [self addSubview:weatherIcon];
    
    Flabel = [[UILabel alloc] init];
    Flabel.text = @"29°";
    Flabel.textAlignment = NSTextAlignmentCenter;
    Flabel.font = [UIFont systemFontOfSize:10.f];
    Flabel.textColor = [UIColor whiteColor];
    [self addSubview:Flabel];
    
}

- (void)layoutSubviews {
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(20);
    }];
    [weatherIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [Flabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(20);
    }];
}

- (void)updateTimeWeatherData:(NSDictionary *)data {
    timeLabel.text = data[@"time"];
    weatherIcon.image = data[@"image"];
    Flabel.text = data[@"c"];
}

@end

