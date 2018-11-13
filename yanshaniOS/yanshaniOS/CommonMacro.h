//
//  CommonMacro.h
//  yanshaniOS
//
//  Created by 代健 on 2017/10/8.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#ifndef CommonMacro_h
#define CommonMacro_h

#pragma mark - base macro

#define kRandomColor     [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1]

#define kRGBColor(R,G,B,a)     [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:a]
#define kDefaultFont           [UIFont systemFontOfSize:15.f]

#define kBlueColor             [YSCommonHelper getUIColorFromHexString:@"6490ff"]
#define kLightGray             kRGBColor(231,231,231,1)
#define kLightGrayLevel2       kRGBColor(192,192,192,1)
#define kWhiteColor            kRGBColor(255,255,255,1)
#define kLineHeight            0.5

#define kBalaceKey             @"anquandou"

#pragma mark - url macro
// 
//#define kZipFileUrl            @"http://39.105.27.225/api/upgrade"
#define kZipFileUrl            @"http://api.anjian.hanyuhuake.com/api/upgrade"

//#define kHostURL               @"http://39.105.27.225/api/"
#define kHostURL               @"http://api.anjian.hanyuhuake.com/api/"
#pragma mark - file name

#define kQianDaoFile           @"qiandao.plist"

#define kCourseFiles           @"courseid.plist"

#pragma mark - notification name

#define kUnzipSuccessNotification   @"unzipFileSuccess"

#endif /* CommonMacro_h */
