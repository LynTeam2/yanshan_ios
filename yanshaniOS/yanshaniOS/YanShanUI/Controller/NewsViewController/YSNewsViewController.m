//
//  YSNewsViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2017/12/31.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSNewsViewController.h"
#import <WebKit/WebKit.h>

@interface YSNewsViewController ()<WKNavigationDelegate>

@end

@implementation YSNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    [webView loadHTMLString:_dic[@"content"] baseURL:nil];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    [self addPopViewControllerButtonWithTarget:self action:@selector(backViewController:)];
    self.title = @"新闻详情";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
