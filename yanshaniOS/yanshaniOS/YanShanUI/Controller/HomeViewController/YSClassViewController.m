//
//  YSClassViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2017/10/10.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSClassViewController.h"
#import "YSNewsViewCell.h"

#import "YSMoreClassViewController.h"
#import "YSWrongItemViewController.h"
#import "YSSpecialItemViewController.h"
#import "YSClassDetailViewController.h"
#import "YSCourseCategoryModel.h"
#import "YSCourseItemModel.h"
#import "YSCourseDetailViewController.h"
#import "YSExaminationItemViewController.h"

#import "YSCourseManager.h"

@interface YSClassViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    NSArray *coursesArray;
    NSArray *specialCoursesArray;
    NSArray *wrongItemsArray;
}
@end

@implementation YSClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self wrongItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configViewControllerParameter {
    
    [self addPopViewControllerButtonWithTarget:self action:@selector(backViewController:)];
    
    NSDictionary *dic = [[YSFileManager sharedFileManager] JSONSerializationJsonFile:@"category.json" atDocumentName:@"course"];
    if ([dic objectForKey:@"categories"]) {
        NSArray *courses = [YSCourseCategoryModel arrayOfModelsFromDictionaries:dic[@"categories"] error:nil];
        coursesArray = [NSArray arrayWithArray:courses];
        specialCoursesArray = [NSArray arrayWithArray:courses];
    }
}

- (void)wrongItems {
    if ([[YSCourseManager sharedCourseManager] getAllWrongCourseItem].count) {
        wrongItemsArray = [NSArray arrayWithArray:[[YSCourseManager sharedCourseManager] getAllWrongCourseItem]];
    }else{
        YSCourseItemModel *model = [[YSCourseItemModel alloc] init];
        model.question = @"暂无错题";
        wrongItemsArray = [NSArray arrayWithObject:model];
    }
    [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:3]];
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
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[YSClassMenuCell class] forCellWithReuseIdentifier:@"menucell"];
    [_collectionView registerClass:[YSWrongItemCell class] forCellWithReuseIdentifier:@"wrongcell"];
    [_collectionView registerClass:[YSClassCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"normalheader"];
}

#pragma mark - UICollectionView delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    if (section == 1) {
        return coursesArray.count > 4 ? 4 : coursesArray.count;
    }
    if (section == 2) {
        return specialCoursesArray.count > 4 ? 4 : coursesArray.count;
    }
    return section != 3 ? 4 : wrongItemsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
            return cell;
        }
            break;
        case 1:{
            YSClassMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"menucell" forIndexPath:indexPath];
            if (indexPath.row < coursesArray.count) {
                YSCourseCategoryModel *model = coursesArray[indexPath.row];
                [cell updateCellImage:model.iconName andTitle:model.categoryName];
            }
            return cell;
        }
        case 2:{
            YSClassMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"menucell" forIndexPath:indexPath];
            if (indexPath.row < coursesArray.count) {
                YSCourseCategoryModel *model = coursesArray[indexPath.row];
                [cell updateCellImage:model.iconName andTitle:model.categoryName];
            }
            return cell;
        }
            break;
        case 3:{
            YSWrongItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"wrongcell" forIndexPath:indexPath];
            YSCourseItemModel *model = wrongItemsArray[indexPath.row];
            [cell updateContent:model.question];
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if(indexPath.section == 0) {
            UICollectionReusableView *reusablview = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"normalheader" forIndexPath:indexPath];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bannerplaceholder"]];
            imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
            [reusablview addSubview:imageView];
            return reusablview;
        }
        YSClassCollectionReusableView *headerReuableView = (YSClassCollectionReusableView*)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        headerReuableView.section = indexPath.section;
        if (indexPath.section != 0) {
            NSArray *titles = @[@"课程",@"专项练习",@"我的错题"];
            [headerReuableView setReusableViewTiltle:titles[indexPath.section-1]];
            [headerReuableView reusableAddTarget:self withAction:@selector(clickReusableView:)];
        }
        return headerReuableView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 || indexPath.section == 2) {
        YSCourseCategoryModel *model = coursesArray[indexPath.row];
        YSClassDetailViewController *detailVC = [[YSClassDetailViewController alloc] init];
        if (![model.categoryName isEmptyString]) {
            detailVC.title = model.categoryName;
        }
        detailVC.jsonFileName = [NSString stringWithFormat:@"%@.json",model.jsonName];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if (indexPath.section == 3) {
        if (wrongItemsArray.count == 1) {
            YSCourseItemModel *model = wrongItemsArray[0];
            if ([model.question isEqualToString:@"暂无错题"]) {
                return;
            }
        }
        YSExaminationItemViewController *vc = [[YSExaminationItemViewController alloc] init];
        vc.index = indexPath.row;
        vc.itemType = RightItemTypeNone;
        YSCourseItemModel *model = wrongItemsArray[indexPath.row];
        vc.itemModel = model;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    switch (indexPath.section) {
        case 0:
            size = CGSizeMake(50, 70);
            break;
        case 1:
        case 2:{
            CGFloat width = (self.view.frame.size.width-20*2-15*3)/4;
            size = CGSizeMake(width, 90);
        }
            break;
        case 3:{
            CGFloat width = (self.view.frame.size.width-40*2-15*2)/3;
            size = CGSizeMake(width, 1.2*width);
        }
            
            break;
        default:
            break;
    }
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return section == 3 ? 15 : 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 1 || section == 2) {
        return UIEdgeInsetsMake(0, 20, 0, 20);
    }
    if (section == 3) {
        return UIEdgeInsetsMake(0, 20, 0, 20);
    }
    return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(self.view.frame.size.width, 200);
    }
    return CGSizeMake(collectionView.frame.size.width, 44);
}

