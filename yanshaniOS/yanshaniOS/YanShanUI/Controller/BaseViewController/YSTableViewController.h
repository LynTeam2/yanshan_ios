//
//  YSTableViewController.h
//  yanshaniOS
//
//  Created by 代健 on 2017/11/19.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSBaseViewController.h"

@interface YSTableViewController : YSBaseViewController
{
    UITableView *_mainTableView;
    NSMutableArray *_datas;
}

- (void)reloadViewData;

@end
