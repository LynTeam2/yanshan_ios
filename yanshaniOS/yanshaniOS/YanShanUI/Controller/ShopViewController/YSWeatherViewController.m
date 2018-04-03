//
//  YSShopViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2017/10/4.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSWeatherViewController.h"
#import "yanshaniOS-Swift.h"
#import "YSGoodsDetailViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface YSWeatherViewController ()<CLLocationManagerDelegate>
{
    NSMutableArray *weathers;
    UILabel *titleLabel;
    UILabel *infoLabel;
    UILabel *dateLabel;
    UILabel *FLabel;
    UIImageView *imageV;
    CLLocationManager *locationManager;
    NSString *currentCity; //当前城市
}
@end

@implementation YSWeatherViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    currentCity = currentCity.length == 0 ? @"北京" : currentCity;
    [self requestWeatherDataWithCity:currentCity];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    weathers = [NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor = kBlueColor;
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self locate];
}

- (void)locate {
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 500;
        [locationManager requestAlwaysAuthorization];
        currentCity = [[NSString alloc] init];
        [locationManager startUpdatingLocation];
//        [locationManager requestLocation];
    }
    
}

#pragma mark CoreLocation delegate

//定位失败则执行此代理方法
//定位失败弹出提示框,点击"打开定位"按钮,会打开系统的设置,提示打开定位服务
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"允许\"定位\"提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开定位设置
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}
//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    //反编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            currentCity = placeMark.locality;
            if (!currentCity) {
                currentCity = @"无法定位当前城市";
            }
            [self requestWeatherDataWithCity:currentCity];
            NSLog(@"%@",currentCity); //这就是当前的城市
            NSLog(@"%@",placeMark.name);//具体地址:  xx市xx区xx街道
        }
        else if (error == nil && placemarks.count == 0) {
            NSLog(@"No location and error return");
        }
        else if (error) {
            NSLog(@"location error: %@ ",error);
        }
        
    }];
}

- (void)requestWeatherDataWithCity:(NSString *)city {
    titleLabel.text = city;
    [[YSNetWorkEngine sharedInstance] getWeatherDataWithparameters:city responseHandler:^(NSError *error, id data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSInteger status = [[data objectForKey:@"status"] integerValue];
            if (200 == status) {
                NSDictionary *dic = [data objectForKey:@"data"];
                infoLabel.text = [NSString stringWithFormat:@"空气质量:   %@",dic[@"quality"]];
                FLabel.text = [NSString stringWithFormat:@"%@°",[dic objectForKey:@"wendu"]];
                if ([dic objectForKey:@"forecast"]) {
                    NSArray *arr = [dic objectForKey:@"forecast"];
                    [weathers addObjectsFromArray:arr];
                    CGFloat topSpace = 20;
                    CGFloat height = 35;
                    if (weathers.count) {
                        NSString *date = [weathers[0] objectForKey:@"date"];
                        dateLabel.text = [date substringFromIndex:[date rangeOfString:@"星"].location];
                    }
                    [imageV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
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
    titleLabel.text = @"--";
    titleLabel.font = [UIFont systemFontOfSize:20.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
//    @"9月03日  周日 农历七月十三"
    infoLabel = [[UILabel alloc] init];
    infoLabel.text = @"空气质量: ----";
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:infoLabel];
    
    FLabel = [[UILabel alloc] init];
    FLabel.text = @"--°";
    FLabel.textAlignment = NSTextAlignmentCenter;
    FLabel.textColor = [UIColor whiteColor];
    FLabel.font = [UIFont systemFontOfSize:90.f];
    [self.view addSubview:FLabel];
    
    dateLabel = [[UILabel alloc] init];
    dateLabel.text = @"--";
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:dateLabel];
    
    imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weatherbgnew"]];
    [self.view addSubview:imageV];
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
    }else if ([UIViewController instancesRespondToSelector:@selector(topLayoutGuide)]) {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_topLayoutGuide).offset(10);
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
    NSArray *ddd = [UIFont familyNames];
    [FLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(infoLabel.mas_bottom).offset(20);
        make.width.mas_equalTo(bounds.size.width-40);
        make.height.mas_equalTo(70);
    }];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FLabel.mas_bottom).offset(20);
        make.width.mas_equalTo(bounds.size.width-40);
        make.height.mas_equalTo(20);
    }];
    
    CGFloat timeViewWidth = (bounds.size.width-40)/5;
    
    NSArray *icons = @[@"sunwhite",@"moonwhite",@"nightwhite"];
    for (int i = 0; i < 5; i++) {
        
        NSDictionary *dic = @{
                              @"time":[YSCommonHelper timeFromNowWithTimeInterval:i*30*60],
                              @"image":icons[arc4random()%2],
                              @"c":@"18°"};
        
        YSWeatherTimeView *timeView = [[YSWeatherTimeView alloc] init];
        [timeView updateTimeWeatherData:dic];
        [self.view addSubview:timeView];
        
        [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20+timeViewWidth*i);
            make.top.equalTo(dateLabel.mas_bottom).offset(20);
            make.width.mas_equalTo(timeViewWidth);
            make.height.mas_equalTo(100);
        }];
    }
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_centerY).offset(70);
        make.width.mas_equalTo(bounds.size.width-40);
        make.height.mas_equalTo(220);
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
    NSString *date = [dic objectForKey:@"date"];
    dateLabel.text = [date substringFromIndex:[date rangeOfString:@"星"].location];
    weatherLabel.text = [dic objectForKey:@"type"];
    NSString *lowstr = [dic objectForKey:@"low"];
    NSString *highstr = [dic objectForKey:@"high"];
    if (lowstr) {
        lowstr = [lowstr stringByReplacingOccurrencesOfString:@"低温" withString:@""];
        lowstr = [lowstr stringByReplacingOccurrencesOfString:@".0℃" withString:@""];
    }
    if (highstr) {
        highstr = [highstr stringByReplacingOccurrencesOfString:@"高温" withString:@""];
        highstr = [highstr stringByReplacingOccurrencesOfString:@".0℃" withString:@""];
    }
    FLabel.text = [NSString stringWithFormat:@"%@°~%@°",lowstr,highstr];
    weatherImg.image = [YSCommonHelper weatherIcon:dic[@"type"]];
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
    timeLabel.text = [YSCommonHelper timeFromNowWithTimeInterval:30*60];//@"现在"
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.font = [UIFont systemFontOfSize:14.f];
    timeLabel.textColor = [UIColor whiteColor];
    [self addSubview:timeLabel];
    
    weatherIcon = [[UIImageView alloc] init];
    weatherIcon.image = [YSCommonHelper weatherIcon:@"多云"];
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
    weatherIcon.image = [UIImage imageNamed:data[@"image"]];
    Flabel.text = data[@"c"];
}

@end



