//
//  UIViewController+YSCustomNavigationBar.m
//  yanshaniOS
//
//  Created by 代健 on 2017/11/19.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "UIViewController+YSCustomNavigationBar.h"

@implementation UIViewController (YSCustomNavigationBar)

- (void)addPopViewControllerButtonWithTarget:(id)target Action:(SEL)selector {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"navbackicon"] forState:UIControlStateNormal];
    [backButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 18, 28);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = item;
}

@end
