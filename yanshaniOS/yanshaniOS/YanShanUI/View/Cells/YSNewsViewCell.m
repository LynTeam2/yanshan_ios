//
//  YSNewsViewCell.m
//  yanshaniOS
//
//  Created by 代健 on 2017/10/8.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSNewsViewCell.h"

#import "YSCourseCategoryModel.h"

@implementation YSNewsViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _coverImgView = [[UIImageView alloc] init];
        _coverImgView.userInteractionEnabled = YES;
        _coverImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_coverImgView];
        
        _titleLable = [[UILabel alloc] init];
        _titleLable.userInteractionEnabled = YES;
        _titleLable.numberOfLines = 2;
        [self addSubview:_titleLable];
        
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.numberOfLines = 2;
        _subTitleLabel.font = [UIFont systemFontOfSize:13];
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
}

- (void)updateClassInformation:(id)model {
    if([model isMemberOfClass:[YSCourseCategoryModel class]]) {
        YSCourseCategoryModel *obj = (YSCourseCategoryModel *)model;
        _coverImgView.image = [[YSFileManager sharedFileManager] getUnzipFileImageWithImageName:obj.iconName];
        _titleLable.text = obj.categoryName;
        _subTitleLabel.text = obj.introduction;
        return;
    }
    NSArray *images = @[@"dianyuan",@"gongyepin",@"jiaotongyunshu",@"renyuanmiji",@"shigongjihua"];
    NSArray *titles = @[@"化学品教学",@"为新品教学",@"工业夹雪",@"人员密集场所教学",@"交通教学"];
    NSInteger index = arc4random() % images.count;
    _coverImgView.image = [UIImage imageNamed:images[index]];
    _titleLable.text = titles[index];
    _subTitleLabel.text = @"课程主要学习相关知识内容，在实际生活中遇到的实际情况等等。";
    
}

@end
