//
//  YSMessageDetailViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2017/12/3.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSMessageDetailViewController.h"

@implementation YSMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kRandomColor;
}

- (void)configViewControllerParameter {
    self.title = @"消息详情";
    [self addPopViewControllerButtonWithTarget:self action:@selector(backViewController:)];
}

@end
