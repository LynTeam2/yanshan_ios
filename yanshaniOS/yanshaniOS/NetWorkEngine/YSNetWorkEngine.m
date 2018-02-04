//
//  YSNetWorkEngine.m
//  yanshaniOS
//
//  Created by 代健 on 2018/2/3.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSNetWorkEngine.h"
#import <AFNetworking/AFNetworking.h>

static YSNetWorkEngine *netWorkEngine = nil;

@implementation YSNetWorkEngine

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netWorkEngine = [[self alloc] init];
    });
    return netWorkEngine;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)downloadFileWithUrl:(NSString *)downloadUrl toFilePath:(NSString *)filePath {
    
    __weak YSNetWorkEngine *weakSelf = self;
    NSString *unzipPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:downloadUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"File downloaded to: %@", filePath.absoluteString);
        [[YSFileManager sharedFileManager] unzipFileAtPath:[NSString stringWithFormat:@"%@/upgrade.zip",unzipPath] toDestination:unzipPath];
    }];
    [downloadTask resume];
}

#pragma mark - zip file operation


@end
