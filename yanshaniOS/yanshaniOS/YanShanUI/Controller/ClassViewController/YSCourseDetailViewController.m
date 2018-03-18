//
//  YSClassViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2017/12/31.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSCourseDetailViewController.h"
#import "YSExaminationItemViewController.h"
#import "YSCourseManager.h"
#import "YSCourseItemModel.h"

@interface YSCourseDetailViewController ()<UIPageViewControllerDelegate,YSExaminationItemViewControllerDelegate>
{
    NSMutableArray *vcs;
    NSArray *courseItems;
    UIPageViewController *pageVC;
}
@end

@implementation YSCourseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[YSCourseManager sharedCourseManager] mergeCourseItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCoursesData:(NSArray *)datas {
    courseItems = [NSArray arrayWithArray:datas];
}

#pragma mark - config view controller

- (void)configViewControllerParameter {
    vcs = [NSMutableArray arrayWithCapacity:0];
    self.title = @"课程练习";
}

- (void)configView {
    CGRect frame = self.view.bounds;
    frame.size.height = 300;
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = @"视频正在加载中...";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    UIWebView *WebView = [[UIWebView alloc] initWithFrame:frame];
    WebView.backgroundColor = [UIColor clearColor];
    [WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://v.qq.com/iframe/player.html?vid=a0514mkz1vk&tiny=0&auto=0"]]];
    [self.view addSubview:WebView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"开始答题" forState:UIControlStateNormal];
    [btn setBackgroundColor:kBlueColor];
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(beginTest:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-170);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(40);
    }];
    
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
        pageVC.view.backgroundColor = [UIColor redColor];
        [pageVC setViewControllers:@[vcs[0]] direction:(UIPageViewControllerNavigationDirectionForward) animated:YES completion:^(BOOL finished) {
            
        }];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((YSExaminationItemViewController *)viewController).index;
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index -= 1;
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
    return [vcs objectAtIndex:index];
}


- (void)configContainer {
    
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
    
}

- (void)addNavigationItems {
    [self addPopViewControllerButtonWithTarget:self action:@selector(backViewController:)];
}

@end