- (void)clickReusableView:(UIButton *)sender {
    if ([sender.superview isKindOfClass:[YSClassCollectionReusableView class]]) {
        YSClassCollectionReusableView *view = (YSClassCollectionReusableView*)sender.superview;
        if (view.section == 1) {
            YSMoreClassViewController *moreVC = [[YSMoreClassViewController alloc] init];
            moreVC.title = @"课程";
            moreVC.categoryCoursesArray = [NSArray arrayWithArray:coursesArray];
            [self.navigationController pushViewController:moreVC animated:YES];
        }else if (view.section == 2){
            YSSpecialItemViewController *moreVC = [[YSSpecialItemViewController alloc] init];
            moreVC.title = @"专项练习";
            moreVC.leixingoneArray = [NSArray arrayWithArray:specialCoursesArray];
            [self.navigationController pushViewController:moreVC animated:YES];
        }else if(view.section == 3){
            YSWrongItemViewController *itemVC = [[YSWrongItemViewController alloc] init];
            itemVC.wrongItemList = [NSArray arrayWithArray:wrongItemsArray];
            itemVC.title = @"我的错题";
            [self.navigationController pushViewController:itemVC animated:YES];
        }
    }
}

@end

@implementation YSClassCollectionReusableView

{
    UILabel *titleLabel;
    UIButton *moreButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self =  [super initWithFrame:frame];
    if (self) {
        _section = 0;
        titleLabel = [[UILabel alloc] init];
        [self addSubview:titleLabel];
        moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [moreButton setImage:[UIImage imageNamed:@"rightgraybackicon"] forState:UIControlStateNormal];
        [self addSubview:moreButton];
    }
    return self;
}

- (void)layoutSubviews {
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self);
        make.right.equalTo(self.mas_centerX);
    }];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-10);
        make.size.mas_equalTo(CGSizeMake(34, 34));
    }];
    [moreButton setImageEdgeInsets:UIEdgeInsetsMake(8, 12, 9, 13)];
}

- (void)updateConstraints {
    [super updateConstraints];
}

- (void)setReusableViewTiltle:(NSString *)title {
    if (title) {
        titleLabel.text = title;
    }
}

- (void)reusableAddTarget:(id)target withAction:(SEL)action {
    [moreButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end

@implementation YSClassMenuCell
{
    UIImageView *iconView;
    UILabel *titleLabel;
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
        CGFloat height = frame.size.height;
        CGFloat width = frame.size.width;
        CGFloat minValue = height > width ? width : height;
        iconView = [[UIImageView alloc] init];
        iconView.frame = CGRectMake(10, 0, minValue-20,minValue-20);
        iconView.userInteractionEnabled = YES;
        [self addSubview:iconView];
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.frame =  CGRectMake(0, minValue-10, width, fabs(minValue-height));
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.userInteractionEnabled = YES;
        [self addSubview:titleLabel];
    }
    return self;
}

- (void)updateCellImage:(NSString *)imageName andTitle:(NSString *)title {
    [titleLabel setText:title];
    UIImage *categoryImage = [[YSFileManager sharedFileManager] getUnzipFileImageWithImageName:imageName];
    if (categoryImage) {
        [iconView setImage:categoryImage];
    }else{
        [iconView setImage:[UIImage imageNamed:imageName]];
    }
}

@end

@implementation YSWrongItemCell
{
    UIView *colorView;
    UILabel *contentLabel;
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
        colorView = [[UIView alloc] init];
        colorView.backgroundColor = kRandomColor;
        [self addSubview:colorView];
        contentLabel = [[UILabel alloc] init];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.numberOfLines = 4;
        contentLabel.font = kDefaultFont;
        [self addSubview:contentLabel];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor grayColor].CGColor;
    }
    return self;
}

- (void)layoutSubviews {
    [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(10);
        make.size.mas_equalTo(CGSizeMake(5, 5));
    }];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(colorView.mas_bottom);
        make.left.equalTo(colorView.mas_right);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-15);
    }];
}

- (void)updateContent:(NSString *)content {
    if (content) {
        contentLabel.text = content;
    }
}

@end
