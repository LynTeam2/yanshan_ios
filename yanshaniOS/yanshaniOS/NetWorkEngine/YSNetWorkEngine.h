//
//  YSNetWorkEngine.h
//  yanshaniOS
//
//  Created by 代健 on 2018/2/3.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NetWorkResponse)(NSError *error, id data);

@interface YSNetWorkEngine : NSObject

+ (instancetype)sharedInstance;

- (void)downloadFileWithUrl:(NSString *)downloadUrl toFilePath:(NSString *)filePath responseHandler:(NetWorkResponse)handler;

- (void)getRequestWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters responseHandler:(NetWorkResponse)handler;

- (void)getRequestNewWithparameters:(NSDictionary *)parameters responseHandler:(NetWorkResponse)handler;

- (void)getWeatherDataWithparameters:(NSString *)city responseHandler:(NetWorkResponse)handler;

- (void)userLoginWithUseName:(NSString *)userName password:(NSString *)pw responseHandler:(NetWorkResponse)handler;

- (void)modifyUserInformationWithParam:(NSDictionary *)param responseHandler:(NetWorkResponse)handler;

- (void)modifyUserHeaderWithImage:(UIImage *)headerIcon responseHandler:(NetWorkResponse)handler;

- (void)getLawsDataWithParam:(NSDictionary *)param responseHandler:(NetWorkResponse)handler;

- (void)searchInformationWithParam:(NSString *)keyWords responseHandler:(NetWorkResponse)handler;

@end
