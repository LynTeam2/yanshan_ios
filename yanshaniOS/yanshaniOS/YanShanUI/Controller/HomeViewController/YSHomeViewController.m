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

#import "YSMoreClassViewController.h"
#import "YSExaminationViewController.h"
#import "YSSpecialItemViewController.h"
#import "YSNewsViewController.h"
#import "YSCourseDetailViewController.h"
#import "YSCourseModel.h"
#import "YSCourseCategoryModel.h"

@interface YSHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,YSHomeReusableViewDelegate>
{
    YSBaseCollectionView *_collectionView;
    NSArray *lastestCourses;
    NSMutableArray *newsList;
}
@end

@implementation YSHomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (0 == newsList.count) {
        [self requestNews];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    newsList = [NSMutableArray arrayWithCapacity:0];
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
    _collectionView = [[YSBaseCollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
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
    [searchBtn setBackgroundColor:kLightGray];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchBtn setImageEdgeInsets:UIEdgeInsetsMake(6, 10, 6, width-40-28)];
    searchBtn.frame = CGRectMake(20, 0, width-40, 30);
    searchBtn.layer.cornerRadius = 5;
    searchBtn.layer.masksToBounds = YES;
    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)configViewControllerParameter {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unzipFileSuccess:) name:@"unzipFileSuccess" object:nil];
    NSDictionary *jsonDic = [[YSFileManager sharedFileManager] JSONSerializationJsonFile:@"latest.json" atDocumentName:@"course"];
    if ([jsonDic objectForKey:@"courses"]) {
        NSArray *courses = [jsonDic objectForKey:@"courses"];
        lastestCourses = [NSArray arrayWithArray:[YSCourseModel arrayOfModelsFromDictionaries:courses error:nil]];
    }
}

- (void)unzipFileSuccess:(NSNotification *)noti {
    NSDictionary *jsonDic = [[YSFileManager sharedFileManager] JSONSerializationJsonFile:@"category.json" atDocumentName:@"course"];
    NSLog(@"%@",jsonDic);
}

- (void)requestNews {
    
    NSDictionary *parameters = @{@"page":@"0",
                                 @"size":@"5"};
    [[YSNetWorkEngine sharedInstance] getRequestNewWithparameters:parameters responseHandler:^(NSError *error, id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)data;
            NSInteger code = [[dic objectForKey:@"code"] integerValue];
            if (code) {
                NSDictionary *res = [dic objectForKey:@"results"];
                NSDictionary *list = [res objectForKey:@"newsList"];
                NSArray *arr = [list objectForKey:@"content"];
                if (arr.count) {
                    [newsList removeAllObjects];
                    [newsList addObjectsFromArray:arr];
                    [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
                }
            }
        }
    }];
}

#pragma mark - delegate(UICollectionView)

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        YSCourseDetailViewController *classVC = [[YSCourseDetailViewController alloc] init];
        YSCourseModel *model = lastestCourses[indexPath.row];
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
        return;
    }
    if (indexPath.section == 2) {
        YSNewsViewController *newsVC = [[YSNewsViewController alloc] init];
        newsVC.dic = newsList[indexPath.row];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newsVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

#pragma mark - dataSource(UICollectionView)

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger items = 0;
    switch (section) {
        case 0:
            break;
        case 1:
            items = lastestCourses.count > 4 ? 4 : lastestCourses.count;
            break;
        case 2:
            items = newsList.count;
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
            [cell updateClassCellWith:lastestCourses[indexPath.row]];
            return cell;
        }
        case 2: {
            YSNewsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"newsCell" forIndexPath:indexPath];
            if(indexPath.row < newsList.count){
                [cell updateClassInformation:newsList[indexPath.row]];
            }
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
                reusableView.delegate = self;
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
        reusableView.backgroundColor = kLightGray;
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
            CGFloat height = width*0.8;
            itemSize = CGSizeMake(width, height);
        }
            break;
        case 2:
            itemSize = CGSizeMake(self.view.frame.size.width, 150);
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


#pragma mark - YSHomeReusableView delegate

- (void)clickMenuButton:(UIButton *)button {
    
    if ([[button currentTitle] isEqualToString:@"测评考试"]) {
        YSExaminationViewController *examinationVC = [[YSExaminationViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:examinationVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        return;
    }
    NSDictionary *dic = [[YSFileManager sharedFileManager] JSONSerializationJsonFile:@"category.json" atDocumentName:@"course"];
    NSArray *courses = [YSCourseCategoryModel arrayOfModelsFromDictionaries:dic[@"categories"] error:nil];
    if ([[button currentTitle] isEqualToString:@"专项练习"]) {
        NSArray *specialCoursesArray = [NSArray arrayWithArray:courses];
        YSSpecialItemViewController *moreVC = [[YSSpecialItemViewController alloc] init];
        moreVC.title = @"专项练习";
        moreVC.leixingoneArray = [NSArray arrayWithArray:specialCoursesArray];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:moreVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        return;
    }
    NSArray *coursesArray = [NSArray arrayWithArray:courses];
    YSMoreClassViewController *moreVC = [[YSMoreClassViewController alloc] init];
    moreVC.title = [button currentTitle];
    moreVC.categoryCoursesArray = [NSArray arrayWithArray:coursesArray];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:moreVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)clickBannerAtIndex:(NSInteger)index with:(id)model {
    
}

@end
