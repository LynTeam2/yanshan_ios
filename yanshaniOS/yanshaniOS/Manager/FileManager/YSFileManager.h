//
//  YSFileManager.h
//  yanshaniOS
//
//  Created by 代健 on 2018/2/4.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DownloadResultBlock)(BOOL success);

@interface YSFileManager : NSObject

@property (nonatomic, assign) BOOL zipUpdate;

@property (nonatomic, copy) DownloadResultBlock downloadBlock;


+ (instancetype)sharedFileManager;

- (void)zipDoUpdate:(DownloadResultBlock)block;

- (void)unzipFileAtPath:(NSString *)unzipPath toDestination:(NSString *)zipPath;

- (NSString *)getDocumentDirectoryPath;

- (NSString *)createFileName:(NSString *)fileName atFilePath:(NSString *)filePath;

- (NSString *)getUnzipFilePathWithFileName:(NSString *)fileName andDocumentName:(NSString *)documentName;

- (NSDictionary *)JSONSerializationJsonFile:(NSString *)fileName atDocumentName:(NSString *)documentName;

- (UIImage *)getUnzipFileImageWithImageName:(NSString *)imageName;

- (BOOL)documentPathIsExecutableFile:(NSString *)fileName;

- (NSString *)createFileAtDocumentDirectoryPath:(NSString *)fileName;

- (void)deleteFile:(NSString *)fileName atPath:(NSString *)filePath;

//- ()

@end
