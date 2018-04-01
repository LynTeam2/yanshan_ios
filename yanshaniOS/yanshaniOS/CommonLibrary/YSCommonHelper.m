//
//  YSCommonHelper.m
//  yanshaniOS
//
//  Created by 代健 on 2018/3/17.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSCommonHelper.h"

@implementation YSCommonHelper

+ (UIColor *)getUIColorFromHexString:(NSString *)hexString {
    
    unsigned int hexint = [self intFromHexString:hexString];
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:1];
    return color;
}

+ (BOOL)deleteFileByName:(NSString *)name {
    NSString *unzipPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *err;
    [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",unzipPath,name] error:&err];
    if (err) {
        NSLog(@"文件删除失败");
        return NO;
    }
    return YES;
}

+ (UIImage *)weatherIcon:(NSString *)weather {
    NSArray *icons = @[@"cloud",@"snow",@"sunandcloud",@"sunny",@"thunder"];
    if ([weather isEqualToString:@"多云"]) {
        return [UIImage imageNamed:icons[2]];
    }
    if ([weather isEqualToString:@"阴"]) {
        return [UIImage imageNamed:icons[0]];
    }
    if ([weather isEqualToString:@"晴"]) {
        return [UIImage imageNamed:icons[3]];
    }
    if ([weather containsString:@"雨"]) {
        return [UIImage imageNamed:icons[4]];
    }
    if ([weather containsString:@"雪"]) {
        return [UIImage imageNamed:icons[1]];
    }
    return nil;
}

//+ (NSString *)getUserCurrentLocation {
//    
//}

+ (NSString *)timeFromNowWithTimeInterval:(NSTimeInterval)interval {
    
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    fomatter.timeZone = [NSTimeZone localTimeZone];
    fomatter.dateFormat = @"hh:mm";
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:interval];
    return [fomatter stringFromDate:date];
}

+ (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}

@end
