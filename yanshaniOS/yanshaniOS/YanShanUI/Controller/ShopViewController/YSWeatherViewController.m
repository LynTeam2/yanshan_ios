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
#import "YSWeatherView.h"
#import <CoreLocation/CoreLocation.h>

@interface YSWeatherViewController ()<CLLocationManagerDelegate>
{
    NSMutableArray *weathers;
    CLLocationManager *locationManager;
    NSString *currentCity; //当前城市
    YSWeatherView *weatherView;
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

    // Do any additional setup after loading the view.
    weathers = [NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor = kBlueColor;
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
    
    [[YSNetWorkEngine sharedInstance] getWeatherDataWithparameters:city responseHandler:^(NSError *error, id data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDic = [data[@"HeWeather6"] firstObject];
            NSString *status = [resultDic objectForKey:@"status"];
            if ([@"ok" isEqual:status] || [@"OK" isEqual:status]) {
                [weatherView updateWeatherViewWith:city weatherData:resultDic];
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
    
    weatherView = [[YSWeatherView alloc] init];
    weatherView.backgroundColor = kBlueColor;
    [self.view addSubview:weatherView];
    UIEdgeInsets edges = UIEdgeInsetsZero;
    if ([self.view respondsToSelector:@selector(safeAreaLayoutGuide)]) {
        [weatherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.right.and.left.equalTo(self.view);
        }];
    }else{
        [weatherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    
}

@end

