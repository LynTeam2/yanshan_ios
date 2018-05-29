//
//  YSClassCatogaryCell.m
//  yanshaniOS
//
//  Created by jianjiandai on 2018/3/28.
//  Copyright © 2018年 jiandai. All rights reserved.
//

#import "YSClassCatogaryCell.h"
#import "YSCourseCategoryModel.h"
#import "YSExamModel.h"
#import "YSLawModel.h"
#import "YSCourseModel.h"

@implementation YSClassCatogaryCell
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
        _seperateLine.backgroundColor = kLightGray;
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
    _data = model;
    if([model isMemberOfClass:[YSCourseCategoryModel class]]) {
        YSCourseCategoryModel *obj = (YSCourseCategoryModel *)model;
        _coverImgView.image = [[YSFileManager sharedFileManager] getUnzipFileImageWithImageName:obj.iconName];
        _titleLable.text = obj.categoryName;
        _subTitleLabel.text = obj.introduction;
        return;
    }else if ([model isKindOfClass:[YSExamModel class]]) {
        YSExamModel *obj = (YSExamModel *)model;
        _coverImgView.image = [UIImage imageNamed:@"classplaceholder"];
        _titleLable.text = obj.examName;
        _subTitleLabel.text = obj.introduction;
        return;
    }else if ([model isKindOfClass:[YSLawModel class]]) {
        YSLawModel *law = (YSLawModel *)model;
        _titleLable.text = law.lawName;
        _subTitleLabel.text = law.createTime;
        [_coverImgView sd_setImageWithURL:[NSURL URLWithString:law.iconPath] placeholderImage:[UIImage imageNamed:@"dianyuan"]];
    }else if ([model isKindOfClass:[YSCourseModel class]]) {
        YSCourseModel *courseModel = (YSCourseModel *)model;
        _titleLable.text = courseModel.courseName;
        _subTitleLabel.text = courseModel.ajType;
        [_coverImgView sd_setImageWithURL:[NSURL URLWithString:courseModel.icon] placeholderImage:[UIImage imageNamed:@"dianyuan"]];
    }
}


@end
