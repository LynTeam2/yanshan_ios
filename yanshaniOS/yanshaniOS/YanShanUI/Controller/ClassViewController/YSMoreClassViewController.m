//
//  YSMoreClassViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2018/1/27.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSMoreClassViewController.h"

#import "YSClassDetailViewController.h"
#import "YSExaminationViewController.h"
#import "YSExamModel.h"
#import "YSCourseCategoryModel.h"
#import "YSClassCatogaryCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface YSMoreClassViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    UICollectionView *_collectionView;
    BOOL emptyData;
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
    emptyData = _categoryCoursesArray.count == 0;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGRect frame = self.view.bounds;
    frame.size.height -= 64;
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.emptyDataSetSource = self;
    _collectionView.emptyDataSetDelegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[YSClassCatogaryCell class] forCellWithReuseIdentifier:@"classCell"];
}

#pragma mark - UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _categoryCoursesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YSClassCatogaryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"classCell" forIndexPath:indexPath];
    [cell updateClassInformation:_categoryCoursesArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id data = _categoryCoursesArray[indexPath.row];
    if ([data isKindOfClass:[YSCourseCategoryModel class]]) {
        YSCourseCategoryModel *model = (YSCourseCategoryModel *)data;
        YSClassDetailViewController *detailVC = [[YSClassDetailViewController alloc] init];
        if (![model.categoryName isEmptyString]) {
            detailVC.title = model.categoryName;
        }
        detailVC.jsonFileName = [NSString stringWithFormat:@"%@.json",model.jsonName];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if ([data isKindOfClass:[YSExamModel class]]) {
        YSExaminationViewController *examinationVC = [[YSExaminationViewController alloc] init];
        examinationVC.examModel = (YSExamModel *)data;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:examinationVC animated:YES];
    }
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

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return emptyData;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"暂无考题"];
}

@end
