//
//  NSString+YSStringOperation.m
//  yanshaniOS
//
//  Created by 代健 on 2018/2/4.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "NSString+YSStringOperation.h"

@implementation NSString (YSStringOperation)

- (BOOL)isEmptyString {
    if (0 == self.length || [self isEqual:@""] || self == NULL) {
        return YES;
    }
    return NO;
}

@end
