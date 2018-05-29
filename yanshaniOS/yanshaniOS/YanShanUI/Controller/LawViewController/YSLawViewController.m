//
//  YSLawViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2018/4/15.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSLawViewController.h"
#import "YSLawListViewController.h"

@interface YSLawViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *lawView;
    NSArray *laws;
}
@end

@implementation YSLawViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [lawView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"法律法规";
    self.view.backgroundColor = [UIColor whiteColor];
    NSDictionary *dic = [[YSFileManager sharedFileManager] JSONSerializationJsonFile:@"lawType.json" atDocumentName:@"law"];
    if (dic[@"lawType"]) {
        laws = [dic[@"lawType"] copy];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configView {
    
    [self addPopViewControllerButtonWithTarget:self action:@selector(backViewController:)];
    
    UICollectionViewFlowLayout *fLayout = [[UICollectionViewFlowLayout alloc] init];
    fLayout.minimumLineSpacing = 20;
    fLayout.minimumInteritemSpacing = 0;
    fLayout.itemSize = CGSizeMake(self.view.frame.size.width-16*2, 114);
    fLayout.sectionInset = UIEdgeInsetsMake(16, 16, 20, 16);
    
    lawView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:fLayout];
    lawView.backgroundColor = [UIColor whiteColor];
    lawView.delegate = self;
    lawView.dataSource = self;
    lawView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:lawView];
    
    [lawView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    if ([self.view respondsToSelector:@selector(safeAreaLayoutGuide)]) {
        [lawView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }else if([UIViewController instancesRespondToSelector:@selector(topLayoutGuide)]){
        [lawView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}


#pragma mark - collection view delegate datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return laws.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSDictionary *dic = [laws objectAtIndex:indexPath.row];
    
    UIImageView *im = [[UIImageView alloc] init];
    im.layer.cornerRadius = 5;
    im.layer.masksToBounds = YES;
    [im sd_setImageWithURL:[NSURL URLWithString:dic[@"icon"]] placeholderImage:[UIImage imageNamed:@"law1"]];
    [cell addSubview:im];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = dic[@"name"];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:label];
    
    [im mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell);
    }];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(cell);
        make.width.equalTo(cell);
        make.height.mas_equalTo(20);
    }];
    im.userInteractionEnabled = YES;
    label.userInteractionEnabled = YES;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [laws objectAtIndex:indexPath.row];
    YSLawListViewController *lawListVC = [[YSLawListViewController alloc] init];
    lawListVC.lawID = dic[@"id"];
    lawListVC.title = dic[@"name"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:lawListVC animated:YES];
}

@end
