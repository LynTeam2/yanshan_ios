//
//  YSNewsViewCell.m
//  yanshaniOS
//
//  Created by 代健 on 2017/10/8.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSNewsViewCell.h"

@implementation YSNewsViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
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
        
        _seperateLine = [[UIView alloc] init];
        _seperateLine.backgroundColor = [UIColor grayColor];
        [self addSubview:_seperateLine];
        
        _rightIndicator = [[UIImageView alloc] init];
        _rightIndicator.image = [UIImage imageNamed:@"rightgoicon"];
        _rightIndicator.userInteractionEnabled = YES;
        [self addSubview:_rightIndicator];
    }
    return self;
}

- (void)layoutSubviews {
    
    CGFloat leftSpace = 20;
    CGFloat topSpace = 20;
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    _coverImgView.frame = CGRectMake(leftSpace, topSpace, height-2*topSpace, height-2*topSpace);
    
    _titleLable.frame = CGRectMake(CGRectGetMaxX(_coverImgView.frame)+leftSpace, topSpace,
        width-_coverImgView.frame.size.width-5*leftSpace,
            _coverImgView.frame.size.height/2);
    _subTitleLabel.frame = CGRectMake(CGRectGetMinX(_titleLable.frame), CGRectGetMaxY(_titleLable.frame), CGRectGetWidth(_titleLable.frame), CGRectGetHeight(_titleLable.frame));
    
    _seperateLine.frame = CGRectMake(leftSpace, height-1, width-40, 0.5);
    
    _rightIndicator.frame = CGRectMake(width-leftSpace-16, height/2-15/2, 8, 15);
    
    _coverImgView.backgroundColor = kRandomColor;
    _titleLable.backgroundColor =  kRandomColor;
    _subTitleLabel.backgroundColor = kRandomColor;
    
}

@end
