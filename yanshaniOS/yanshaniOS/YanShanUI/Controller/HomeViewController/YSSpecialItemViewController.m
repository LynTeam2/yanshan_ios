//
//  YSSpecialItemViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2018/1/30.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSSpecialItemViewController.h"
#import "YSClassDetailViewController.h"
#import "YSCourseItemModel.h"
#import "YSCourseCategoryModel.h"
#import "YSCourseModel.h"
#import "YSCourseDetailViewController.h"

@interface YSSpecialItemViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    NSArray *cellTitleArray;
    NSArray *sectionTitleArray;
}

@end

@implementation YSSpecialItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [_collectionView registerClass:[YSSpecialItemCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
}

- (void)configViewControllerParameter {
    cellTitleArray = @[@[@"危险化学品",@"企业行业",@"运输",@"建筑施工",@"人员密集场所",@"特种设备",@"消防"],
                   @[@"单选",@"多选",@"判断"],
                   @[@"初级",@"中级",@"高级"]];
    sectionTitleArray = @[@"类型一",@"类型二",@"类型三"];
    [self addPopViewControllerButtonWithTarget:self action:@selector(backViewController:)];
}

#pragma mark - UICollectionView delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return cellTitleArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section < cellTitleArray.count) {
        NSArray *sectionArray = cellTitleArray[section];
        return sectionArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YSSpecialItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.section < cellTitleArray.count) {
        NSArray *sectionArray = cellTitleArray[indexPath.section];
        [cell updateIndex:[NSString stringWithFormat:@"%ld",indexPath.row] andTitle:sectionArray[indexPath.row]];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        [reusableView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = sectionTitleArray[indexPath.section];
        titleLabel.frame = CGRectMake(20, 0, 100, 44);
        [reusableView addSubview:titleLabel];
        return reusableView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 2) {
        [self sectionCourseItems:0];
        YSCourseDetailViewController *classVC = [[YSCourseDetailViewController alloc] init];
        [classVC setCoursesData:_allArray];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:classVC animated:YES];
    }else if(indexPath.section == 1){
        YSCourseDetailViewController *classVC = [[YSCourseDetailViewController alloc] init];
        [classVC setCoursesData:[self rowCourseItems:indexPath.row]];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:classVC animated:YES];
    }
}

- (void)sectionCourseItems:(NSInteger)section {
    if (_allArray.count) {
        return;
    }
    _allArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *arr = @[@"multiplechoice.json",@"simplechoice.json",@"truefalse.json"];
    for (int i = 0; i < arr.count; i++) {
        NSDictionary *dic = [[YSFileManager sharedFileManager] JSONSerializationJsonFile:arr[i] atDocumentName:@"question"];
        if ([dic objectForKey:@"questions"]) {
           NSArray *classesArray = [YSCourseItemModel arrayOfModelsFromDictionaries:dic[@"questions"] error:nil];
            if (classesArray.count) {
                [_allArray addObjectsFromArray:classesArray];
            }
        }
    }
}

- (NSArray *)rowCourseItems:(NSInteger)row {
    NSArray *arr = @[@"simplechoice.json",@"multiplechoice.json",@"truefalse.json"];
    NSDictionary *dic = [[YSFileManager sharedFileManager] JSONSerializationJsonFile:arr[row] atDocumentName:@"question"];
    if ([dic objectForKey:@"questions"]) {
        NSArray *classesArray = [YSCourseItemModel arrayOfModelsFromDictionaries:dic[@"questions"] error:nil];
        return classesArray;
    }
    return nil;
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    CGFloat width = (self.view.frame.size.width-20*2-15*3)/2;
    size = CGSizeMake(width, 44);
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 44);
}

@end

@implementation YSSpecialItemCell
{
    UILabel *indexLabel;
    UILabel *titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        indexLabel = [[UILabel alloc] init];
        indexLabel.font = kDefaultFont;
        indexLabel.textAlignment = NSTextAlignmentCenter;
        indexLabel.layer.borderColor = [UIColor grayColor].CGColor;
        indexLabel.layer.borderWidth = 0.5;
        indexLabel.layer.cornerRadius = 15;
        indexLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:indexLabel];
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.font = kDefaultFont;
        [self.contentView addSubview:titleLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(indexLabel.mas_right).offset(5);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(30);
    }];
}

- (void)updateIndex:(NSString *)index andTitle:(NSString *)title {
    indexLabel.text = index;
    titleLabel.text = title;
}

@end




