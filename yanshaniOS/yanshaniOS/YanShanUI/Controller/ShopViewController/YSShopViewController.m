//
//  YSShopViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2017/10/4.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSShopViewController.h"
#import "yanshaniOS-Swift.h"
#import "YSGoodsDetailViewController.h"

@interface YSShopViewController ()
{
    NSMutableArray *weathers;
    UILabel *titleLabel;
    UILabel *infoLabel;
    UILabel *FLabel;
    UIImageView *imageV;
}
@end

@implementation YSShopViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    weathers = [NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor = kBlueColor;
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    [[YSNetWorkEngine sharedInstance] getWeatherDataWithparameters:nil responseHandler:^(NSError *error, id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSInteger status = [[data objectForKey:@"status"] integerValue];
            if (200 == status) {
                NSString *date = [data objectForKey:@"date"];
                NSDictionary *dic = [data objectForKey:@"data"];
                infoLabel.text = [NSString stringWithFormat:@"%@ %@",date,[self getChineseCalendarWithDate:date]];
                FLabel.text = [NSString stringWithFormat:@"%@°",[dic objectForKey:@"wendu"]];
                if ([dic objectForKey:@"forecast"]) {
                    NSArray *arr = [dic objectForKey:@"forecast"];
                    [weathers addObjectsFromArray:arr];
                    CGFloat topSpace = 70;
                    CGFloat height = 35;
                    for (int i = 0; i < arr.count; i++) {
                        YSWeatherInformationItem *item = [[YSWeatherInformationItem alloc] init];
                        [item updateInformation:arr[i]];
                        [imageV addSubview:item];
                        [item mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(imageV).offset(topSpace+height*i);
                            make.left.equalTo(imageV);
                            make.width.equalTo(imageV);
                            make.height.mas_equalTo(height);
                        }];
                    }
                }
            }
        }
    }];
}

//日期阳历转换为农历；
- (NSString *)getChineseCalendarWithDate:(NSString*)date{
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月",
                            @"四月", @"五月", @"六月",
                            @"七月", @"八月",@"九月",
                            @"十月", @"冬月", @"腊月", nil];
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三",
                          @"初四", @"初五", @"初六",
                          @"初七", @"初八", @"初九",
                          @"初十",@"十一", @"十二",
                          @"十三", @"十四", @"十五",
                          @"十六", @"十七", @"十八",
                          @"十九", @"二十",@"廿一",
                          @"廿二", @"廿三", @"廿四",
                          @"廿五", @"廿六", @"廿七",
                          @"廿八", @"廿九", @"三十",
                          @"三十-",
                          nil];
    
    NSDate *dateTemp = nil;
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"yyyyMMdd"];
    dateTemp = [dateFormater dateFromString:date];
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:dateTemp];
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    NSString *chineseCal_str = [NSString stringWithFormat:@"农历%@%@",m_str,d_str];
    return chineseCal_str;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configView {
    
    CGRect bounds = self.view.bounds;
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"北京";
    titleLabel.font = [UIFont systemFontOfSize:20.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
//    @"9月03日  周日 农历七月十三"
    infoLabel = [[UILabel alloc] init];
    infoLabel.text = @"--月--日 农历----";
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:infoLabel];
    
    FLabel = [[UILabel alloc] init];
    FLabel.text = @"--°";
    FLabel.textAlignment = NSTextAlignmentCenter;
    FLabel.textColor = [UIColor whiteColor];
    FLabel.font = [UIFont systemFontOfSize:90.f];
    [self.view addSubview:FLabel];
    
    imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weatherbg"]];
    [self.view addSubview:imageV];
    
    if ([UIViewController instancesRespondToSelector:@selector(topLayoutGuide)]) {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topLayoutGuide).offset(10);
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(bounds.size.width-40);
            make.height.mas_equalTo(30);
        }];
        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topLayoutGuide).offset(74);
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(bounds.size.width-40);
            make.height.mas_equalTo(20);
        }];
    }
    if ([self.view respondsToSelector:@selector(safeAreaLayoutGuide)]) {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
            make.width.mas_equalTo(bounds.size.width-40);
            make.height.mas_equalTo(30);
        }];
        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(74);
            make.width.mas_equalTo(bounds.size.width-40);
            make.height.mas_equalTo(20);
        }];
    }
    
    [FLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_centerY).offset(-40);
        make.width.mas_equalTo(bounds.size.width-40);
        make.height.mas_equalTo(70);
    }];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_centerY).offset(20);
        make.width.mas_equalTo(bounds.size.width-40);
        make.height.mas_equalTo(270);
    }];
    
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
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    [weatherImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)updateInformation:(NSDictionary *)dic {
    NSString *date = [dic objectForKey:@"date"];
    dateLabel.text = [date substringFromIndex:[date rangeOfString:@"星"].location];
    weatherLabel.text = [dic objectForKey:@"type"];
    NSString *str = [dic objectForKey:@"low"];
    FLabel.text = [str stringByReplacingOccurrencesOfString:@"低温" withString:@""];
    weatherImg.image = [YSCommonHelper weatherIcon:dic[@"type"]];
}

@end


