//
//  YSClassDetailViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2017/10/10.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSClassDetailViewController.h"

#import "YSCourseDetailViewController.h"
#import "YSClassViewCell.h"
#import "YSCourseModel.h"
#import "YSCourseItemModel.h"

@interface YSClassDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    NSArray *classesArray;
}
@end

@implementation YSClassDetailViewController

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
    if (_jsonFileName) {
        NSDictionary *dic = [[YSFileManager sharedFileManager] JSONSerializationJsonFile:_jsonFileName atDocumentName:@"course"];
        if ([dic objectForKey:@"courses"]) {
            classesArray = [YSCourseModel arrayOfModelsFromDictionaries:dic[@"courses"] error:nil];
        }
    }
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
    
    [_collectionView registerClass:[YSClassViewCell class] forCellWithReuseIdentifier:@"classCell"];
}

#pragma mark - UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return classesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YSClassViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"classCell" forIndexPath:indexPath];
    [cell updateClassCellWith:classesArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YSCourseDetailViewController *classVC = [[YSCourseDetailViewController alloc] init];
    YSCourseModel *model = classesArray[indexPath.row];
    NSArray *smArrary = [NSArray arrayWithArray:[YSCourseItemModel arrayOfModelsFromDictionaries:model.scList error:nil]];
    NSArray *mcArrary = [NSArray arrayWithArray:[YSCourseItemModel arrayOfModelsFromDictionaries:model.mcList error:nil]];
    NSArray *tfArrary = [NSArray arrayWithArray:[YSCourseItemModel arrayOfModelsFromDictionaries:model.tfList error:nil]];
    NSMutableArray *itemsList = [NSMutableArray arrayWithArray:smArrary];
    [itemsList addObjectsFromArray:mcArrary];
    [itemsList addObjectsFromArray:tfArrary];
    [classVC setCoursesData:itemsList];
    classVC.htmlStr = model.content;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:classVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - UICollectionViewFlowLayout delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = collectionView.bounds.size;
    CGFloat width = (size.width-40)/2;
    CGFloat height = width*0.7;
    return CGSizeMake(width, height);;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


@end
