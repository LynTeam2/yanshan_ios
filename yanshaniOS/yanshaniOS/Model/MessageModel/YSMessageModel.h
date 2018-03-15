//
//  YSMessageModel.h
//  yanshaniOS
//
//  Created by 代健 on 2017/12/3.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface YSMessageModel : JSONModel

@property (nonatomic, strong) NSString <Optional>*title;

@property (nonatomic, strong) NSString <Optional>*messageDescription;

@property (nonatomic, assign) BOOL isRead;

@end
