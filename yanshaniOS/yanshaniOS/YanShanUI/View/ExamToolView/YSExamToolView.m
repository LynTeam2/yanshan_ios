//
//  YSExamToolView.m
//  yanshaniOS
//
//  Created by 代健 on 2018/4/4.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSExamToolView.h"

@implementation YSExamToolView

{
    UICollectionView *examView;
    UIView *headerView;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:headerView];
    
    icon1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [icon1Btn setImage:[UIImage imageNamed:@"allitem"] forState:UIControlStateNormal];
    [headerView addSubview:icon1Btn];
    
    icon2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [icon2Btn setImage:[UIImage imageNamed:@"testright"] forState:UIControlStateNormal];
    [headerView addSubview:icon2Btn];
    
    icon3Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [icon3Btn setImage:[UIImage imageNamed:@"testwrong"] forState:UIControlStateNormal];
    [headerView addSubview:icon3Btn];
    
    icon4Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [icon4Btn setImage:[UIImage imageNamed:@"currnetItem"] forState:UIControlStateNormal];
    [headerView addSubview:icon4Btn];
    
    title1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [title1Btn setTitle:@"交卷" forState:UIControlStateNormal];
    [headerView addSubview:title1Btn];
    
    rightItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightItemBtn setTitle:@"0" forState:UIControlStateNormal];
    [headerView addSubview:rightItemBtn];
    
    wrongItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [wrongItemBtn setTitle:@"0" forState:UIControlStateNormal];
    [headerView addSubview:wrongItemBtn];
    
    currentItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [currentItemBtn setTitle:@"0/0" forState:UIControlStateNormal];
    [headerView addSubview:currentItemBtn];
    
    icon1Btn.tag = kJiaoJuanTag;
    icon4Btn.tag = kTiMuTag;
    [title1Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [wrongItemBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightItemBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [currentItemBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    examView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    examView.delegate = self;
    examView.dataSource = self;
    examView.showsVerticalScrollIndicator = NO;
    examView.backgroundColor = [UIColor whiteColor];
    [self addSubview:examView];
    [examView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}


- (void)layoutSubviews {
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    
    [icon1Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(20);
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [icon2Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(155);
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [icon3Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(220);
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [icon4Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView).offset(-80);
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [title1Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon1Btn.mas_right).offset(0);
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    [rightItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon2Btn.mas_right).offset(0);
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    [wrongItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon3Btn.mas_right).offset(0);
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    [currentItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon4Btn.mas_right).offset(0);
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(40, 0, 0, 0);
    [examView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(insets);
    }];
}

- (void)updateitemCountWith:(NSInteger)count isRight:(BOOL)right {
    if (right) {
    }else{
    }
}

- (void)addtarget:(id)target method:(SEL)action {
    [icon1Btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [icon4Btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [title1Btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)currentItemIndex:(NSInteger)index {
    [currentItemBtn setTitle:[NSString stringWithFormat:@"%ld",index] forState:UIControlStateNormal];
}

- (void)updateWrongChoiceCount:(NSInteger)count {
    [wrongItemBtn setTitle:[NSString stringWithFormat:@"%ld",count] forState:UIControlStateNormal];
}

- (void)updateRightChoiceCount:(NSInteger)count {
    [rightItemBtn setTitle:[NSString stringWithFormat:@"%ld",count] forState:UIControlStateNormal];
}

- (void)updateCurrentItemIndex:(NSString *)index {
    [currentItemBtn setTitle:index forState:UIControlStateNormal];
}

- (void)setItemsCount:(NSInteger)itemsCount {
    _itemsCount = itemsCount;
    [examView reloadData];
}

#pragma mark - delegate - datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _itemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 15;
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = [UIColor grayColor].CGColor;
    cell.layer.masksToBounds = YES;
    [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(0, 0, 30, 30);
    [cell addSubview:label];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 20, 0, 20);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(30, 30);
}

@end
