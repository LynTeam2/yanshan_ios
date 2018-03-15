//
//  YSNetWorkEngine.h
//  yanshaniOS
//
//  Created by 代健 on 2018/2/3.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NetWorkResponse)(NSError *error, NSDictionary *data);

@interface YSNetWorkEngine : NSObject

+ (instancetype)sharedInstance;

- (void)downloadFileWithUrl:(NSString *)downloadUrl toFilePath:(NSString *)filePath;

- (void)getRequestWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters responseHandler:(NetWorkResponse)hadler;

@end
