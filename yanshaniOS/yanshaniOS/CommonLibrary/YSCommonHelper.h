//
//  YSCommonHelper.h
//  yanshaniOS
//
//  Created by 代健 on 2018/3/17.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSCommonHelper : NSObject

+ (UIColor *)getUIColorFromHexString:(NSString *)hexString;

+ (BOOL)deleteFileByName:(NSString *)name;

+ (UIImage *)weatherIcon:(NSString *)weather;

@end
