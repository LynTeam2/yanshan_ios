//
//  YSQianDaoViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2017/11/19.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSQianDaoViewController.h"

@interface YSQianDaoViewController ()

@property (strong, nonatomic) IBOutlet UILabel *qiandaoLabel;

@end

@implementation YSQianDaoViewController
{
    UIButton *qiandaoBtn;
    UIButton *todayBtn;
    NSMutableDictionary *qiandaoDic;
    NSString *qiandaoKey;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"签到";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - config view controller

- (void)configViewControllerParameter {
    NSString *path = [[YSFileManager sharedFileManager] createFileAtDocumentDirectoryPath:kQianDaoFile];
    qiandaoDic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    if (!qiandaoDic) {
        qiandaoDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    qiandaoKey = [YSCommonHelper timeFromNowWithTimeInterval:0 dateFormat:@"yyyyMMdd"];
}

- (void)configView {
    
    NSString *btnTitle = @"签到";
  
    qiandaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [qiandaoBtn setBackgroundImage:[UIImage imageNamed:@"qiandaobgicon"] forState:UIControlStateNormal];
    [qiandaoBtn addTarget:self action:@selector(qiandao:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qiandaoBtn];
    if (qiandaoDic) {
        btnTitle = [qiandaoDic objectForKey:qiandaoKey] ? @"已签到": @"签到";
        qiandaoBtn.enabled = [qiandaoDic objectForKey:qiandaoKey] ? NO : YES;
    }
    [qiandaoBtn setTitle:btnTitle forState:UIControlStateNormal];

    [qiandaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(20);
        make.size.mas_equalTo(CGSizeMake(120, 120));
    }];
    
    _qiandaoLabel = [[UILabel alloc] init];
    _qiandaoLabel.numberOfLines = 2;
    _qiandaoLabel.textAlignment = NSTextAlignmentCenter;
    NSString *str = @"今日签到可领取10安全豆\n连续签到有更多惊喜哦";
    NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f]}];
    [mStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:[str rangeOfString:@"10"]];
    _qiandaoLabel.attributedText = mStr;
    [self.view addSubview:_qiandaoLabel];
    
    [_qiandaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.top.equalTo(qiandaoBtn.mas_bottom).offset(20);
        make.height.mas_equalTo(50);
    }];
    CGRect frame = self.view.bounds;
    CGFloat width = (frame.size.width-45)/4;
    CGFloat height = width * (320.0/215.0);
    
    for (int i = 0; i < 4; i++) {
        UIView *tmpView = [self instanceDateViewWithFrame:CGRectMake(15+(width+5)*i, 210+20, width, height) dayInterval:(i-3)];
        [self.view addSubview:tmpView];
    }
    
    UIView *line = [UIView instanceSeperateLineWithoutFrame];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(height+250);
        make.height.mas_equalTo(kLineHeight);
    }];
    return;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"商品兑换";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(line.mas_bottom).offset(20);
    }];
    UIView *goodsView1 = [self instanceGoodsView:CGRectMake(0, 0, frame.size.width-80, 50)];
    [self.view addSubview:goodsView1];
    [goodsView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(frame.size.width-80);
    }];
    UIView *goodsView2 = [self instanceGoodsView:CGRectMake(0, 0, frame.size.width-80, 50)];
    [self.view addSubview:goodsView2];
    [goodsView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(goodsView1.mas_bottom).offset(10);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(frame.size.width-80);
    }];
}

- (void)addNavigationItems {
    [self addPopViewControllerButtonWithTarget:self action:@selector(backViewController:)];
}

#pragma mark - UIButton action

- (IBAction)userQiandao:(UIButton *)sender {
    [sender setTitle:@"签到" forState:UIControlStateNormal];
    [self qiandao:qiandaoBtn];
}

