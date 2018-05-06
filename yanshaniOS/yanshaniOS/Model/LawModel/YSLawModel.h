//
//  YSLawModel.h
//  yanshaniOS
//
//  Created by 代健 on 2018/5/5.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface YSLawModel : JSONModel

@property (nonatomic, assign) NSInteger lawID;

@property (nonatomic, strong) NSString *createTime;

@property (nonatomic, strong) NSString *updateTime;

@property (nonatomic, strong) NSString *iconPath;

@property (nonatomic, strong) NSString *fileName;

@property (nonatomic, strong) NSString *filePath;

@property (nonatomic, strong) NSString *lawName;

@property (nonatomic, assign) NSInteger lawType;


@end
