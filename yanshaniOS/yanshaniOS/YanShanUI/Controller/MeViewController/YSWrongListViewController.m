//
//  YSWrongListViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2018/9/27.
//  Copyright © 2018 jiandai. All rights reserved.
//

#import "YSWrongListViewController.h"
#import "YSExaminationItemViewController.h"
#import "YSCourseManager.h"
#import "YSCourseItemModel.h"
#import "YSExamToolView.h"

@interface YSWrongListViewController()<UIPageViewControllerDelegate,YSExaminationItemViewControllerDelegate>
{
    NSMutableArray *vcs;
    NSArray *courseItems;
    UIPageViewController *pageVC;
    CGFloat safeAreaHeight;
    YSExamToolView *toolView;
    NSInteger rightCount;
    NSInteger wrongCount;
    UIButton *beginTestBtn;
    NSDate *beginDate;
}

@end

@implementation YSWrongListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self beginTest:beginTestBtn];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {

}

- (void)setCoursesData:(NSArray *)datas {
    courseItems = [NSArray arrayWithArray:datas];
}

#pragma mark - config view controller

- (void)configViewControllerParameter {
    vcs = [NSMutableArray arrayWithCapacity:0];

}

- (void)configView {
    
}

- (void)backViewController:(UIButton *)sender {

    [self.navigationController popViewControllerAnimated:YES];
}


- (void)beginTest:(UIButton *)sender {
    
    vcs = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < courseItems.count; i++) {
        YSExaminationItemViewController *vc = [[YSExaminationItemViewController alloc] init];
        vc.index = i;
        vc.delegate = self;
        [vcs addObject:vc];
        if (i == courseItems.count - 1) {
            vc.itemType = RightItemTypeFinished;
        }
        YSCourseItemModel *model = courseItems[i];
        vc.itemModel = model;
    }
    if (vcs.count) {
        pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey:@10}];
        pageVC.dataSource = self;
        [self addChildViewController:pageVC];
        [self.view addSubview:pageVC.view];
        [pageVC didMoveToParentViewController:self];
        pageVC.view.backgroundColor = [UIColor whiteColor];
        [pageVC setViewControllers:@[vcs[_selectIndex]] direction:(UIPageViewControllerNavigationDirectionForward) animated:YES completion:^(BOOL finished) {
            
        }];
    }
    CGRect toolFrame = self.view.bounds;
    if ([self.view respondsToSelector:@selector(safeAreaLayoutGuide)]) {
        safeAreaHeight = 40 + [self.view safeAreaInsets].bottom;
    }else if ([UIViewController instancesRespondToSelector:@selector(bottomLayoutGuide)]) {
        safeAreaHeight = 40;
    }
    toolFrame.origin.y = toolFrame.size.height - safeAreaHeight;
    toolView = [[YSExamToolView alloc] initWithFrame:toolFrame withType:ExamToolViewTypeWrongItem];
    [toolView addtarget:self method:@selector(jiaojuan:)];
    [self.view addSubview:toolView];
    [toolView updateCurrentItemIndex:[NSString stringWithFormat:@"%ld/%ld",_selectIndex+1,courseItems.count]];
    toolView.itemsCount = courseItems.count;
    toolView.items = courseItems;
    __weak UIPageViewController *wkPVC = pageVC;
    __weak NSArray *wkVCS = vcs;
    toolView.rollBackBolck = ^(NSInteger itemIndex) {
        [wkPVC setViewControllers:@[wkVCS[itemIndex]]
                        direction:(UIPageViewControllerNavigationDirectionForward)
                         animated:YES completion:nil];
    };
    beginDate = [NSDate dateWithTimeIntervalSinceNow:0];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((YSExaminationItemViewController *)viewController).index;
    if ((index == 0) || (index == NSNotFound)) {
        [toolView updateCurrentItemIndex:[NSString stringWithFormat:@"%ld/%ld",index+1,courseItems.count]];
        return nil;
    }
    index -= 1;
    [toolView updateCurrentItemIndex:[NSString stringWithFormat:@"%ld/%ld",index+1,courseItems.count]];
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
    [toolView updateCurrentItemIndex:[NSString stringWithFormat:@"%ld/%ld",index+1,courseItems.count]];
    return [vcs objectAtIndex:index];
}

- (void)selectAnwser:(YSExaminationItemViewController *)examinationItemController {

    if (examinationItemController.isRight) {
        rightCount++;
        [toolView updateRightChoiceCount:rightCount];
        if (_doRightBlock) {
            _doRightBlock(examinationItemController.itemModel);
        }
    }else{
        wrongCount++;
        [toolView updateWrongChoiceCount:wrongCount];
    }
    if (rightCount + wrongCount == vcs.count) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您已经答完全部题目!!!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        [alertC addAction:action];
        [alertC addAction:cancelAction];
        [self.navigationController presentViewController:alertC animated:YES completion:nil];
    }
    if (examinationItemController.itemType == RightItemTypeFinished) {
        return;
    }
    if (examinationItemController.isRight) {
        [pageVC setViewControllers:@[vcs[examinationItemController.index+1]]
                         direction:UIPageViewControllerNavigationDirectionForward
                          animated:YES completion:nil];
        [toolView updateCurrentItemIndex:[NSString stringWithFormat:@"%ld/%ld",examinationItemController.index+2,courseItems.count]];
    }
    
}

- (void)addNavigationItems {
    [self addPopViewControllerButtonWithTarget:self action:@selector(backViewController:)];
}

@end
