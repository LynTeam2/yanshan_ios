//
//  YSExaminationViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2017/12/30.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSExaminationViewController.h"
#import "YSExaminationItemViewController.h"
#import "YSExaminationResultView.h"
#import "YSExamManager.h"
#import "YSExaminationItemModel.h"

#define kJiaoJuanTag     2000
#define kTiMuTag         2001

@interface YSExaminationViewController ()<UIPageViewControllerDataSource,YSExaminationItemViewControllerDelegate>
{
    NSMutableArray *vcs;
    NSMutableArray *testItems;
    YSExaminationToolView *toolView;
    YSExaminationResultView *resultView;
    UIView *backgroundView;
    NSInteger wrongCount;
    NSInteger rightCount;
    NSInteger timeCount;
    NSTimer *examTimer;
    NSDictionary *examDic;
    BOOL beginExam;
    YSExaminationItemModel *examModel;
}
@end

@implementation YSExaminationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    wrongCount = 0;
    rightCount = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - config view controller

- (void)configViewControllerParameter {
    self.title = @"模拟考试";
    self.view.backgroundColor = [UIColor whiteColor];
    [self addPopViewControllerButtonWithTarget:self action:@selector(backViewController:)];
}

- (void)backViewController:(UIButton *)sender {
    if (resultView || !beginExam) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self jiaojuan:nil];
    }
}

- (void)configView {
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headericon"]];
    [self.view addSubview:iconView];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(25);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"用户名";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(iconView.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(160, 20));
    }];
    
    NSDictionary *dic = [[YSFileManager sharedFileManager] JSONSerializationJsonFile:@"exam.json" atDocumentName:@"exam"];
    if (![dic objectForKey:@"exams"]) {
        return;
    }
    examDic = [[NSArray arrayWithArray:dic[@"exams"]] lastObject];
    NSString *examDuration = [NSString stringWithFormat:@"%@分钟",examDic[@"examDuration"]];
    NSString *standard = [NSString stringWithFormat:@"%@",examDic[@"standard"]];
    NSArray *titles = @[
  @{@"title1":@"考试类型",@"title2":examDic[@"examType"]},
  @{@"title1":@"考试时间",@"title2":examDuration},
  @{@"title1":@"合格标准",@"title2":standard},
  @{@"title1":@"出题标准",@"title2":standard}];
    
    for (int i = 0; i < titles.count; i++) {
        NSDictionary *dic = titles[i];
        UILabel *label1 = [[UILabel alloc] init];
        label1.textAlignment = NSTextAlignmentRight;
        label1.text = dic[@"title1"];
        [self.view addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] init];
        label2.text = dic[@"title2"];
        label2.textColor = [UIColor grayColor];
        [self.view addSubview:label2];
        
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view.mas_centerX).offset(-20);
            make.top.equalTo(self.view).offset(140 + (40)*i);
            make.size.mas_equalTo(CGSizeMake(160, 20));
        }];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_centerX).offset(20);
            make.top.equalTo(self.view).offset(140 + (40)*i);
            make.size.mas_equalTo(CGSizeMake(160, 20));
        }];
    }
   
    UILabel *notiLabel = [[UILabel alloc] init];
    notiLabel.text = [NSString stringWithFormat:@"温馨提示:%@",examDic[@"introduction"]];
    notiLabel.numberOfLines = 3;
    notiLabel.textColor = [UIColor grayColor];
    notiLabel.adjustsFontSizeToFitWidth = YES;
    notiLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:notiLabel];
    
    [notiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-170);
        make.left.equalTo(self.view).offset(50);
        make.right.equalTo(self.view).offset(-50);
        make.height.mas_equalTo(80);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"开始考试" forState:UIControlStateNormal];
    [btn setBackgroundColor:kBlueColor];
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(beginTest:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-70);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(40);
    }];
    
}

- (void)configContainer {
    
}

- (void)addNavigationItems {
    
}

