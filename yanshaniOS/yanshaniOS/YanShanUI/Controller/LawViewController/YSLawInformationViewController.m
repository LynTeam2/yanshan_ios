//
//  YSLawInformationViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2018/5/4.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSLawInformationViewController.h"
#import <AFNetworking/AFNetworking.h>

@import QuickLook;

@interface YSLawPreviewItem : NSObject <QLPreviewItem>

@property (nonatomic, nullable, strong) NSURL *previewItemURL;

@property (nonatomic, nullable, strong) NSString *previewItemTitle;

@end

@implementation YSLawPreviewItem

- (instancetype)initPreviewURL:(NSURL *)pdfURL withTitle:(NSString *)title {
    self = [super init];
    if (self) {
        _previewItemURL = [pdfURL copy];
        _previewItemTitle = [title copy];
    }
    return self;
}

@end


@interface YSLawInformationViewController ()<QLPreviewControllerDataSource,QLPreviewControllerDelegate,UIWebViewDelegate>

@property(nonatomic, strong) YSLawPreviewItem *item;

@property(nonatomic, strong) QLPreviewController *QLPC;

@end

@implementation YSLawInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addPopViewControllerButtonWithTarget:self action:@selector(backViewController:)];
    self.title = [_model.fileName stringByReplacingOccurrencesOfString:@".pdf" withString:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configView {

    QLPreviewController *preview = [[QLPreviewController alloc] init];
    preview.dataSource = self;
    [self addChildViewController:preview];//*view controller containment
   
    //set the frame from the parent view
    CGFloat w= self.view.frame.size.width;
    CGFloat h= self.view.frame.size.height;
    preview.view.frame = CGRectMake(0, 0,w, h);
    [self.view addSubview:preview.view];
    [preview didMoveToParentViewController:self];
 
    //save a reference to the preview controller in an ivar
    self.QLPC = preview;
    [preview.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.delegate = self;
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_model.filePath]]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return self.item;
}

- (BOOL)webView:(UIWebView *)theWebView shouldStartLoadWithRequest:(NSURLRequest *)req navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = req.URL;
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
        NSURL *fileURLPath = [documentsDirectoryPath URLByAppendingPathComponent:[response suggestedFilename]];
        return fileURLPath;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        [self.view sendSubviewToBack:theWebView];
        if (error) {
            [self.view makeToast:@"加载失败" duration:2.0 position:@"center"];
        }else{
            _item = [[YSLawPreviewItem alloc] initPreviewURL:filePath withTitle:_model.fileName];
            [_QLPC reloadData];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [downloadTask resume];
    
    return YES;
}

@end



