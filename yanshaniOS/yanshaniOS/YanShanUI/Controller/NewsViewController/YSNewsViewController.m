//
//  YSNewsViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2017/12/31.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSNewsViewController.h"

@interface YSNewsViewController ()

@end

@implementation YSNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView loadHTMLString:_dic[@"content"] baseURL:nil];
    [self.view addSubview:webView];
    [self addPopViewControllerButtonWithTarget:self action:@selector(backViewController:)];
    self.title = @"新闻详情";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