- (void)countTime:(NSTimer *)timer {
    timeCount--;
    self.title = [self transformSectionToFormmaterTime:timeCount];
    if (timeCount <= 0) {
        [examTimer invalidate];
        examTimer = nil;
        [self showExaminationResultView];
    }
}

- (void)beginTest:(UIButton *)sender {
    self.title = [NSString stringWithFormat:@"倒计时 %@:00",examDic[@"examDuration"]];
    beginExam = YES;
    examModel = [[YSExaminationItemModel alloc] init];
    [examTimer invalidate];
    timeCount = [examDic[@"examDuration"] integerValue]*60;
    examTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTime:) userInfo:nil repeats:YES];
    
    testItems = [NSMutableArray arrayWithCapacity:0];
    vcs = [NSMutableArray arrayWithCapacity:0];
    
    NSArray *jsonArray = @[@"simplechoice.json",@"multiplechoice.json",@"truefalse.json"];
    
    for (int i = 0; i < jsonArray.count; i++) {
        NSDictionary *jsonDic = [[YSFileManager sharedFileManager] JSONSerializationJsonFile:jsonArray[i] atDocumentName:@"question"];
        NSArray *mcArrary = [NSArray arrayWithArray:[YSCourseItemModel arrayOfModelsFromDictionaries:[jsonDic objectForKey:@"questions"] error:nil]];
        if (mcArrary.count) {
            [testItems addObjectsFromArray:mcArrary];
        }
    }
    NSString *Str = examDic[@"role"];
    Str = [Str stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    NSData *Data = [Str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *roleDic = [NSJSONSerialization JSONObjectWithData:Data options:NSJSONReadingMutableContainers error:&err];
    NSMutableDictionary *ajTypeDic = [NSMutableDictionary dictionaryWithDictionary:roleDic[@"ajType"]];
    NSMutableDictionary *questionTypeDic = [NSMutableDictionary dictionaryWithDictionary:roleDic[@"questionType"]];
    NSMutableDictionary *difficultyDic = [NSMutableDictionary dictionaryWithDictionary:roleDic[@"difficulty"]];
    NSArray *arr = [self randomArray:testItems withCount:testItems.count];
    for (int i = 0; i < arr.count; i++) {
        YSCourseItemModel *model = arr[i];
        NSString *aj = model.ajType;
        NSString *di = model.difficulty;
        NSString *qu = model.questionType;
        
        if (ajTypeDic.allKeys.count == 0 || difficultyDic.allKeys.count == 0 || questionTypeDic.allKeys.count == 0) {
            break;
        }
        if ([ajTypeDic objectForKey:aj] && [difficultyDic objectForKey:di] && [questionTypeDic objectForKey:qu]) {
            
            [testItems addObject:model];
            if ([[ajTypeDic objectForKey:aj] intValue] == 1) {
                [ajTypeDic removeObjectForKey:aj];
            }else{
                [ajTypeDic setObject:[NSString stringWithFormat:@"%d",[[ajTypeDic objectForKey:aj] intValue]-1] forKey:aj];
            }
            if ([[difficultyDic objectForKey:di] intValue] == 1) {
                [difficultyDic removeObjectForKey:di];
            }else{
                [difficultyDic setObject:[NSString stringWithFormat:@"%d",[[difficultyDic objectForKey:di] intValue]-1] forKey:di];
            }
            if ([[questionTypeDic objectForKey:qu] intValue] == 1) {
                [questionTypeDic removeObjectForKey:qu];
            }else{
                [questionTypeDic setObject:[NSString stringWithFormat:@"%d",[[questionTypeDic objectForKey:qu] intValue]-1] forKey:qu];
            }
        }
    }
    if (testItems.count == 0) {
        return;
    }
    UIPageViewController *pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey:@10}];
    pageVC.dataSource = self;
    [self addChildViewController:pageVC];
    [self.view addSubview:pageVC.view];
    [pageVC didMoveToParentViewController:self];
    
    for (int i = 0; i < testItems.count; i++) {
        YSExaminationItemViewController *vc = [[YSExaminationItemViewController alloc] init];
        vc.index = i;
        vc.delegate = self;
        [vcs addObject:vc];
        if (i == testItems.count - 1) {
            vc.itemType = RightItemTypeFinished;
        }
        YSCourseItemModel *model = testItems[i];
        vc.itemModel = model;
    }
    
    [pageVC setViewControllers:@[vcs[0]] direction:(UIPageViewControllerNavigationDirectionForward) animated:YES completion:^(BOOL finished) {
        
    }];
    
    backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    backgroundView.hidden = YES;
    backgroundView.backgroundColor = kRGBColor(0, 0, 0, 0.5);
    [self.view addSubview:backgroundView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel:)];
    [backgroundView addGestureRecognizer:tap];
    CGRect toolFrame = self.view.bounds;
    toolFrame.origin.y = toolFrame.size.height - 40;
    toolView = [[YSExaminationToolView alloc] initWithFrame:toolFrame];
    [toolView addtarget:self method:@selector(jiaojuan:)];
    [self.view addSubview:toolView];
    [toolView updateCurrentItemIndex:[NSString stringWithFormat:@"%d/%ld",1,testItems.count]];
    toolView.itemsCount = testItems.count;
}

