//
//  ViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2017/9/24.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSHomeViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "YSClassViewCell.h"
#import "YSNewsViewCell.h"
#import "YSHomeReusableView.h"

@interface YSHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    UICollectionView *_collectionView;
}
@end

@implementation YSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configView {

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGRect frame = self.view.bounds;
    frame.size.height -= 49+64;
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.emptyDataSetDelegate = self;
    _collectionView.emptyDataSetSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[YSClassViewCell class] forCellWithReuseIdentifier:@"classCell"];
    [_collectionView registerClass:[YSNewsViewCell class] forCellWithReuseIdentifier:@"newsCell"];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_collectionView registerClass:[YSHomeReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"homeHeader"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    _collectionView.backgroundColor = [UIColor whiteColor];
    
}

- (void)addNavigationItems {
    CGFloat width = self.view.frame.size.width;
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setBackgroundColor:[UIColor grayColor]];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchBtn setImageEdgeInsets:UIEdgeInsetsMake(6, 10, 6, width-40-28)];
    searchBtn.frame = CGRectMake(20, 0, width-40, 30);
    searchBtn.layer.cornerRadius = 15;
    searchBtn.layer.masksToBounds = YES;
    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.leftBarButtonItem = item;
}

#pragma mark - delegate(UICollectionView)

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - dataSource(UICollectionView)

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger items = 0;
    switch (section) {
        case 0:
            
            break;
        case 1:
            items = 4;
            break;
        case 2:
            items = 5;
            break;
        default:
            break;
    }
    return items;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 1: {
            YSClassViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"classCell" forIndexPath:indexPath];
            [cell updateClassCellWith:nil];
            return cell;
        }
        case 2: {
            YSNewsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"newsCell" forIndexPath:indexPath];
            return cell;
        }
        default:
            break;
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        switch (indexPath.section) {
            case 0: {
                YSHomeReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"homeHeader" forIndexPath:indexPath];
                return reusableView;
            }
            case 1:
            case 2:
            default:{
                UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
                [reusableView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                UILabel *titleLabel = [[UILabel alloc] init];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                [reusableView addSubview:titleLabel];
                titleLabel.frame = reusableView.bounds;
                NSArray *titles = @[@"课程学习", @"安监动态"];
                titleLabel.text = titles[indexPath.section - 1];
                return reusableView;
            }
        }
    }else{
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        reusableView.backgroundColor = [UIColor grayColor];
        [reusableView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        if (indexPath.section == 2) {
            UILabel *label = [[UILabel alloc] init];
            label.frame = reusableView.bounds;
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"查看更多";
            [reusableView addSubview:label];
            reusableView.backgroundColor = [UIColor whiteColor];
        }
        return reusableView;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize itemSize = CGSizeZero;
    switch (indexPath.section) {
        case 1:{
            CGSize size = collectionView.bounds.size;
            CGFloat width = (size.width-40)/2;
            CGFloat height = width*0.7;
            itemSize = CGSizeMake(width, height);
        }
            break;
        case 2:
            itemSize = CGSizeMake(self.view.frame.size.width, 100);
        default:
            break;
    }
    return itemSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    switch (section) {
        case 1:
            edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
            break;
        case 2:
            edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            break;
        default:
            break;
    }
    return edgeInsets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    CGFloat lineSpace = 0.0f;
    switch (section) {
        case 1:
            lineSpace = 10.0f;
            break;
        default:
            break;
    }
    return lineSpace;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = CGSizeZero;
    switch (section) {
        case 0:
            size = CGSizeMake(collectionView.frame.size.width, 320);
            break;
        case 1:
        case 2:
            size = CGSizeMake(collectionView.frame.size.width, 54);
            break;
        default:
            break;
    }
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    CGSize size = CGSizeZero;
    switch (section) {
        case 0:
            size = CGSizeMake(collectionView.frame.size.width, 0.5);
            break;
        case 1:
            size = CGSizeMake(collectionView.frame.size.width, 8);
            break;
        case 2:
            size = CGSizeMake(collectionView.frame.size.width, 60);
            break;
        default:
            break;
    }
    return size;
}

#pragma mark - DZNEmptyDataSetDelegate



#pragma mark - DZNEmptyDataSetSource

@end
