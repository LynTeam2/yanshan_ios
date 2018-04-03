//
//  YSFileManager.m
//  yanshaniOS
//
//  Created by 代健 on 2018/2/4.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSFileManager.h"
#import <SSZipArchive/SSZipArchive.h>

static YSFileManager *fileManager = nil;

@implementation YSFileManager

+ (instancetype)sharedFileManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fileManager = [[YSFileManager alloc] init];
    });
    return fileManager;
}

- (void)zipDoUpdate {
    [[YSNetWorkEngine sharedInstance] downloadFileWithUrl:kZipFileUrl toFilePath:@"zip" responseHandler:^(NSError *error, id data) {
        if (error) {
            [[UIApplication sharedApplication].keyWindow makeToast:@"题库更新失败" duration:2.0 position:@"center"];
        }else{
            self.zipUpdate = YES;
        }
    }];
}

- (void)unzipFileAtPath:(NSString *)unzipPath toDestination:(NSString *)zipPath {
    if ([unzipPath isEmptyString] || [zipPath isEmptyString]) {
        NSLog(@"zip文件不存在！！！");
        return;
    }
    [YSCommonHelper deleteFileByName:@"upgrade"];
    BOOL unzipSuccess = [SSZipArchive unzipFileAtPath:unzipPath toDestination:zipPath];
    if (unzipSuccess) {
        NSLog(@"zip文件解压成功^-^");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"unzipFileSuccess" object:nil];
    }else{
        NSLog(@"zip文件解压错误！！！");
    }
}

- (NSString *)getDocumentDirectoryPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

- (NSString *)createFileName:(NSString *)fileName atFilePath:(NSString *)filePath {
    if ([fileName isEmptyString] || [filePath isEmptyString]) {
        return nil;
    }
    NSString *fullFilePath = [filePath stringByAppendingPathComponent:fileName];
    if(![[NSFileManager defaultManager] fileExistsAtPath:fullFilePath]){
        [[NSFileManager defaultManager] createFileAtPath:fullFilePath contents:nil attributes:nil];
    }
    return fullFilePath;
}

- (NSString *)getUnzipFilePathWithFileName:(NSString *)fileName andDocumentName:(NSString *)documentName {
    if ([fileName isEmptyString]) {
        return nil;
    }
    NSString *documentPath = [self getDocumentDirectoryPath];
    if ([documentName isEmptyString] || !documentName) {
        NSString *fullPath = [documentPath stringByAppendingPathComponent:fileName];
        return fullPath;
    }
    NSString *fullPath = [[NSString stringWithFormat:@"%@/upgrade/%@",documentPath,documentName] stringByAppendingPathComponent:fileName];
    return fullPath;
}

- (NSDictionary *)JSONSerializationJsonFile:(NSString *)fileName atDocumentName:(NSString *)documentName {
    NSString *jsonPath = [self getUnzipFilePathWithFileName:fileName andDocumentName:documentName];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    if (!jsonData) {
        return nil;
    }
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0|1 error:nil];
    return jsonDic;
}

- (UIImage *)getUnzipFileImageWithImageName:(NSString *)imageName {
    NSString *imagePath = [self getUnzipFilePathWithFileName:imageName andDocumentName:@"resource"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

- (BOOL)documentPathIsExecutableFile:(NSString *)fileName {
    NSString *fullFilePath = [[self getDocumentDirectoryPath] stringByAppendingPathComponent:fileName];
    if(![[NSFileManager defaultManager] isExecutableFileAtPath:fullFilePath]){
        return NO;
    }
    return YES;
}

@end
