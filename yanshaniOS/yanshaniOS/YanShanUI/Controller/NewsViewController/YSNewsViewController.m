//
//  YSNewsViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2017/12/31.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSNewsViewController.h"
#import <WebKit/WebKit.h>

@interface YSNewsViewController ()<WKNavigationDelegate,UIWebViewDelegate>

@end

@implementation YSNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView loadHTMLString:_dic[@"content"] baseURL:nil];
//    webView.navigationDelegate = self;
    webView.delegate = self;
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

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
