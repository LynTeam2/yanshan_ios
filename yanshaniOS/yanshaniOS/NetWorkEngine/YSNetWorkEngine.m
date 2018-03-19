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
    [YSCommonHelper deleteFileByName:@"upgrade.zip"];
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

- (void)getRequestWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters responseHandler:(NetWorkResponse)handler {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer new];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager POST:@"http://39.104.118.75/login" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0|1 error:nil];
        handler(nil,dic);
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
        NSLog(@"%@",error.userInfo);
        handler(error,nil);
    }];
}

- (void)getRequestNewWithparameters:(NSDictionary *)parameters responseHandler:(NetWorkResponse)handler {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://39.104.118.75/api/news" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        handler(nil,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
        NSLog(@"%@",error.userInfo);
        handler(error,nil);
    }];
}

- (void)getWeatherDataWithparameters:(NSString *)city responseHandler:(NetWorkResponse)handler {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://www.sojson.com/open/api/weather/json.shtml?city=%E5%8C%97%E4%BA%AC" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        handler(nil,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
        NSLog(@"%@",error.userInfo);
        handler(error,nil);
    }];
}

@end
