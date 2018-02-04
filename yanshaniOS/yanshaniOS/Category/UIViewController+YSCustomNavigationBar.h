//
//  UIViewController+YSCustomNavigationBar.h
//  yanshaniOS
//
//  Created by 代健 on 2017/11/19.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (YSCustomNavigationBar)

- (void)addPopViewControllerButtonWithTarget:(id)target action:(SEL)selector;

- (UIButton *)customNavgationBarItem:(UIBarButtonItem *)barItem withTitle:(NSString *)title;

@end
