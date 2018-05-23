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
#import <WebKit/WebKit.h>
#import "YSExamToolView.h"

@interface YSCourseDetailViewController ()<UIPageViewControllerDelegate,YSExaminationItemViewControllerDelegate,WKNavigationDelegate,WKUIDelegate,UIWebViewDelegate>
{
    NSMutableArray *vcs;
    NSArray *courseItems;
    UIPageViewController *pageVC;
    UIWebView *webView;
    CGFloat safeAreaHeight;
    YSExamToolView *toolView;
    NSInteger rightCount;
    NSInteger wrongCount;
    UIButton *beginTestBtn;
}
@end

@implementation YSCourseDetailViewController

- (void)loadView {
//    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    webView.delegate = self;
    self.view = webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_model) {
        [self beginTest:beginTestBtn];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[YSCourseManager sharedCourseManager] mergeCourseItem];
    
    if (_model) {
        BOOL hasDone = YES;
        for (YSCourseItemModel *tmp in courseItems) {
            if (tmp.hasDone == NO) {
                hasDone = NO;
            }
        }
        if (hasDone) {
            [[YSCourseManager sharedCourseManager] saveHasDoneCourseId:[_model toDictionary]];
        }
    }
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
    if (_model) {
        self.title = @"课程练习";
    }else{
        self.title = @"专项练习";
    }
}

- (void)configView {
    CGRect frame = self.view.bounds;
    frame.size.height = 300;
    if (_model.courseType == CourseContentTypeVideo) {
        NSString *url = [[NSBundle mainBundle] pathForResource:@"video" ofType:@"html"];
        url = [NSString stringWithFormat:@"%@?url=%@",url,_model.video];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }else if (_model.courseType == CourseContentTypeArtical) {
        [webView loadHTMLString:_model.content baseURL:nil];
    }else{
//        [webView loadHTMLString:@"" baseURL:nil];
    }
    
    beginTestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [beginTestBtn setTitle:@"开始答题" forState:UIControlStateNormal];
    [beginTestBtn setBackgroundColor:kBlueColor];
    [self.view addSubview:beginTestBtn];
    
    if (!_model) {
        beginTestBtn.hidden = YES;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    [beginTestBtn addTarget:self action:@selector(beginTest:) forControlEvents:UIControlEventTouchUpInside];
    
    [beginTestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-170);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(40);
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.view makeToast:@"数据加载失败" duration:2.0 position:@"center"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.view makeToast:@"数据加载失败" duration:2.0 position:@"center"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    [toolView updateCurrentItemIndex:[NSString stringWithFormat:@"%d/%ld",1,courseItems.count]];
    toolView.itemsCount = courseItems.count;
    toolView.items = courseItems;
    __weak UIPageViewController *wkPVC = pageVC;
    __weak NSArray *wkVCS = vcs;
    toolView.rollBackBolck = ^(NSInteger itemIndex) {
        [wkPVC setViewControllers:@[wkVCS[itemIndex]]
                        direction:(UIPageViewControllerNavigationDirectionForward)
                         animated:YES completion:nil];
    };
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
    for (YSCourseItemModel *item in courseItems) {
        if ([item.question isEqual:examinationItemController.itemModel.question]) {
            item.hasDone = YES;
        }
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

#pragma mark - class method

- (void)jiaojuan:(UIButton *)sender {
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

@end
