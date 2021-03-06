//
//  YSBaseViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2017/10/4.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSBaseViewController.h"

@interface YSBaseViewController ()

@end

@implementation YSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self configViewControllerParameter];
    [self configContainer];
    [self configView];
    [self addNavigationItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    NSLog(@"%@ release",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - config view controller

- (void)configViewControllerParameter {
    // 子类重写实现
}

- (void)configView {
    // 子类重写实现
}

- (void)configContainer {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)addNavigationItems {
    
}

- (void)backViewController:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
