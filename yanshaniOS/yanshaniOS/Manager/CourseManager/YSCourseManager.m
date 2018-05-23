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
    NSMutableArray *allCourses;
    NSMutableArray *allIds;
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
        allCourses = [NSMutableArray arrayWithCapacity:0];
        allIds = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)saveCourseItem:(YSCourseItemModel *)model {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"question == %@", model.question];
    NSArray *filteredArray = [[self getAllWrongCourseItem] filteredArrayUsingPredicate:predicate];
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
    NSArray *olderCourses = [YSCourseItemModel arrayOfModelsFromDictionaries:[NSArray arrayWithContentsOfFile:filePath] error:nil];
    NSMutableArray *allCourses = [NSMutableArray arrayWithArray:recentCourses];
    [allCourses addObjectsFromArray:olderCourses];
    if (allCourses.count) {
        NSArray *mArr = [YSCourseItemModel arrayOfDictionariesFromModels:allCourses];
        [mArr writeToFile:filePath atomically:YES];
    }
}

- (void)deleteCourseItem:(YSCourseItemModel *)model {
    NSString *filePath = [[YSFileManager sharedFileManager] getUnzipFilePathWithFileName:allCourseFile andDocumentName:nil];
    NSMutableArray *allArr = [YSCourseItemModel arrayOfModelsFromDictionaries:[NSArray arrayWithContentsOfFile:filePath] error:nil];
    for (YSCourseItemModel *tmp in allArr) {
        if ([tmp.question isEqual:model.question]) {
            [allArr removeObject:tmp];
            break;
        }
    }
    NSArray *mArr = [YSCourseItemModel arrayOfDictionariesFromModels:allArr];
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

- (NSArray *)getLocalHasDoneCourseId {
    if (allIds.count) {
        return allIds;
    }
    NSString *filePath = [[YSFileManager sharedFileManager] getUnzipFilePathWithFileName:kCourseFiles andDocumentName:nil];
    NSArray *ids = [NSArray arrayWithContentsOfFile:filePath];
    [allIds addObjectsFromArray:ids];
    return ids;
}

- (void)saveHasDoneCourseId:(NSDictionary *)courseInfo {
//    BOOL haveId = NO;
//    for (NSDictionary *tmp in allIds) {
//        if ([[tmp objectForKey:@"id"] isEqualToString:[courseInfo objectForKey:@"id"]]) {
//            haveId = YES;
//        }
//    }
    BOOL haveId = [self queryCourseIsHasDoneWithId:courseInfo[@"id"]];
    if (!haveId) {
        NSString *filePath = [[YSFileManager sharedFileManager] getUnzipFilePathWithFileName:kCourseFiles andDocumentName:nil];
        [allIds addObject:courseInfo];
        [allIds writeToFile:filePath atomically:YES];
    }
}

- (BOOL)queryCourseIsHasDoneWithId:(NSString *)courseId {
    [self getLocalHasDoneCourseId];
    for (NSDictionary *tmp in allIds) {
        if ([[tmp objectForKey:@"id"] integerValue] == [courseId integerValue]) {
            return YES;
        }
    }
    return NO;
}

@end
