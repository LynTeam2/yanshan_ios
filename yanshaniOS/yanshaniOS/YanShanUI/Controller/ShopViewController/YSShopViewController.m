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

@interface YSShopViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,FSPagerViewDelegate,FSPagerViewDataSource>
{
    YSBaseCollectionView *_collectionView;
    FSPagerView *_pageView;
    FSPageControl *_pageControl;
}
@end

@implementation YSShopViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configView {
    self.title = @"商场";
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.itemSize = CGSizeMake(self.view.frame.size.width, 112);
    flowLayout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 195);
    _collectionView = [[YSBaseCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[YSGoodsInfromationCell class] forCellWithReuseIdentifier:@"goodsCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader   withReuseIdentifier:@"goodsBanners"];
    
}

#pragma mark - dataSource(UICollectionView)

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger items = 10;
    return items;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YSGoodsInfromationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"goodsCell" forIndexPath:indexPath];
    [cell updateGoodsContent:nil];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"goodsBanners" forIndexPath:indexPath];
        
        _pageView = [[FSPagerView alloc] initWithFrame:reusableView.bounds];
        _pageView.dataSource = self;
        _pageView.delegate = self;
        [_pageView registerClass:[FSPagerViewCell class] forCellWithReuseIdentifier:@"pageCell"];
        [reusableView addSubview:_pageView];
        FSPageControl *pageControl = [[FSPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(reusableView.frame)-20, CGRectGetWidth(reusableView.frame), 20)];
        pageControl.numberOfPages = 4;
        [reusableView addSubview:pageControl];
        return reusableView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YSGoodsDetailViewController *goodsVC = [[YSGoodsDetailViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
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

@implementation YSGoodsInfromationCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        goodCover = [[UIImageView alloc] init];
        goodCover.userInteractionEnabled = YES;
        [self.contentView addSubview:goodCover];
        
        goodsNameLabel = [[UILabel alloc] init];
        goodsNameLabel.numberOfLines = 2;
        [self.contentView addSubview:goodsNameLabel];
        
        goodsPriceLabel = [[UILabel alloc] init];
        goodsPriceLabel.textColor = [UIColor redColor];
        goodsPriceLabel.font = [UIFont systemFontOfSize:13.f];
        [self.contentView addSubview:goodsPriceLabel];
        
        goodsMarketPriceLabel = [[UILabel alloc] init];
        goodsMarketPriceLabel.textColor = [UIColor grayColor];
        goodsMarketPriceLabel.font = [UIFont systemFontOfSize:13.f];
        [self.contentView addSubview:goodsMarketPriceLabel];
        
        line = [UIView instanceSeperateLineWithoutFrame];
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)layoutSubviews {
    
    CGFloat space = 10;
    [goodCover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(space);
        make.top.equalTo(self.contentView).offset(space);
        make.bottom.equalTo(self.contentView).offset(-space);
        make.width.mas_equalTo(CGRectGetHeight(self.frame)-2*space);
    }];
    
    [goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(space);
        make.left.equalTo(goodCover.mas_right).offset(space);
        make.right.equalTo(self.contentView).offset(-space);
        make.bottom.equalTo(self.contentView.mas_centerY);
    }];
    [goodsPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsNameLabel.mas_bottom);
        make.left.equalTo(goodsNameLabel);
        make.right.equalTo(self.contentView).offset(-space);
        make.height.equalTo(goodsMarketPriceLabel);
    }];
    [goodsMarketPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsPriceLabel.mas_bottom);
        make.left.equalTo(goodsNameLabel);
        make.right.equalTo(self.contentView).offset(-space);
        make.bottom.equalTo(self.contentView).offset(-space);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)updateGoodsContent:(id)model {
    goodsNameLabel.text = @"针对新型POS机恶意软件Trojan.Win32.Alinaos的分析";
    goodsPriceLabel.text = @"50安全豆";
    goodsMarketPriceLabel.text = @"市场参考价:50.00元";
    goodCover.backgroundColor = kRandomColor;
}

@end
