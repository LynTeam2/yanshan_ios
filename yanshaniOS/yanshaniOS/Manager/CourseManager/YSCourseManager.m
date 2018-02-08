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
{
    NSMutableArray *recentCourses;
}
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
        recentCourses = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)saveCourseItem:(YSCourseItemModel *)model {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"question == %@", model.question];
    NSArray *filteredArray = [recentCourses filteredArrayUsingPredicate:predicate];
    if (filteredArray.count) {
        return;
    }
    [recentCourses addObject:model];
}

- (NSArray *)getRecentWrongCourseItem {
    return recentCourses;
}

- (void)mergeCourseItem {
    NSString *filePath = [[YSFileManager sharedFileManager] getUnzipFilePathWithFileName:allCourseFile andDocumentName:nil];
    NSArray *olderCourses = [NSArray arrayWithContentsOfFile:filePath];
    NSMutableArray *allCourses = [NSMutableArray arrayWithArray:recentCourses];
    [allCourses addObjectsFromArray:olderCourses];
    NSArray *mArr = [YSCourseItemModel arrayOfDictionariesFromModels:allCourses];
    [mArr writeToFile:filePath atomically:YES];
}

- (NSArray *)getAllWrongCourseItem {
    NSString *filePath = [[YSFileManager sharedFileManager] getUnzipFilePathWithFileName:allCourseFile andDocumentName:nil];
    NSArray *allArr = [NSArray arrayWithContentsOfFile:filePath];
    if (allArr.count == 0) {
        return recentCourses;
    }
    NSArray *models = [NSArray arrayWithArray:[YSCourseItemModel arrayOfModelsFromDictionaries:allArr error:nil]];
    return models;
}

@end
