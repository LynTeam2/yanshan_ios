//
//  YSMoreClassViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2018/1/27.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSMoreClassViewController.h"

#import "YSClassDetailViewController.h"

#import "YSCourseCategoryModel.h"

#import "YSNewsViewCell.h"

@interface YSMoreClassViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
}

@end

@implementation YSMoreClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configViewControllerParameter {
    [self addPopViewControllerButtonWithTarget:self action:@selector(backViewController:)];
}

- (void)configView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGRect frame = self.view.bounds;
    frame.size.height -= 64;
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[YSNewsViewCell class] forCellWithReuseIdentifier:@"classCell"];
}

#pragma mark - UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _categoryCoursesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YSNewsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"classCell" forIndexPath:indexPath];
    [cell updateClassInformation:_categoryCoursesArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YSCourseCategoryModel *model = _categoryCoursesArray[indexPath.row];
    YSClassDetailViewController *detailVC = [[YSClassDetailViewController alloc] init];
    if (![model.categoryName isEmptyString]) {
        detailVC.title = model.categoryName;
    }
    detailVC.jsonFileName = [NSString stringWithFormat:@"%@.json",model.jsonName];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width, 100);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

@end
