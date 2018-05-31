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
        _downloadSuccess = NO;
    }
    return self;
}

- (void)downloadFileWithUrl:(NSString *)downloadUrl toFilePath:(NSString *)filePath responseHandler:(NetWorkResponse)handler{
    if (_downloadSuccess) {
        handler(nil,nil);
        return;
    }
    NSString *unzipPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    [YSCommonHelper deleteFileByName:@"upgrade.7z"];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:downloadUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (!error) {
            _downloadSuccess = YES;
        }
        handler(error,response.URL.absoluteString);
        NSLog(@"File downloaded to: %@", filePath.absoluteString);
        [[YSFileManager sharedFileManager] unzipFileAtPath:[NSString stringWithFormat:@"%@/upgrade.7z",unzipPath] toDestination:unzipPath];
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
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(nil,dic);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
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
        handler(error,nil);
    }];
}

- (void)getWeatherDataWithparameters:(NSString *)city responseHandler:(NetWorkResponse)handler {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    city = [YSCommonHelper urlencode:city];
    NSString *url = [NSString stringWithFormat:@"https://www.sojson.com/open/api/weather/json.shtml?city=%@",city];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        handler(nil,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.userInfo);
        handler(error,nil);
    }];
}

- (void)userLoginWithUseName:(NSString *)userName password:(NSString *)pw responseHandler:(NetWorkResponse)handler{
    if (!userName || !pw) {
        return;
    }
    NSDictionary *parameters = @{@"username":userName,@"password":pw};
    [[YSNetWorkEngine sharedInstance] getRequestWithURLString:@"" parameters:parameters responseHandler:^(NSError *error, NSDictionary *data) {
        handler(error,data);
    }];
}

- (void)modifyUserInformationWithParam:(NSDictionary *)param responseHandler:(NetWorkResponse)handler {
    if (!param) {
        return;
    }
    NSString *path = [NSString stringWithFormat:@"http://39.104.118.75/api/user/%@",param.allKeys[0]];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"PUT";

    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:0|1 error:nil];
    request.HTTPBody = data;
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:1|0 error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(error,dic);
        });
    }] resume];
}

- (void)modifyUserHeaderWithImage:(UIImage *)headerIcon responseHandler:(NetWorkResponse)handler {
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://39.104.118.75/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *data = UIImageJPEGRepresentation(headerIcon, 1.0);
        [formData appendPartWithFileData:data name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg"];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {

                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          handler(error,nil);
                      } else if([responseObject isKindOfClass:[NSDictionary class]]) {
                          NSDictionary *dic = (NSDictionary *)responseObject;
                          if (dic[@"results"]) {
                              NSDictionary *resultsDic = dic[@"results"];
                              [YSUserModel shareInstance].userIcon = resultsDic[@"path"];
                              [self modifyUserInformationWithParam:@{@"icon":resultsDic[@"path"]} responseHandler:^(NSError *error, id data) {
                                  handler(error,data);
                              }];
                          }
                      }
                  }];
    
    [uploadTask resume];
}

- (void)getLawsDataWithParam:(NSDictionary *)param responseHandler:(NetWorkResponse)handler {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://39.104.118.75/api/law" parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        handler(nil,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
        handler(error,nil);
    }];
}

- (void)searchInformationWithParam:(NSString *)keyWords responseHandler:(NetWorkResponse)handler {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *param = @{@"query":keyWords};
    [manager GET:@"http://39.104.118.75/api/search" parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        handler(nil,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
        handler(error,nil);
    }];
}

@end
