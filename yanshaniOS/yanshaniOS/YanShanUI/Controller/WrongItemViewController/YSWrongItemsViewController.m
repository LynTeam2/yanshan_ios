//
//  YSWrongItemsViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2018/2/25.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSWrongItemsViewController.h"
#import "YSExaminationItemViewController.h"
#import "YSCourseManager.h"
#import "YSCourseItemModel.h"
#import "YSExamToolView.h"

@interface YSWrongItemsViewController ()<UIPageViewControllerDelegate,YSExaminationItemViewControllerDelegate>
{
    NSMutableArray *vcs;
    UIPageViewController *pageVC;
    CGFloat safeAreaHeight;
    YSExamToolView *toolView;
    NSInteger wrongCount;
    NSInteger rightCount;
    NSArray *wrongItems;

}
@end

@implementation YSWrongItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGRect toolFrame = self.view.bounds;
    if ([self.view respondsToSelector:@selector(safeAreaLayoutGuide)]) {
        if (@available(iOS 11.0, *)) {
            safeAreaHeight = 40 + [self.view safeAreaInsets].bottom;
        }
    }else if ([UIViewController instancesRespondToSelector:@selector(bottomLayoutGuide)]) {
        safeAreaHeight = 40;
    }
    toolFrame.origin.y = toolFrame.size.height - safeAreaHeight;
    toolView.frame = toolFrame;
    if (nil == toolView) {
        toolView = [[YSExamToolView alloc] initWithFrame:toolFrame withType:ExamToolViewTypeWrongItem];
        [toolView addtarget:self method:@selector(jiaojuan:)];
        [self.view addSubview:toolView];
        [toolView updateCurrentItemIndex:[NSString stringWithFormat:@"%d/%ld",1,vcs.count]];
        toolView.itemsCount = vcs.count;
        toolView.items = wrongItems;
        __weak UIPageViewController *wkPVC = pageVC;
        __weak NSArray *wkvcs = vcs;
        toolView.rollBackBolck = ^(NSInteger itemIndex) {
            [wkPVC setViewControllers:@[wkvcs[itemIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        };
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configViewControllerParameter {
    self.title = @"我的错题";
}

- (void)configView {
   
}

- (void)addNavigationItems {
    [self addPopViewControllerButtonWithTarget:self action:@selector(backViewController:)];
}

#pragma mark - class method

- (void)jiaojuan:(UIButton *)sender {
    if (!vcs.count) {
        return;
    }
    if(sender.tag == kTiMuTag){
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
//        [UIView animateWithDuration:0.5 animations:^{
//            toolView.frame = toolFrame;
//        }];
    }
}


- (void)setWrongItemsData:(NSArray *)items {
    wrongItems = [items copy];
    vcs = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < items.count; i++) {
        YSExaminationItemViewController *vc = [[YSExaminationItemViewController alloc] init];
        vc.index = i;
        vc.delegate = self;
        [vcs addObject:vc];
        if (i == items.count - 1) {
            vc.itemType = RightItemTypeFinished;
        }
        YSCourseItemModel *model = items[i];
        vc.itemModel = model;
    }

    if (vcs.count) {
        pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey:@10}];
        pageVC.dataSource = self;
        [self addChildViewController:pageVC];
        [self.view addSubview:pageVC.view];
        [self.view sendSubviewToBack:pageVC.view];
        [pageVC didMoveToParentViewController:self];
        pageVC.view.backgroundColor = [UIColor whiteColor];
        [pageVC setViewControllers:@[vcs[0]]
                         direction:(UIPageViewControllerNavigationDirectionForward)
                          animated:YES completion:nil];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((YSExaminationItemViewController *)viewController).index;
    if ((index == 0) || (index == NSNotFound)) {
        [toolView updateCurrentItemIndex:[NSString stringWithFormat:@"%ld/%ld",index+1,vcs.count]];
        return nil;
    }
    index -= 1;
    [toolView updateCurrentItemIndex:[NSString stringWithFormat:@"%ld/%ld",index+1,vcs.count]];
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
    [toolView updateCurrentItemIndex:[NSString stringWithFormat:@"%ld/%ld",index+1,vcs.count]];
    return [vcs objectAtIndex:index];
}

- (void)selectAnwser:(YSExaminationItemViewController *)examinationItemController {
    if (examinationItemController.itemType == RightItemTypeFinished) {
        return;
    }
    if (examinationItemController.isRight) {
        [pageVC setViewControllers:@[vcs[examinationItemController.index+1]]
                         direction:UIPageViewControllerNavigationDirectionForward
                          animated:YES completion:nil];
    }
    if (examinationItemController.isRight) {
        rightCount++;
        //        [examModel saveRightItem:examinationItemController.itemModel];
        [toolView updateRightChoiceCount:rightCount];
    }else{
        wrongCount++;
        //        [examModel saveWrongItem:examinationItemController.itemModel];
        [toolView updateWrongChoiceCount:wrongCount];
    }
}

@end
