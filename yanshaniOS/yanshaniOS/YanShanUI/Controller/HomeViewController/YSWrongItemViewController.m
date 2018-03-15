//
//  YSWrongItemViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2018/1/30.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSWrongItemViewController.h"
#import "YSClassViewController.h"
#import "YSCourseItemModel.h"
#import "YSExaminationItemViewController.h"

@interface YSWrongItemViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
}

@end

@implementation YSWrongItemViewController

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
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    if ([self.view respondsToSelector:@selector(safeAreaLayoutGuide)]) {
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view.safeAreaInsets);
        }];
    }
    if ([UIViewController instancesRespondToSelector:@selector(topLayoutGuide)]) {
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.edgesForExtendedLayout);
        }];
    }
    [_collectionView registerClass:[YSWrongItemCell class] forCellWithReuseIdentifier:@"wrongcell"];
}

#pragma mark - UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _wrongItemList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YSWrongItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"wrongcell" forIndexPath:indexPath];
    YSCourseItemModel *model = _wrongItemList[indexPath.row];
    [cell updateContent:model.question];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YSExaminationItemViewController *vc = [[YSExaminationItemViewController alloc] init];
    vc.index = indexPath.row;
    vc.itemType = RightItemTypeNone;
    YSCourseItemModel *model = _wrongItemList[indexPath.row];
    vc.itemModel = model;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeZero;
    CGFloat width = (self.view.frame.size.width-40*2-15*2)/3;
    size = CGSizeMake(width, 1.2*width);
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 20, 0, 20);
}

@end
