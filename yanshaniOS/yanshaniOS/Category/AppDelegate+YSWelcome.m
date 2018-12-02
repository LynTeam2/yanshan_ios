//
//  AppDelegate+YSWelcome.m
//  yanshaniOS
//
//  Created by 代健 on 2018/11/16.
//  Copyright © 2018 jiandai. All rights reserved.
//

#import "AppDelegate+YSWelcome.h"

@implementation AppDelegate (YSWelcome)

- (BOOL)newDownloadApp {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kNewApp] boolValue];
}

@end
