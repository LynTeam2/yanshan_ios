//
//  YSNewsViewCell.m
//  yanshaniOS
//
//  Created by 代健 on 2017/10/8.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSNewsViewCell.h"

@implementation YSNewsViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
        _coverImgView = [[UIImageView alloc] init];
        _coverImgView.userInteractionEnabled = YES;
        [self addSubview:_coverImgView];
        
        _titleLable = [[UILabel alloc] init];
        _titleLable.userInteractionEnabled = YES;
        _titleLable.numberOfLines = 2;
        [self addSubview:_titleLable];
        
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.numberOfLines = 2;
        _subTitleLabel.userInteractionEnabled = YES;
        [self addSubview:_subTitleLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    
    CGFloat leftSpace = 20;
    CGFloat topSpace = 40;
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    _coverImgView.frame = CGRectMake(leftSpace, topSpace, height-2*topSpace, height-2*topSpace);
    
    _titleLable.frame = CGRectMake(CGRectGetMaxX(_coverImgView.frame)+leftSpace, topSpace,
        width-_coverImgView.frame.size.width-3*leftSpace,
            _coverImgView.frame.size.height/2);
    _subTitleLabel.frame = CGRectMake(CGRectGetMinX(_titleLable.frame), CGRectGetMaxY(_titleLable.frame), CGRectGetWidth(_titleLable.frame), CGRectGetHeight(_titleLable.frame));
    
    _coverImgView.backgroundColor = kRandomColor;
    _titleLable.backgroundColor =  kRandomColor;
    _subTitleLabel.backgroundColor = kRandomColor;
    
}

@end
