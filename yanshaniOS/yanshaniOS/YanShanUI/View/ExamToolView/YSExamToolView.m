//
//  YSExamToolView.m
//  yanshaniOS
//
//  Created by 代健 on 2018/4/4.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSExamToolView.h"
#import "YSCourseItemModel.h"

CGFloat headerHeight = 40.f;

@implementation YSExamToolView

{
    UICollectionView *examView;
    UIView *headerView;
    ExamToolViewType toolViewType;
    UIView *backgroundView;
    CGFloat topSpace;
    CGFloat iPhoneXSpace;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withType:(ExamToolViewType)viewType {
    self = [self initWithFrame:frame];
    if (self) {
        toolViewType = viewType;
        topSpace = frame.size.height - headerHeight;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    backgroundView = [[UIView alloc] init];
    backgroundView.hidden = YES;
    backgroundView.backgroundColor = kRGBColor(0, 0, 0, 0.5);
    [self addSubview:backgroundView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel:)];
    [backgroundView addGestureRecognizer:tap];
    
    headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:headerView];
    
    icon1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [icon1Btn setImage:[UIImage imageNamed:@"allitem"] forState:UIControlStateNormal];
    [headerView addSubview:icon1Btn];
    
    icon2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [icon2Btn setImage:[UIImage imageNamed:@"testright"] forState:UIControlStateNormal];
    [headerView addSubview:icon2Btn];
    
    icon3Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [icon3Btn setImage:[UIImage imageNamed:@"testwrong"] forState:UIControlStateNormal];
    [headerView addSubview:icon3Btn];
    
    icon4Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [icon4Btn setImage:[UIImage imageNamed:@"currnetItem"] forState:UIControlStateNormal];
    [headerView addSubview:icon4Btn];
    
    commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitBtn setTitle:@"交卷" forState:UIControlStateNormal];
    commitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [headerView addSubview:commitBtn];
    
    rightItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightItemBtn setTitle:@"0" forState:UIControlStateNormal];
    rightItemBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [headerView addSubview:rightItemBtn];
    
    wrongItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [wrongItemBtn setTitle:@"0" forState:UIControlStateNormal];
    wrongItemBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [headerView addSubview:wrongItemBtn];
    
    currentItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [currentItemBtn setTitle:@"0/0" forState:UIControlStateNormal];
    currentItemBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [headerView addSubview:currentItemBtn];
    
    icon1Btn.tag = kJiaoJuanTag;
    icon4Btn.tag = kTiMuTag;
    
    [commitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [wrongItemBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightItemBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [currentItemBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    examView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    examView.delegate = self;
    examView.dataSource = self;
    examView.showsVerticalScrollIndicator = NO;
    examView.backgroundColor = [UIColor whiteColor];
    [self addSubview:examView];
    [examView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}

- (void)layoutSubviews {
    if ([self respondsToSelector:@selector(safeAreaLayoutGuide)]) {
        iPhoneXSpace = [self safeAreaInsets].bottom;
    }else{
        iPhoneXSpace = 0;
    }
    CGFloat space = 0;
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(topSpace);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(headerHeight);
    }];
    
    [icon1Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(20);
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon1Btn.mas_right).offset(0);
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    [icon2Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightItemBtn.mas_left).offset(0);
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [rightItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(icon3Btn.mas_left).offset(0);
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    
    [icon3Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wrongItemBtn.mas_left).offset(space);
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [wrongItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(icon4Btn.mas_left).offset(0);
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    
    [icon4Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(currentItemBtn.mas_left).offset(0);
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [currentItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon4Btn.mas_right).offset(0);
        make.right.equalTo(headerView).offset(-20);
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    
    //    UIEdgeInsets insets = UIEdgeInsetsMake(40, 0, 0, 0);
    [examView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom).offset(iPhoneXSpace);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    if (toolViewType == ExamToolViewTypeWrongItem) {
        icon1Btn.hidden = YES;
        commitBtn.hidden = YES;
    }
//    icon1Btn.backgroundColor = kRandomColor;
//    icon2Btn.backgroundColor = kRandomColor;
//    icon3Btn.backgroundColor = kRandomColor;
//    icon4Btn.backgroundColor = kRandomColor;
//
//    commitBtn.backgroundColor = kRandomColor;
//    rightItemBtn.backgroundColor = kRandomColor;
//    wrongItemBtn.backgroundColor = kRandomColor;
//    currentItemBtn.backgroundColor = kRandomColor;
}

- (void)updateConstraints {
   
    if (!icon4Btn.selected) {
        topSpace = 0;
        backgroundView.hidden = YES;
    }else{
        topSpace = 80;
        backgroundView.hidden = NO;
    }
    if (topSpace == 80) {
        iPhoneXSpace = 0;
    }else{
        iPhoneXSpace = [self respondsToSelector:@selector(safeAreaLayoutGuide)] ? self.safeAreaInsets.bottom : 0;
    }
    [headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(topSpace);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(headerHeight);
    }];
    
    [examView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom).offset(iPhoneXSpace);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];

    [super updateConstraints];
}

- (void)updateitemCountWith:(NSInteger)count isRight:(BOOL)right {
    if (right) {
    }else{
    }
}

- (void)cancel:(UIButton *)sender {
    icon4Btn.selected = NO;
    [self showItems:icon4Btn];
}

- (void)showItems:(UIButton *)sender {
    CGRect frame = self.frame;
    frame.origin.y = frame.size.height - headerHeight-iPhoneXSpace;
    icon4Btn.selected = NO;
    self.frame = frame;
    [self setNeedsUpdateConstraints];
}

- (void)addtarget:(id)target method:(SEL)action {
    [icon1Btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [icon4Btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [commitBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)currentItemIndex:(NSInteger)index {
    [currentItemBtn setTitle:[NSString stringWithFormat:@"%ld/%ld",index,_itemsCount] forState:UIControlStateNormal];
}

- (void)updateWrongChoiceCount:(NSInteger)count {
    [wrongItemBtn setTitle:[NSString stringWithFormat:@"%ld",count] forState:UIControlStateNormal];
    [examView reloadData];
}

- (void)updateRightChoiceCount:(NSInteger)count {
    [rightItemBtn setTitle:[NSString stringWithFormat:@"%ld",count] forState:UIControlStateNormal];
    [examView reloadData];
}

- (void)updateCurrentItemIndex:(NSString *)index {
    [currentItemBtn setTitle:index forState:UIControlStateNormal];
}

- (void)setItemsCount:(NSInteger)itemsCount {
    _itemsCount = itemsCount;
    [examView reloadData];
}

#pragma mark - delegate - datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _itemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 15;
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = [UIColor grayColor].CGColor;
    cell.layer.masksToBounds = YES;
    [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(0, 0, 30, 30);
    label.userInteractionEnabled = YES;
    [cell addSubview:label];
    YSCourseItemModel *model = _items[indexPath.row];
    label.backgroundColor = model.hasDone ? kLightGray : [UIColor clearColor];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 20, 0, 20);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(30, 30);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    __weak YSExamToolView *wkSelf = self;
    if (_rollBackBolck) {
        [wkSelf currentItemIndex:indexPath.row+1];
        _rollBackBolck(indexPath.row);
    }
}

@end
