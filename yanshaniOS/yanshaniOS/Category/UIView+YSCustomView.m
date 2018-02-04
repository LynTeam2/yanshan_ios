//
//  UIView+YSCustomView.m
//  yanshaniOS
//
//  Created by 代健 on 2017/12/2.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "UIView+YSCustomView.h"

@implementation UIView (YSCustomView)

+ (UIView *)instanceSeperateLineWithoutFrame {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor grayColor];
    return line;
}

+ (UIView *)instanceSeperatelineWithFrame:(CGRect)frame {
    UIView *line = [self instanceSeperateLineWithoutFrame];
    line.frame = frame;
    return line;
}

@end