- (void)qiandao:(UIButton *)sender {
    [todayBtn setTitle:@"已签到" forState:UIControlStateNormal];
    [sender setTitle:@"已签到" forState:UIControlStateNormal];
    sender.enabled = NO;
    NSString *beans = [NSString stringWithFormat:@"%ld",[YSUserModel shareInstance].beanCount +10];

    [[YSNetWorkEngine sharedInstance] modifyUserInformationWithParam:@{@"beanCount":beans} responseHandler:^(NSError *error, id data) {
        if (data) {
            [YSUserModel shareInstance].beanCount += 10;
            [qiandaoDic setObject:@"1" forKey:qiandaoKey];
            [qiandaoDic writeToFile:[[YSFileManager sharedFileManager] createFileAtDocumentDirectoryPath:kQianDaoFile] atomically:YES];
            if (_QDBlock) {
                _QDBlock(YES);
            }
        }else{
            [[UIApplication sharedApplication].keyWindow makeToast:@"签到失败" duration:2.0 position:@"center"];
        }
    }];
    
}

#pragma mark - custom view

- (UIView *)instanceDateViewWithFrame:(CGRect)frame dayInterval:(int)interval {
    
    UIView *dateBGV = [[UIView alloc] initWithFrame:frame];
    dateBGV.backgroundColor = kLightGray;
    
    UILabel *monthLabel = [[UILabel alloc] init];
    monthLabel.frame = CGRectMake(0, 15, frame.size.width, 20);
    monthLabel.font = [UIFont systemFontOfSize:14.f];
    monthLabel.text = [[YSCommonHelper timeFromNowWithTimeInterval:(60*60*24) dateFormat:@"M"] stringByAppendingString:@"月"];
    monthLabel.textColor = [UIColor redColor];
    monthLabel.textAlignment = NSTextAlignmentCenter;
    [dateBGV addSubview:monthLabel];
    
    UILabel *dayLabel = [[UILabel alloc] init];
    dayLabel.frame = CGRectMake(0, 0, frame.size.width, 20);
    dayLabel.font = [UIFont systemFontOfSize:25.f];
    dayLabel.text = [YSCommonHelper timeFromNowWithTimeInterval:(60*60*24*interval) dateFormat:@"dd"];
    dayLabel.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    dayLabel.textColor = [UIColor redColor];
    dayLabel.textAlignment = NSTextAlignmentCenter;
    [dateBGV addSubview:dayLabel];
    
    NSString *date = [YSCommonHelper timeFromNowWithTimeInterval:(60*60*24*interval) dateFormat:@"yyyyMMdd"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:12.f];
    if (interval == 0 && ![qiandaoDic objectForKey:qiandaoKey]) {
        todayBtn = button;
        [button setTitle:@"签到" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(userQiandao:) forControlEvents:UIControlEventTouchUpInside];
    }else if([qiandaoDic objectForKey:date]){
        [button setTitle:@"已签到" forState:UIControlStateNormal];
    }else{
        [button setTitle:@"未签到" forState:UIControlStateNormal];
    }
    button.frame = CGRectMake(15, CGRectGetMaxY(dayLabel.frame)+15, frame.size.width-30, 25);
    button.layer.cornerRadius = button.frame.size.height/2;
    button.layer.masksToBounds = YES;
    [button setBackgroundColor:kBlueColor];
    [dateBGV addSubview:button];
    
    return dateBGV;
}

- (UIView *)instanceGoodsView:(CGRect)frame {
    
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    bgView.backgroundColor = [UIColor blueColor];
    bgView.layer.cornerRadius = frame.size.height/2;
    bgView.layer.masksToBounds = YES;
    
    UILabel *goodsNameLabel = [[UILabel alloc] init];
    goodsNameLabel.text = @"安全类电子书一本";
    goodsNameLabel.textColor = [UIColor whiteColor];
    goodsNameLabel.frame = CGRectMake(frame.size.height/2+10, 10, frame.size.width*0.6, frame.size.height-20);
    [bgView addSubview:goodsNameLabel];
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyBtn setBackgroundColor:[UIColor whiteColor]];
    [buyBtn setTitle:@"兑换" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    buyBtn.frame = CGRectMake(frame.size.width-frame.size.height, 5, frame.size.height-10, frame.size.height-10);
    buyBtn.layer.cornerRadius = frame.size.height/2-5;
    buyBtn.layer.masksToBounds = YES;
    [bgView addSubview:buyBtn];
    
    return bgView;
}

@end
