//
//  YSNetWorkEngine.m
//  yanshaniOS
//
//  Created by 代健 on 2018/2/3.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSNetWorkEngine.h"
#import "YSCourseItemModel.h"
#import <AFNetworking/AFNetworking.h>

static YSNetWorkEngine *netWorkEngine = nil;

static NSString const *baseURL = @"http://39.105.27.225/";

@interface YSNetWorkEngine ()

@property (nonatomic, strong) AFHTTPSessionManager *httpManager;

@end

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
        NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
        _httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]
                                                sessionConfiguration:conf];
    }
    return self;
}

- (NSString *)requestFullURL:(NSString *)api {
    if (api.isEmptyString) {
        return kHostURL;
    }
    return [kHostURL stringByAppendingString:api];
}

- (void)downloadFileWithUrl:(NSString *)downloadUrl toFilePath:(NSString *)filePath responseHandler:(NetWorkResponse)handler{
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
    [manager POST:@"http://39.105.27.225/login" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0|1 error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(nil,dic);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
        handler(error,nil);
    }];
}

- (void)getRequestNewsWithparameters:(NSDictionary *)parameters responseHandler:(NetWorkResponse)handler {
    
    [_httpManager GET:@"api/news" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {

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
    NSString *url = [NSString stringWithFormat:@"https://free-api.heweather.com/s6/weather?key=6e8a4b90f9504d9caed280c41a837c1c&location=%@",city];
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
    NSString *path = [self requestFullURL:[NSString stringWithFormat:@"user/%@",param.allKeys[0]]];
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
    
    __weak YSUserModel *weakUser = [YSUserModel shareInstance];
    __weak YSNetWorkEngine *weakNet = self;

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURLSessionDataTask *task = [manager POST:@"http://39.105.27.225/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = UIImageJPEGRepresentation(headerIcon, 1.0);
        [formData appendPartWithFileData:data name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        YSUserModel *strongUser = weakUser;
        YSNetWorkEngine *strongNet = weakNet;
        NSDictionary *dic = (NSDictionary *)responseObject;
        if (dic[@"results"]) {
            NSDictionary *resultsDic = dic[@"results"];
            strongUser.userIcon = resultsDic[@"path"];
            [strongNet modifyUserInformationWithParam:@{@"icon":resultsDic[@"path"]} responseHandler:^(NSError *error, id data) {
                handler(error,data);
            }];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    [task resume];

}


- (void)modifyPassword:(NSString *)newPassword responseHandler:(NetWorkResponse)handler {
    if (!newPassword) {
        return;
    }
    NSString *path = [self requestFullURL:@"user/password"];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"PUT";

    NSData *data = [NSJSONSerialization dataWithJSONObject:@{@"newPassword":newPassword} options:0|1 error:nil];
    request.HTTPBody = data;
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:1|0 error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(error,dic);
        });
    }] resume];
}
//Dudeaddssss
- (void)getLawsDataWithParam:(NSDictionary *)param responseHandler:(NetWorkResponse)handler {
    
    [_httpManager GET:@"api/law" parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        handler(nil,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
        handler(error,nil);
    }];
    
}

- (void)searchInformationWithParam:(NSString *)keyWords responseHandler:(NetWorkResponse)handler {
    if (keyWords.isEmptyString) {
        handler(nil,nil);
        return;
    }
    NSDictionary *param = @{@"query":keyWords};
    [_httpManager GET:@"api/search" parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        handler(nil,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
        handler(error,nil);
    }];
}

- (void)uploadUserCourseProcessWithParam:(NSString *)courseID examDuration:(NSInteger)seconds responseHandler:(NetWorkResponse)handler {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer new];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSString *urlString = [self requestFullURL:[NSString stringWithFormat:@"course/%@",courseID]];
    NSInteger duration = ceill(abs((int)seconds)/60.0);
    [manager POST:urlString parameters:@{@"duration":@(duration)} progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"同步成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)getExamHistoryRecordsWithResponseHandler:(NetWorkResponse)handler {
    
    [_httpManager GET:@"api/exam" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        handler(nil,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
        handler(error,nil);
    }];
}

- (void)uploadUserExamResultsWith:(YSExaminationItemModel *)data responseHandler:(NetWorkResponse)handler {
   
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer new];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSString *urlString = [self requestFullURL:@"exam"];
    NSMutableArray *listItems = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < data.items.count; i++) {
        YSCourseItemModel *model = data.items[i];
        NSString *result = model.doROW ? ([model.doROW isEqualToString:@"y"] ? @"1" : @"0") : @"0";
        [listItems addObject:@{@"questionId":model.itemId,
                               @"questionType":model.questionType,
                               @"ajType":model.ajType,
                               @"answer":model.answer,@"result":result,
                               @"uid":[YSUserModel shareInstance].userId}];
    }
    NSDictionary *params = @{@"examId":[NSString stringWithFormat:@"%ld",data.examID],
                                                  @"examName":data.examName,
                                                 @"makeupFlag":[NSString stringWithFormat:@"%ld",data.makeupFlag],
                                                 @"startTime":data.startTime,
                                                 @"endTime":data.endTime,
                                                 @"examScore":[NSString stringWithFormat:@"%ld",data.examScore],
                                                 @"examDetailList":listItems,
                                                 @"userId":[YSUserModel shareInstance].userId};
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"同步成功");
        id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:0|1 error:nil];
        handler(nil,jsonObj);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)queryUserExamCountWith:(NSInteger)examID responseHandler:(NetWorkResponse)handler {

    [_httpManager GET:[NSString stringWithFormat:@"api/exam/%ld",examID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        handler(nil,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
        handler(error,nil);
    }];
}

- (void)qiandaoWithResponseHandler:(NetWorkResponse)handler {
    NSString *path = [self requestFullURL:[NSString stringWithFormat:@"user/%@",@"bean"]];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"PUT";
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{@"beanCount":@10} options:0|1 error:nil];
    request.HTTPBody = data;
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:1|0 error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(error,dic);
        });
    }] resume];
}

@end

