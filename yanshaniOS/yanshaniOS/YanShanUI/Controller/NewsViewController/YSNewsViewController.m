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
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"--";
    titleLabel.font = [UIFont systemFontOfSize:20.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.text = @"--";
    dateLabel.font = [UIFont systemFontOfSize:15.f];
    dateLabel.textColor = [UIColor grayColor];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:dateLabel];
    if ([self.view respondsToSelector:@selector(safeAreaLayoutGuide)]) {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuide).offset(20);
            make.width.equalTo(self.view);
            make.height.mas_equalTo(30);
        }];
    }else if ([UIViewController instancesRespondToSelector:@selector(topLayoutGuide)]) {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.mas_topLayoutGuide).offset(20);
            make.width.equalTo(self.view);
            make.height.mas_equalTo(30);
        }];
    }
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView loadHTMLString:_dic[@"content"] baseURL:nil];
    webView.delegate = self;
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateLabel.mas_bottom).offset(30);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
    }];
    
    if (_dic[@"title"]) {
        titleLabel.text = _dic[@"title"];
    }
    if (_dic[@"newsTime"]) {
        dateLabel.text = _dic[@"newsTime"];
    }
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
