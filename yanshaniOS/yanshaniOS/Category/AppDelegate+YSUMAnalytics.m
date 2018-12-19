//
//  AppDelegate+YSUMAnalytics.m
//  yanshaniOS
//
//  Created by 代健 on 2018/11/12.
//  Copyright © 2018 jiandai. All rights reserved.
//

#import "AppDelegate+YSUMAnalytics.h"
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
#import <UMCommonLog/UMCommonLogHeaders.h>

static const NSString *umkeys = @"5be98e2bb465f5d960000667";

@implementation AppDelegate (YSUMAnalytics)

- (void)initUMAnalytics {
#ifdef DEBUG
    [UMCommonLogManager setUpUMCommonLogManager];
    [UMConfigure setLogEnabled:YES];
    [UMConfigure initWithAppkey:umkeys channel:@"App Test"];
#else
    [MobClick setCrashReportEnabled:YES];
    [UMConfigure initWithAppkey:umkeys channel:@"App Store"];
#endif
    
}

@end
