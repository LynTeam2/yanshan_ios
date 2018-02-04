//
//  YSNetWorkEngine.h
//  yanshaniOS
//
//  Created by 代健 on 2018/2/3.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSNetWorkEngine : NSObject

+ (instancetype)sharedInstance;

- (void)downloadFileWithUrl:(NSString *)downloadUrl toFilePath:(NSString *)filePath;

@end
