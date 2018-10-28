//
//  YSNetWorkEngine.h
//  yanshaniOS
//
//  Created by 代健 on 2018/2/3.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSExaminationItemModel.h"

typedef void(^NetWorkResponse)(NSError *error, id data);

@interface YSNetWorkEngine : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, assign) BOOL downloadSuccess;



/**
 Description: download zip file

 @param downloadUrl zip url
 @param filePath  zip file save path
 @param handler   call back block
 */
- (void)downloadFileWithUrl:(NSString *)downloadUrl toFilePath:(NSString *)filePath responseHandler:(NetWorkResponse)handler;


/**
 Description:

 @param URLString <#URLString description#>
 @param parameters <#parameters description#>
 @param handler <#handler description#>
 */
- (void)getRequestWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters responseHandler:(NetWorkResponse)handler;


/**
 Description:request news data

 @param parameters see news api params introduce
 @param handler call back block
 */
- (void)getRequestNewsWithparameters:(NSDictionary *)parameters responseHandler:(NetWorkResponse)handler;


/**
 Description:request city weather data of 7 days

 @param city city name
 @param handler call back block
 */
- (void)getWeatherDataWithparameters:(NSString *)city responseHandler:(NetWorkResponse)handler;


/**
 Description: user login

 @param userName user name
 @param pw      password
 @param handler call back block
 */
- (void)userLoginWithUseName:(NSString *)userName password:(NSString *)pw responseHandler:(NetWorkResponse)handler;


/**
 Description: modify user personal information

 @param param   user personal information params
 @param handler call back block
 */
- (void)modifyUserInformationWithParam:(NSDictionary *)param responseHandler:(NetWorkResponse)handler;


/**
 Description:

 @param headerIcon <#headerIcon description#>
 @param handler <#handler description#>
 */
- (void)modifyUserHeaderWithImage:(UIImage *)headerIcon responseHandler:(NetWorkResponse)handler;

- (void)modifyPassword:(NSString *)newPassword responseHandler:(NetWorkResponse)handler;

- (void)getLawsDataWithParam:(NSDictionary *)param responseHandler:(NetWorkResponse)handler;

- (void)searchInformationWithParam:(NSString *)keyWords responseHandler:(NetWorkResponse)handler;

- (void)uploadUserCourseProcessWithParam:(NSString *)courseID examDuration:(NSInteger)seconds responseHandler:(NetWorkResponse)handler;

- (void)getExamHistoryRecordsWithResponseHandler:(NetWorkResponse)handler;

- (void)uploadUserExamResultsWith:(YSExaminationItemModel *)data responseHandler:(NetWorkResponse)handler;

- (void)queryUserExamCountWith:(NSInteger)examID responseHandler:(NetWorkResponse)handler;

- (void)qiandaoWithResponseHandler:(NetWorkResponse)handler;

@end
