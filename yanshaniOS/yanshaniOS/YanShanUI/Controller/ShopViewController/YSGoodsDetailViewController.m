//
//  YSGoodsDetailViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2017/12/3.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSGoodsDetailViewController.h"
#import "yanshaniOS-Swift.h"

@interface YSGoodsDetailViewController ()<FSPagerViewDelegate,FSPagerViewDataSource>
{
    FSPagerView *_pageView;
    FSPageControl *_pageControl;
}
@end

@implementation YSGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - config view controller

- (void)configViewControllerParameter {
    
}

- (void)configView {
    self.title = @"商品详情";
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect frame = self.view.bounds;
    
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:mainView];
    
    mainView.contentSize = CGSizeMake(self.view.bounds.size.width, 2000);
    
    _pageView = [[FSPagerView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 195)];
    _pageView.dataSource = self;
    _pageView.delegate = self;
    [_pageView registerClass:[FSPagerViewCell class] forCellWithReuseIdentifier:@"pageCell"];
    [mainView addSubview:_pageView];
    
    FSPageControl *pageControl = [[FSPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_pageView.frame)-20, CGRectGetWidth(_pageView.frame), 20)];
    pageControl.numberOfPages = 4;
    [mainView addSubview:pageControl];
    
    UILabel *goodsNameLabel = [[UILabel alloc] init];
    goodsNameLabel.text =@"资讯针对新型POS机恶意软Trojan.Win32.Alinaos的分析";
    goodsNameLabel.numberOfLines = 2;
    [mainView addSubview:goodsNameLabel];
    
    [goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainView).offset(20);
        make.right.equalTo(mainView).offset(-20);
        make.top.equalTo(_pageView.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *goodsPriceLabel = [[UILabel alloc] init];
    goodsPriceLabel.text = @"50安全豆";
    [mainView addSubview:goodsPriceLabel];
    [goodsPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsNameLabel);
        make.right.equalTo(goodsNameLabel.mas_centerX);
        make.top.equalTo(goodsNameLabel.mas_bottom);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *goodsNumberLabel = [[UILabel alloc] init];
    goodsNumberLabel.text = @"数量:1";
    goodsNumberLabel.textColor = [UIColor grayColor];
    goodsNumberLabel.textAlignment = NSTextAlignmentRight;
    [mainView addSubview:goodsNumberLabel];
    [goodsNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsNameLabel.mas_centerX);
        make.right.equalTo(goodsNameLabel);
        make.top.equalTo(goodsNameLabel.mas_bottom);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *goodsDesLabel = [[UILabel alloc] init];
    goodsDesLabel.text = @"------------商品描述------------";
    goodsDesLabel.textAlignment = NSTextAlignmentCenter;
    goodsDesLabel.backgroundColor = [UIColor grayColor];
    [mainView addSubview:goodsDesLabel];
    
    [goodsDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(goodsPriceLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(60);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goods.jpg"]];
    [mainView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(goodsDesLabel.mas_bottom).offset(10);
        make.bottom.equalTo(mainView);
    }];
}

- (void)addNavigationItems {
    [self addPopViewControllerButtonWithTarget:self action:@selector(backViewController:)];
}

- (NSInteger)numberOfItemsInPagerView:(FSPagerView *)pagerView {
    return 4;
}

- (FSPagerViewCell *)pagerView:(FSPagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    FSPagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"pageCell" atIndex:index];
    cell.imageView.image = [UIImage imageNamed:@"bannerplaceholder"];
    return cell;
}

- (void)pagerView:(FSPagerView *)pagerView didSelectItemAtIndex:(NSInteger)index {
    
}


@end
