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

@interface YSCourseDetailViewController ()<UIPageViewControllerDelegate,YSExaminationItemViewControllerDelegate,WKNavigationDelegate,WKUIDelegate,UIWebViewDelegate>
{
    NSMutableArray *vcs;
    NSArray *courseItems;
    UIPageViewController *pageVC;
    UIWebView *webView;
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
    
//    webView.frame = self.view.bounds;
//    webView.navigationDelegate = self;
    if (_htmlStr) {
        [webView loadHTMLString:_htmlStr baseURL:nil];
//        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.apple.com"]]];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
//    [self.view addSubview:webView];
    
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

- (void)configContainer {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
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
