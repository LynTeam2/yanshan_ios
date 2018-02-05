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
    
}

- (void)configView {
    
    UIButton *qiandaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [qiandaoBtn setTitle:@"签到" forState:UIControlStateNormal];
    [qiandaoBtn setBackgroundImage:[UIImage imageNamed:@"qiandaobgicon"] forState:UIControlStateNormal];
    [self.view addSubview:qiandaoBtn];
    
    [qiandaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(20);
        make.size.mas_equalTo(CGSizeMake(120, 120));
    }];
    
    _qiandaoLabel = [[UILabel alloc] init];
    _qiandaoLabel.numberOfLines = 2;
    _qiandaoLabel.textColor = [UIColor redColor];
    _qiandaoLabel.textAlignment = NSTextAlignmentCenter;
    _qiandaoLabel.text = @"今日签到可领取10安全豆\n连续签到有更多惊喜哦";
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
        UIView *tmpView = [self instanceDateViewWithFrame:CGRectMake(15+(width+5)*i, 210+20, width, height)];
        [self.view addSubview:tmpView];
    }
    
    UIView *line = [UIView instanceSeperateLineWithoutFrame];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(height+250);
        make.height.mas_equalTo(0.5);
    }];
    
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
    if ([[sender currentTitle] isEqualToString:@"签到"]) {
        [sender setTitle:@"已签到" forState:UIControlStateNormal];
    }else{
        [sender setTitle:@"签到" forState:UIControlStateNormal];
    }
}

#pragma mark - custom view

- (UIView *)instanceDateViewWithFrame:(CGRect)frame {
    
    UIView *dateBGV = [[UIView alloc] initWithFrame:frame];
    dateBGV.backgroundColor = [UIColor grayColor];
    
    UILabel *monthLabel = [[UILabel alloc] init];
    monthLabel.frame = CGRectMake(0, 15, frame.size.width, 20);
    monthLabel.font = [UIFont systemFontOfSize:16.f];
    monthLabel.text = @"八月";
    monthLabel.textColor = [UIColor redColor];
    monthLabel.textAlignment = NSTextAlignmentCenter;
    [dateBGV addSubview:monthLabel];
    
    UILabel *dayLabel = [[UILabel alloc] init];
    dayLabel.frame = CGRectMake(0, 0, frame.size.width, 20);
    dayLabel.font = [UIFont systemFontOfSize:20.f];
    dayLabel.text = @"29";
    dayLabel.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    dayLabel.textColor = [UIColor redColor];
    dayLabel.textAlignment = NSTextAlignmentCenter;
    [dateBGV addSubview:dayLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [button setTitle:@"已结束" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(userQiandao:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(15, CGRectGetMaxY(dayLabel.frame)+15, frame.size.width-30, 25);
    button.layer.cornerRadius = button.frame.size.height/2;
    button.layer.masksToBounds = YES;
    [button setBackgroundColor:[UIColor blueColor]];
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