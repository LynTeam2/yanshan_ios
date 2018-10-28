//
//  YSSearchViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2018/5/29.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSSearchViewController.h"
#import "YSClassCatogaryCell.h"
#import "YSClassViewCell.h"
#import "YSCourseModel.h"
#import "YSLawModel.h"
#import "YSCourseDetailViewController.h"
#import "YSLawInformationViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface YSSearchViewController ()<UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong) UICollectionView *resultsView;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray *results;

@property (nonatomic, assign) BOOL emptyDatas;

@end

@implementation YSSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configView {
    
    _results = [NSMutableArray arrayWithCapacity:0];
    CGFloat height = 30.f;
    CGFloat width = self.view.frame.size.width;

    [[UISearchBar appearance] setFrame:CGRectMake(0, 0, width-80, height)];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, width-80, height)];
    _searchBar.placeholder = @"请输入想要搜索的内容";
    _searchBar.barStyle = UIBarStyleDefault;
    _searchBar.barTintColor = kLightGray;
    _searchBar.delegate = self;
//    searchBar.frame = CGRectMake(0, 0, width-80, height);
    _searchBar.returnKeyType = UIReturnKeySearch;
    [_searchBar becomeFirstResponder];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_searchBar];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 60, height);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(backViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UICollectionViewFlowLayout *collectionFL = [[UICollectionViewFlowLayout alloc] init];
    collectionFL.minimumLineSpacing = 0;
    collectionFL.minimumInteritemSpacing = 0;
    collectionFL.itemSize = CGSizeMake(self.view.frame.size.width, 100);
    _resultsView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionFL];
    _resultsView.delegate = self;
    _resultsView.dataSource = self;
    _resultsView.emptyDataSetSource = self;
    _resultsView.emptyDataSetDelegate = self;
    _resultsView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_resultsView];
    [_resultsView registerClass:[YSClassCatogaryCell class] forCellWithReuseIdentifier:@"resultscell"];
    [_resultsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - dataSource(UICollectionView)

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _results.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YSClassCatogaryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"resultscell" forIndexPath:indexPath];
    if(indexPath.row < _results.count){
        [cell updateClassInformation:_results[indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id obj = _results[indexPath.row];
    if ([obj isKindOfClass:[YSCourseModel class]]) {
        YSCourseDetailViewController *classVC = [[YSCourseDetailViewController alloc] init];
        YSCourseModel *model = (YSCourseModel *)obj;
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
    }else if ([obj isKindOfClass:[YSLawModel class]]){
        YSLawModel *model = (YSLawModel *)obj;
        YSLawInformationViewController *infoVC = [[YSLawInformationViewController alloc] init];
        infoVC.model = model;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:infoVC animated:YES];
    }
}

#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return _emptyDatas;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([_searchBar isFirstResponder]) {
        [_searchBar endEditing:YES];
    }
}

#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"暂无数据"];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[YSNetWorkEngine sharedInstance] searchInformationWithParam:searchText responseHandler:^(NSError *error, id data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (data) {
            NSDictionary *dic = (NSDictionary *)data;
            NSInteger code = [[dic objectForKey:@"code"] integerValue];
            [_results removeAllObjects];
            if (code) {
                if (dic[@"results"]) {
                    NSArray *arr = [dic[@"results"] objectForKey:@"items"];
                    _emptyDatas = arr.count ? NO : YES;
                    for (NSDictionary *dic in arr) {
                        if ([dic[@"type"] isEqualToString:@"law"]) {
                            YSLawModel *model = [[YSLawModel alloc] initWithDictionary:dic[@"item"] error:nil];
                            [_results addObject:model];
                        }else if([dic[@"type"] isEqualToString:@"course"]){
                            NSString *courseId = [NSString stringWithFormat:@"%@.json",dic[@"item"]];
                            NSDictionary *dic = [[YSFileManager sharedFileManager] JSONSerializationJsonFile:courseId atDocumentName:@"course"];
                            if(dic[@"course"]) {
                                YSCourseModel *model = [[YSCourseModel alloc] initWithDictionary:dic[@"course"] error:nil];
                                [_results addObject:model];
                            }
                        }
                    }
                }
            }
        }
        [_resultsView reloadData];
        [_resultsView reloadEmptyDataSet];
    }];
}




@end
