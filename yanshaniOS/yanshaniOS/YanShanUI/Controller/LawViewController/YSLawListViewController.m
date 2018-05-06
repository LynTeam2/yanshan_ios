//
//  YSLawListViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2018/5/4.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSLawListViewController.h"
#import "YSClassCatogaryCell.h"
#import "YSLawModel.h"
#import "YSLawInformationViewController.h"

@interface YSLawListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *listView;

@property (nonatomic, strong) NSMutableArray *laws;

@end

@implementation YSLawListViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addPopViewControllerButtonWithTarget:self action:@selector(backViewController:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configView {
    
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
    _listView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:fl];
    _listView.backgroundColor = [UIColor whiteColor];
    _listView.delegate = self;
    _listView.dataSource = self;
    [self.view addSubview:_listView];
    [_listView registerClass:[YSClassCatogaryCell class] forCellWithReuseIdentifier:@"lawcell"];
    [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)configViewControllerParameter {
    NSDictionary *param = @{@"page":@"0",@"size":@"25",@"type":_lawID};
    [[YSNetWorkEngine sharedInstance] getLawsDataWithParam:param responseHandler:^(NSError *error, id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [data objectForKey:@"results"];
            NSDictionary *resDic = [dic objectForKey:@"laws"];
            _laws = [[YSLawModel arrayOfModelsFromDictionaries:resDic[@"content"] error:nil] copy];
            [_listView reloadData];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - delegate(UICollectionView)

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YSLawInformationViewController *infoVC = [[YSLawInformationViewController alloc] init];
    infoVC.model = _laws[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:infoVC animated:YES];
}

#pragma mark - dataSource(UICollectionView)

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _laws.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    YSClassCatogaryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"lawcell" forIndexPath:indexPath];
    if(indexPath.row < _laws.count){
        [cell updateClassInformation:_laws[indexPath.row]];
    }
    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize itemSize = CGSizeMake(self.view.frame.size.width, 90);
    return itemSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets edgeInsets  = UIEdgeInsetsMake(0, 0, 0, 0);
    return edgeInsets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    CGFloat lineSpace = 0.0f;
    return lineSpace;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

@end

