//
//  YSCourseManager.m
//  yanshaniOS
//
//  Created by 代健 on 2018/2/5.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSCourseManager.h"

static YSCourseManager *manager = nil;
static  NSString *recentCourseFile = @"recentcourses.plist";
static  NSString *allCourseFile = @"allcourses.plist";

@implementation YSCourseManager

+ (instancetype)sharedCourseManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        if (![[YSFileManager sharedFileManager] documentPathIsExecutableFile:recentCourseFile]) {
            [[YSFileManager sharedFileManager] createFileName:recentCourseFile atFilePath:[[YSFileManager sharedFileManager] getDocumentDirectoryPath]];
        }
        if (![[YSFileManager sharedFileManager] documentPathIsExecutableFile:allCourseFile]) {
            [[YSFileManager sharedFileManager] createFileName:allCourseFile atFilePath:[[YSFileManager sharedFileManager] getDocumentDirectoryPath]];
        }
        
    }
    return self;
}

- (void)saveCourseItem:(YSCourseItemModel *)model {
    
    NSDictionary *dic = [model toDictionary];
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
    [mArr addObject:dic];
    NSString *filePath = [[YSFileManager sharedFileManager] getUnzipFilePathWithFileName:recentCourseFile andDocumentName:nil];
    NSArray *arr = [NSArray arrayWithContentsOfFile:filePath];
    [mArr addObjectsFromArray:arr];
    [mArr writeToFile:filePath atomically:YES];
}

- (NSArray *)recentWrongItem {
    return nil;
}

- (void)mergeCourseItem {
    
}

- (NSArray *)allWrongItem {
    NSString *filePath = [[YSFileManager sharedFileManager] getUnzipFilePathWithFileName:allCourseFile andDocumentName:nil];
    NSArray *allArr = [NSArray arrayWithContentsOfFile:filePath];
    if (allArr.count == 0) {
        
    }
    
    return allArr;
}

@end
