//
//  YSClassViewCell.m
//  yanshaniOS
//
//  Created by 代健 on 2017/10/8.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSClassViewCell.h"

@implementation YSClassViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
        _coverImgView = [[UIImageView alloc] init];
        _coverImgView.userInteractionEnabled = YES;
        [self addSubview:_coverImgView];
        
        _inforLabel = [[UILabel alloc] init];
        _inforLabel.userInteractionEnabled = YES;
        _inforLabel.numberOfLines = 0;
        _inforLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_inforLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    _coverImgView.frame = CGRectMake(0, 0, width, height*0.75);
    _inforLabel.frame = CGRectMake(0, height*0.75, width, height*0.25);
}

- (void)updateClassCellWith:(id)model {
    _coverImgView.backgroundColor = kRandomColor;
    _inforLabel.backgroundColor = kRandomColor;
}

@end
