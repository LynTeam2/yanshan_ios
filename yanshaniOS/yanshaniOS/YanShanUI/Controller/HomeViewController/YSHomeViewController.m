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
#import "YSLawViewController.h"
#import "YSSearchViewController.h"

#import "YSCourseModel.h"
#import "YSCourseCategoryModel.h"
#import "YSExamModel.h"

@interface YSHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,YSHomeReusableViewDelegate>
{
    YSBaseCollectionView *_collectionView;
    NSArray *lastestCourses;
    NSArray *banners;
    NSMutableArray *newsList;
    UICollectionViewFlowLayout *flowLayout;
    NewsRequestStatue newsStatus;
}
@end

@implementation YSHomeViewController

- (void)loadView {
    flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[YSBaseCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.showsVerticalScrollIndicator = NO;
    self.view = _collectionView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (0 == newsList.count) {
        [self requestNews:nil];
    }
    if (![[YSFileManager sharedFileManager] zipUpdate]) {
        [[YSFileManager sharedFileManager] zipDoUpdate:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    newsList = [NSMutableArray arrayWithCapacity:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unzipFileSuccess:) name:kUnzipSuccessNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - class method

- (void)configView {
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
//    _collectionView.emptyDataSetDelegate = self;
//    _collectionView.emptyDataSetSource = self;
    [_collectionView registerClass:[YSClassViewCell class] forCellWithReuseIdentifier:@"classCell"];
    [_collectionView registerClass:[YSNewsViewCell class] forCellWithReuseIdentifier:@"newsCell"];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_collectionView registerClass:[YSHomeReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"homeHeader"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    _collectionView.backgroundColor = [UIColor whiteColor];
    
}

- (void)addNavigationItems {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setBackgroundColor:kLightGray];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchBtn setImageEdgeInsets:UIEdgeInsetsMake(6, 10, 6, width-40-28)];
    searchBtn.frame = CGRectMake(20, 0, width-40, 36);
    searchBtn.layer.cornerRadius = 5;
    searchBtn.layer.masksToBounds = YES;
    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.leftBarButtonItem = item;
    [searchBtn addTarget:self action:@selector(searchInformation:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)searchInformation:(UIButton *)sender {
    YSSearchViewController *searchVC = [[YSSearchViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)configViewControllerParameter {
    [self handleZipFileData];
    [self handleBannerData];
}

- (void)unzipFileSuccess:(NSNotification *)noti {
    [self handleZipFileData];
    [self handleBannerData];
    [self collectionView:_collectionView viewForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathWithIndex:0]];
    [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
}

- (void)handleZipFileData {
    @synchronized (self) {
        NSDictionary *jsonDic = [[YSFileManager sharedFileManager] JSONSerializationJsonFile:@"latest.json" atDocumentName:@"course"];
        if ([jsonDic objectForKey:@"courses"]) {
            NSArray *courses = [jsonDic objectForKey:@"courses"];
            lastestCourses = [NSArray arrayWithArray:[YSCourseModel arrayOfModelsFromDictionaries:courses error:nil]];
        }
    }
}

- (void)handleBannerData {
    NSDictionary *dic = [[YSFileManager sharedFileManager] JSONSerializationJsonFile:@"banner.json" atDocumentName:@"banner"];
    if (dic) {
        banners = [[dic objectForKey:@"banners"] copy];
    }
}

- (void)requestNews:(UIButton *)sender {
    if (newsStatus == NewsRequestStatueFinished) return;
    if(sender) [sender setTitle:@"正在加载中..." forState:UIControlStateNormal];
    NSInteger count = newsList.count + 5;
    NSDictionary *parameters = @{@"page":@"0",
                                 @"size":[NSString stringWithFormat:@"%ld",count]};
    __weak UIButton *weakButton = sender;
    [[YSNetWorkEngine sharedInstance] getRequestNewsWithparameters:parameters responseHandler:^(NSError *error, id data) {
        if (error) {
            __strong UIButton *btn = weakButton;
            [btn setTitle:@"暂无新闻内容..." forState:UIControlStateNormal];
            return ;
        }
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)data;
            NSInteger code = [[dic objectForKey:@"code"] integerValue];
            if (code) {
                NSDictionary *res = [dic objectForKey:@"results"];
                NSDictionary *list = [res objectForKey:@"newsList"];
                NSArray *arr = [list objectForKey:@"content"];
                newsStatus = arr.count < count ? NewsRequestStatueFinished : NewsRequestStatueDone;
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
        classVC.model = model;
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
                [reusableView updateBanners:banners];
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
                NSArray *titles = @[@"必考课程", @"安监动态"];
                titleLabel.text = titles[indexPath.section - 1];
                return reusableView;
            }
        }
    }else{
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        reusableView.backgroundColor = kLightGray;
        [reusableView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        if (indexPath.section == 2) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = reusableView.bounds;
            NSString *title;
            if(newsStatus == NewsRequestStatueLoading){
                title = @"正在加载中...";
            }else if (newsStatus == NewsRequestStatueDone){
                title = @"查看更多";
            }else {
                title = @"没有更多资讯内容";
            }
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [reusableView addSubview:btn];
            [btn addTarget:self action:@selector(requestNews:) forControlEvents:UIControlEventTouchUpInside];
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
    if ([[button currentTitle] isEqualToString:@"法律法规"]) {
        YSLawViewController *lawVC = [[YSLawViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:lawVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if ([[button currentTitle] isEqualToString:@"测评考试"]) {
        NSDictionary *dic = [[YSFileManager sharedFileManager] JSONSerializationJsonFile:@"exam.json" atDocumentName:@"exam"];
        if (![dic objectForKey:@"exams"]) {
            return;
        }
        NSError *err;
        NSArray *exams = [YSExamModel arrayOfModelsFromDictionaries:dic[@"exams"] error:&err];
        YSMoreClassViewController *moreVC = [[YSMoreClassViewController alloc] init];
        moreVC.title = [button currentTitle];
        moreVC.categoryCoursesArray = [exams copy];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:moreVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        return;
    }else{
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
}

- (void)clickBannerAtIndex:(NSInteger)index with:(id)model {
    
}

@end
