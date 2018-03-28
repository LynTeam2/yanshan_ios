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
        _seperateLine.backgroundColor = kLightGray;
        [self addSubview:_seperateLine];

    }
    return self;
}

- (void)layoutSubviews {
    
    CGFloat leftSpace = 20;
    CGFloat topSpace = 20;
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(leftSpace);
        make.top.equalTo(self).offset(topSpace);
        make.right.equalTo(self).offset(-leftSpace);
        make.height.mas_equalTo(2*topSpace);
    }];
    
    [_coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(leftSpace);
        make.top.equalTo(_titleLable.mas_bottom).offset(topSpace/2);
        make.size.mas_equalTo(CGSizeMake(3*topSpace, 2*topSpace));
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_coverImgView.mas_right).offset(leftSpace/2);
        make.top.equalTo(_coverImgView.mas_top);
        make.right.equalTo(self).offset(-leftSpace);
        make.bottom.equalTo(self).offset(-2*topSpace);
    }];
    _seperateLine.frame = CGRectMake(leftSpace, height-1, width-40, 0.5);
}

- (void)updateClassInformation:(id)model {
    _data = model;
    NSArray *images = @[@"dianyuan",@"gongyepin",@"jiaotongyunshu",@"renyuanmiji",@"shigongjihua"];
    NSInteger index = arc4random() % images.count;
    if ([model isKindOfClass:[NSDictionary class]]) {
        _titleLable.text = [model objectForKey:@"title"];
        _subTitleLabel.text = [model objectForKey:@"introduction"];
    }
    _coverImgView.image = [UIImage imageNamed:images[index]];
}


@end
