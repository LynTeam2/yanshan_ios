//
//  YSUserInformationEditorViewController.h
//  yanshaniOS
//
//  Created by 代健 on 2018/5/4.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSBaseViewController.h"

typedef NS_ENUM(NSUInteger, UserInformationType) {
    UserInformationTypeUserName = 0,
    UserInformationTypePassword,
};

@interface YSUserInformationEditorViewController : YSBaseViewController

@property(nonatomic, assign) UserInformationType type;

@end
