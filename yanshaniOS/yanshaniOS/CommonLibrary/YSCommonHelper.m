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
    if ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",unzipPath,name]]) {
        [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",unzipPath,name] error:&err];
    }else{
        NSLog(@"文件不存在！！！");
        return NO;
    }
    if (err) {
        NSLog(@"文件删除失败");
        return NO;
    }
    return YES;
}

+ (UIImage *)weatherIcon:(NSString *)weather state:(UIControlState)state{
    NSArray *icons = state == UIControlStateNormal?@[@"sunwhite",@"moonwhite",@"nightwhite"]:@[@"cloud",@"snow",@"sunandcloud",@"sunny",@"thunder"];
    if ([weather isEqualToString:@"多云"]) {
        return (state == UIControlStateNormal ? [UIImage imageNamed:icons[1]] : [UIImage imageNamed:icons[2]]);
    }
    if ([weather isEqualToString:@"阴"]) {
        return (state == UIControlStateNormal ? [UIImage imageNamed:icons[2]] : [UIImage imageNamed:icons[0]]);
    }
    if ([weather isEqualToString:@"晴"]) {
        return (state == UIControlStateNormal ? [UIImage imageNamed:icons[0]] : [UIImage imageNamed:icons[3]]);
    }
    if ([weather containsString:@"雨"]) {
        return (state == UIControlStateNormal ? [UIImage imageNamed:icons[1]] : [UIImage imageNamed:icons[4]]);
    }
    if ([weather containsString:@"雪"]) {
        return (state == UIControlStateNormal ? [UIImage imageNamed:icons[1]] : [UIImage imageNamed:icons[1]]);
    }
    return (state == UIControlStateNormal ? [UIImage imageNamed:icons[0]] : [UIImage imageNamed:icons[3]]);
;
}

+ (NSString *)urlencode:(NSString *)encodeString {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[encodeString UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

+ (UIImage *)imageFromColor:(UIColor *)color withSize:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (NSString *)getWeekDayFromDateString:(NSString *)dateString {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    formatter.locale = [NSLocale currentLocale];
    NSDate *date = [formatter dateFromString:dateString];
    NSDateComponents *result = [calendar components:unitFlags fromDate:date];
    NSString *weekDay = @"星期一";
    switch (result.weekday) {
        case 1:
            weekDay = @"星期日";
            break;
        case 2:
            weekDay = @"星期一";
            break;
        case 3:
            weekDay = @"星期二";
            break;
        case 4:
            weekDay = @"星期三";
            break;
        case 5:
            weekDay = @"星期四";
            break;
        case 6:
            weekDay = @"星期五";
            break;
        case 7:
            weekDay = @"星期六";
            break;
        default:
            break;
    }
    return weekDay;
}

+ (NSString *)timeFromNowWithTimeInterval:(NSTimeInterval)interval dateFormat:(NSString *)format {
    
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    fomatter.timeZone = [NSTimeZone localTimeZone];
    fomatter.dateFormat = format;
    
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