- (NSArray *)randomArray:(NSMutableArray *)items withCount:(NSInteger)count {
    if (items.count < count) {
        count = items.count;
    }
    //随机数产生结果
    NSMutableArray *resultArray=[[NSMutableArray alloc] initWithCapacity:0];
    //随机数个数
    for (int i=0; i < count; i++) {
        int t = arc4random()%items.count;
        resultArray[i]=items[t];
        items[t]=[items lastObject]; //为更好的乱序，故交换下位置
        [items removeLastObject];
    }
    return resultArray;
}


- (void)cancel:(UITapGestureRecognizer *)tap {
    backgroundView.hidden = YES;
    CGRect toolFrame = self.view.bounds;
    toolFrame.origin.y = toolFrame.size.height - 40;
    toolView.frame = toolFrame;
}

- (NSString *)transformSectionToFormmaterTime:(NSInteger)seconds {
    
    long second = seconds%60;
    long minus = seconds/60;
    NSString *timeString =[NSString stringWithFormat:@"倒计时:%02ld:%02ld",minus,second];
    return timeString;
}

- (void)jiaojuan:(UIButton *)sender {
     if(sender.tag == kTiMuTag){
        CGRect toolFrame = self.view.bounds;
        if (toolView.frame.origin.y == 80) {
            toolFrame.origin.y = toolFrame.size.height - 40;
            backgroundView.hidden = YES;
        }else{
            toolFrame.origin.y = 80;
            toolFrame.size.height -= 80;
            backgroundView.hidden = NO;
        }
        [UIView animateWithDuration:0.5 animations:^{
            toolView.frame = toolFrame;
        }];
        sender.selected = !sender.selected;
     }else{
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"交卷" message:@"请确认所有试题做完后在交卷！！！" preferredStyle:UIAlertControllerStyleAlert];
         __weak YSExaminationViewController *weakSelf = self;
         UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认交卷" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [weakSelf showExaminationResultView];
         }];
         UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"继续答题" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         }];
         [alertController addAction:action1];
         [alertController addAction:action2];
         [self.navigationController presentViewController:alertController animated:YES completion:nil];
     }
}

- (void)showExaminationResultView {
    if (nil == resultView) {
        resultView = [[YSExaminationResultView alloc] initWithFrame:self.view.bounds];
    }
    [resultView addTarget:self andSEL:@selector(showExamResult:)];
    [self.view addSubview:resultView];
    [examTimer invalidate];
    examTimer = nil;
    NSString *examDuration = [NSString stringWithFormat:@"%@分钟",examDic[@"examDuration"]];
    [resultView updateScoreValue:[NSString stringWithFormat:@"%ld",rightCount] costTime:examDuration];
    if (rightCount >= [examDic[@"standard"] integerValue]) {
        [resultView userPassTheExam:YES];
        examModel.examJudgement = @"成绩合格";
    }else{
        [resultView userPassTheExam:NO];
        examModel.examJudgement = @"成绩不合格";
    }
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    NSString *current = [formatter stringFromDate:now];
    examModel.rightItemCount = rightCount;
    examModel.wrongItemCount = testItems.count - rightCount;
    examModel.examScore = rightCount;
    examModel.dateString = current;
    [[YSExamManager sharedExamManager] saveCurrentExam:examModel];
}

