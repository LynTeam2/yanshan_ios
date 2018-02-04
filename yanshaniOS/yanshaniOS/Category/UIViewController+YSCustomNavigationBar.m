//
//  UIViewController+YSCustomNavigationBar.m
//  yanshaniOS
//
//  Created by 代健 on 2017/11/19.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "UIViewController+YSCustomNavigationBar.h"

@implementation UIViewController (YSCustomNavigationBar)

- (void)addPopViewControllerButtonWithTarget:(id)target action:(SEL)selector {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"navbackicon"] forState:UIControlStateNormal];
    [backButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 18, 28);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = item;
}

- (UIButton *)customNavgationBarItem:(UIBarButtonItem *)barItem withTitle:(NSString *)title {
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    itemButton.frame = CGRectMake(0, 0, 84, 44);
    [itemButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [itemButton setTitle:title forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:itemButton];
    self.navigationItem.rightBarButtonItem = item;
    return itemButton;
}

@end
