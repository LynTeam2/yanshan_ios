//
//  YSFileManager.m
//  yanshaniOS
//
//  Created by 代健 on 2018/2/4.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSFileManager.h"
#import <LzmaSDK_ObjC/LzmaSDKObjC.h>

static YSFileManager *fileManager = nil;

@implementation YSFileManager

+ (instancetype)sharedFileManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fileManager = [[YSFileManager alloc] init];
    });
    return fileManager;
}

- (void)zipDoUpdate:(DownloadResultBlock)block{
    if (self.zipUpdate && !self.forceUpdate) {
        return;
    }
    self.zipUpdate = YES;
    self.forceUpdate = NO;
    [[YSNetWorkEngine sharedInstance] downloadFileWithUrl:kZipFileUrl toFilePath:@"zip" responseHandler:^(NSError *error, id data) {
        if (error) {
            self.zipUpdate = NO;
            [[UIApplication sharedApplication].keyWindow makeToast:@"题库更新失败" duration:2.0 position:@"center"];
        }
        BOOL success = error ? NO : YES;
        if (block) {
            block(success);
        }
    }];
}

- (void)zipDoUpdateByHand:(DownloadResultBlock)block {
    self.forceUpdate = YES;
    [self zipDoUpdate:block];
}

- (void)unzipFileAtPath:(NSString *)unzipPath toDestination:(NSString *)zipPath {
    if ([unzipPath isEmptyString] || [zipPath isEmptyString]) {
        NSLog(@"zip文件不存在！！！");
        return;
    }
    
//    if (self.zipUpdate) {
//        return;
//    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [YSCommonHelper deleteFileByName:@"upgrade"];
        // select full path to archive file with 7z extension
        NSString *archivePath = unzipPath;
        
        // 1.1 Create and hold strongly reader object.
        LzmaSDKObjCReader *reader = [[LzmaSDKObjCReader alloc] initWithFileURL:[NSURL fileURLWithPath:archivePath]];
        // 1.2 Or create with predefined archive type if path doesn't containes suitable extension
        reader = [[LzmaSDKObjCReader alloc] initWithFileURL:[NSURL fileURLWithPath:archivePath]
                                                    andType:LzmaSDKObjCFileType7z];
        
        // Optionaly: assign weak delegate for tracking extract progress.
        reader.delegate = self;
        
        // If achive encrypted - define password getter handler.
        // NOTES:
        // - Encrypted file needs password for extract process.
        // - Encrypted file with encrypted header needs password for list(iterate) and extract archive items.
        reader.passwordGetter = ^NSString*(void){
            return @"password to my achive";
        };
        NSError * error = nil;
        if (![reader open:&error]) {
            NSLog(@"Open error: %@", error);
        }
        NSLog(@"Open error: %@", reader.lastError);
        
        NSMutableArray * items = [NSMutableArray array]; // Array with selected items.
        // Iterate all archive items, track what items do you need & hold them in array.
        [reader iterateWithHandler:^BOOL(LzmaSDKObjCItem * item, NSError * error){
            if (item) [items addObject:item]; // if needs this item - store to array.
            return YES; // YES - continue iterate, NO - stop iteration
        }];
        NSLog(@"Iteration error: %@", reader.lastError);
        [reader extract:items
                 toPath:zipPath
          withFullPaths:YES];
        NSLog(@"Extract error: %@", reader.lastError);
        
        // Test selected items from prev. step.
        [reader test:items];
        NSLog(@"test error: %@", reader.lastError);
        
        if (!reader.lastError) {
            NSLog(@"zip文件解压成功^-^");
            self.zipUpdate = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kUnzipSuccessNotification object:nil];
            });
        }else{
            NSLog(@"zip文件解压错误！！！");
        }
    });
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
    if ([jsonDic isKindOfClass:[NSDictionary class]]) {
        if (jsonDic[@"courses"]) {
            NSMutableArray *courses = [NSMutableArray array];
            for (NSDictionary *dic in jsonDic[@"courses"]) {
                NSString *role = dic[@"role"];
                if ([role containsString:[YSUserModel shareInstance].roleName]) {
                    [courses addObject:dic];
                }
            }
            return @{@"courses":courses};
        }else if (jsonDic[@"exams"]){
            NSMutableArray *exams = [NSMutableArray array];
            for (NSDictionary *dic in jsonDic[@"exams"]) {
                NSString *role = dic[@"role"];
                if ([role containsString:[YSUserModel shareInstance].roleName]) {
                    [exams addObject:dic];
                }
            }
            return @{@"exams":exams};
        }
    }
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

- (NSString *)createFileAtDocumentDirectoryPath:(NSString *)fileName {
    if ([fileName isEmptyString]) {
        return nil;
    }
    NSString *filePath = [self getDocumentDirectoryPath];
    NSString *fullFilePath = [filePath stringByAppendingPathComponent:fileName];
    if(![[NSFileManager defaultManager] fileExistsAtPath:fullFilePath]){
        [[NSFileManager defaultManager] createFileAtPath:fullFilePath contents:nil attributes:nil];
    }
    return fullFilePath;
}

- (void)deleteFile:(NSString *)fileName atPath:(NSString *)filePath {
    if (!fileName || !filePath) {
        return;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

@end