- (void)showExamResult:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
//    UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    tab.tabBar.hidden = NO;
//    tab.selectedIndex = 1;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((YSExaminationItemViewController *)viewController).index;
    if ((index == 0) || (index == NSNotFound)) {
        [toolView updateCurrentItemIndex:[NSString stringWithFormat:@"%ld/%ld",index+1,testItems.count]];
        return nil;
    }
    index -= 1;
    [toolView updateCurrentItemIndex:[NSString stringWithFormat:@"%ld/%ld",index+1,testItems.count]];
    return [vcs objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((YSExaminationItemViewController *)viewController).index;
    if (index == NSNotFound) {
        return nil;
    }
    index += 1;
    if (index == [vcs count]) {
        return nil;
    }
    [toolView updateCurrentItemIndex:[NSString stringWithFormat:@"%ld/%ld",index+1,testItems.count]];
    return [vcs objectAtIndex:index];
}

- (void)selectAnwser:(YSExaminationItemViewController *)examinationItemController {
    NSLog(@"%ld -- %ld", examinationItemController.index,examinationItemController.isRight);
    if (examinationItemController.isRight) {
        rightCount++;
        [examModel saveRightItem:examinationItemController.itemModel];
        [toolView updateRightChoiceCount:rightCount];
    }else{
        wrongCount++;
        [examModel saveWrongItem:examinationItemController.itemModel];
        [toolView updateWrongChoiceCount:wrongCount];
    }
}

@end

@implementation YSExaminationToolView
{
    UICollectionView *examView;
    UIView *headerView;
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
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
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
    
    title1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [title1Btn setTitle:@"交卷" forState:UIControlStateNormal];
    [headerView addSubview:title1Btn];
    
    rightItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightItemBtn setTitle:@"0" forState:UIControlStateNormal];
    [headerView addSubview:rightItemBtn];
    
    wrongItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [wrongItemBtn setTitle:@"0" forState:UIControlStateNormal];
    [headerView addSubview:wrongItemBtn];
    
    currentItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [currentItemBtn setTitle:@"0/0" forState:UIControlStateNormal];
    [headerView addSubview:currentItemBtn];
    
    icon1Btn.tag = kJiaoJuanTag;
    icon4Btn.tag = kTiMuTag;
    [title1Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    
    [icon1Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(20);
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [icon2Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(155);
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [icon3Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(220);
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [icon4Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView).offset(-80);
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [title1Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon1Btn.mas_right).offset(0);
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    [rightItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon2Btn.mas_right).offset(0);
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    [wrongItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon3Btn.mas_right).offset(0);
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    [currentItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon4Btn.mas_right).offset(0);
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(40, 0, 0, 0);
    [examView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(insets);
    }];
}

- (void)updateitemCountWith:(NSInteger)count isRight:(BOOL)right {
    if (right) {
    }else{
    }
}

- (void)addtarget:(id)target method:(SEL)action {
    [icon1Btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [icon4Btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [title1Btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)currentItemIndex:(NSInteger)index {
    [currentItemBtn setTitle:[NSString stringWithFormat:@"%ld",index] forState:UIControlStateNormal];
}

- (void)updateWrongChoiceCount:(NSInteger)count {
    [wrongItemBtn setTitle:[NSString stringWithFormat:@"%ld",count] forState:UIControlStateNormal];
}

- (void)updateRightChoiceCount:(NSInteger)count {
    [rightItemBtn setTitle:[NSString stringWithFormat:@"%ld",count] forState:UIControlStateNormal];
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
    [cell addSubview:label];
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

@end
