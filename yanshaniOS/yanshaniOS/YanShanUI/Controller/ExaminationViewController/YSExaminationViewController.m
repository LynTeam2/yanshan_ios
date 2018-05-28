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
#import "YSExamToolView.h"

@interface YSExaminationViewController ()<UIPageViewControllerDataSource,YSExaminationItemViewControllerDelegate>
{
    NSMutableArray *vcs;
    NSMutableArray *testItems;
    YSExamToolView *toolView;
    YSExaminationResultView *resultView;
    YSExaminationItemModel *examItemModel;
    NSTimer *examTimer;
    NSDictionary *examDic;
    BOOL beginExam;
    NSInteger wrongCount;
    NSInteger rightCount;
    NSInteger timeCount;
    CGFloat safeAreaHeight;
    NSDictionary *roleDic;
}
@end

@implementation YSExaminationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    wrongCount = 0;
    rightCount = 0;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - config view controller

- (void)configViewControllerParameter {
    self.title = @"测评考试";
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
    NSString *examDuration = [NSString stringWithFormat:@"%ld分钟",_examModel.examDuration];
    
    NSString *standard = [NSString stringWithFormat:@"%ld",_examModel.standard];

    NSString *itemCount = @"0";
    if (_examModel) {
        itemCount = [NSString stringWithFormat:@"%ld",(_examModel.scList.count+_examModel.mcList.count+_examModel.tfList.count)];
    }
    NSArray *titles = @[
  @{@"title1":@"考试类型",@"title2":_examModel.examType},
  @{@"title1":@"考试时间",@"title2":examDuration},
  @{@"title1":@"合格标准",@"title2":standard},
  @{@"title1":@"出题标准",@"title2":itemCount}];
    
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
    notiLabel.text = [NSString stringWithFormat:@"温馨提示:%@",_examModel.introduction];
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

#pragma mark - creat examination paper

//- (NSArray *)selectExaminationPaperItems:(YSExamModel *)model {
//
//}

#pragma mark - class method

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
    
    NSString *warnText = @"";
    for (NSDictionary *dic in _examModel.courseList) {
        NSString *courseId = dic[@"id"];
        BOOL hasDone = [[YSCourseManager sharedCourseManager] queryCourseIsHasDoneWithId:courseId];
        if (!hasDone) {
            if (warnText.length == 0) {
                
                warnText = [NSString stringWithFormat:@"你还有\n%@:%@",dic[@"ajType"],dic[@"courseName"]];
            }else{
                warnText = [NSString stringWithFormat:@"%@,\n%@:%@",warnText,dic[@"ajType"],dic[@"courseName"]];
            }
        }
    }
    if(warnText.length){
        warnText = [warnText stringByAppendingString:@"\n课时未完成"];
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:warnText preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertC addAction:action];
        [self.navigationController presentViewController:alertC animated:YES completion:nil];
        return;
    }
    self.title = [NSString stringWithFormat:@"倒计时 %ld:00",_examModel.examDuration];
    beginExam = YES;
    examItemModel = [[YSExaminationItemModel alloc] init];
    [examTimer invalidate];
    timeCount = _examModel.examDuration*60;
    examTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTime:) userInfo:nil repeats:YES];
    
    testItems = [NSMutableArray arrayWithCapacity:0];
    vcs = [NSMutableArray arrayWithCapacity:0];
    
    NSInteger sumCount = _examModel.scList.count+_examModel.mcList.count+_examModel.tfList.count;
    
    int tfCount = _examModel.tfList.count;
    int scCount = _examModel.scList.count;
    int mcCount = _examModel.mcList.count;
    
    NSMutableArray *mTFArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *mSCArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *mMCArray = [NSMutableArray arrayWithCapacity:0];
    
    NSArray *tfItems = [self randomArray:_examModel.tfList withCount:tfCount];
    NSArray *scItems = [self randomArray:_examModel.scList withCount:scCount];
    NSArray *mcItems = [self randomArray:_examModel.mcList withCount:mcCount];
    
    [mTFArray addObjectsFromArray:[tfItems subarrayWithRange:NSMakeRange(0, _examModel.examTfCount)]];
    [mSCArray addObjectsFromArray:[scItems subarrayWithRange:NSMakeRange(0, _examModel.examScCount)]];
    [mMCArray addObjectsFromArray:[mcItems subarrayWithRange:NSMakeRange(0, _examModel.examMcCount)]];
    
    [testItems addObjectsFromArray:[YSCourseItemModel arrayOfModelsFromDictionaries:mTFArray error:nil]];
    [testItems addObjectsFromArray:[YSCourseItemModel arrayOfModelsFromDictionaries:mSCArray error:nil]];
    [testItems addObjectsFromArray:[YSCourseItemModel arrayOfModelsFromDictionaries:mMCArray error:nil]];

    if (testItems.count == 0) {
        return;
    }
    UIPageViewController *pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey:@10}];
    pageVC.dataSource = self;
    [self addChildViewController:pageVC];
    [self.view addSubview:pageVC.view];
    [pageVC didMoveToParentViewController:self];
    examItemModel.items = [testItems copy];
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
    
    CGRect toolFrame = self.view.bounds;
    if ([self.view respondsToSelector:@selector(safeAreaLayoutGuide)]) {
        safeAreaHeight = 40 + [self.view safeAreaInsets].bottom;
    }else if ([UIViewController instancesRespondToSelector:@selector(bottomLayoutGuide)]) {
        safeAreaHeight = 40;
    }
    toolFrame.origin.y = toolFrame.size.height - safeAreaHeight;
    toolView = [[YSExamToolView alloc] initWithFrame:toolFrame withType:ExamToolViewTypeExam];
    [toolView addtarget:self method:@selector(jiaojuan:)];
    [self.view addSubview:toolView];
    [toolView updateCurrentItemIndex:[NSString stringWithFormat:@"%d/%ld",1,testItems.count]];
    toolView.itemsCount = testItems.count;
    toolView.items = testItems;
    __weak UIPageViewController *wkPageVC = pageVC;
    __weak NSArray *wkvcs = vcs;
    toolView.rollBackBolck = ^(NSInteger itemIndex) {
        [wkPageVC setViewControllers:@[wkvcs[itemIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    };
}


/**
 @brief 打乱数据顺序，随机

 @param items 试题库
 @param count 抽取的个数
 @return 打乱后的试题库
 */
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

- (NSString *)transformSectionToFormmaterTime:(NSInteger)seconds {
    
    long second = seconds%60;
    long minus = seconds/60;
    NSString *timeString =[NSString stringWithFormat:@"倒计时:%02ld:%02ld",minus,second];
    return timeString;
}

- (void)jiaojuan:(UIButton *)sender {
     if(sender.tag == kTiMuTag){
//         CGRect toolFrame = self.view.bounds;
//         if (toolView.frame.origin.y == 80) {
//             toolFrame.origin.y = toolFrame.size.height - safeAreaHeight;
//         }else{
//             toolFrame.origin.y = 80;
//             toolFrame.size.height -= 80;
//         }
//         [UIView animateWithDuration:0.5 animations:^{
//             toolView.frame = toolFrame;
//         }];
         CGRect toolFrame = self.view.bounds;
         if (sender.selected) {
             toolFrame.origin.y = toolFrame.size.height - safeAreaHeight;
         }else{
             //            toolFrame.origin.y = 80;
             //            toolFrame.size.height -= 80;
         }
         toolView.frame = toolFrame;
         sender.selected = !sender.selected;
         [toolView setNeedsUpdateConstraints];
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
    NSString *examDuration = [NSString stringWithFormat:@"%ld分钟",_examModel.examDuration];
    [resultView updateScoreValue:[NSString stringWithFormat:@"%ld",rightCount] costTime:examDuration];
    if (rightCount >= _examModel.standard) {
        [resultView userPassTheExam:YES];
        examItemModel.examJudgement = @"成绩合格";
    }else{
        [resultView userPassTheExam:NO];
        examItemModel.examJudgement = @"成绩不合格";
    }
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    NSString *current = [formatter stringFromDate:now];
    examItemModel.rightItemCount = rightCount;
    examItemModel.wrongItemCount = [examItemModel allWrongItems].count;
    examItemModel.examScore = rightCount;
    examItemModel.dateString = current;
    [[YSExamManager sharedExamManager] saveCurrentExam:examItemModel];
}

- (void)showExamResult:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - pageviewcontroller delegate

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

#pragma mark - YSExaminationItemViewController delegate

- (void)selectAnwser:(YSExaminationItemViewController *)examinationItemController {
    NSLog(@"%ld -- %d", examinationItemController.index,examinationItemController.isRight);
    for (YSCourseItemModel *item in testItems) {
        if ([item.question isEqual:examinationItemController.itemModel.question]) {
            item.hasDone = YES;
        }
    }
    if (examinationItemController.isRight) {
        rightCount++;
        [examItemModel saveRightItem:examinationItemController.itemModel];
        [toolView updateRightChoiceCount:rightCount];
    }else{
        wrongCount++;
        [examItemModel saveWrongItem:examinationItemController.itemModel];
        [toolView updateWrongChoiceCount:wrongCount];
    }
}

@end

