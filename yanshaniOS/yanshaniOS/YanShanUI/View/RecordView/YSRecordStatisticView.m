//
//  YSRecordStatisticView.m
//  yanshaniOS
//
//  Created by 代健 on 2017/12/30.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSRecordStatisticView.h"

@implementation YSRecordStatisticView
{
    UILabel *categoryLabel;
    UIView *progressBgView;
    UIView *progressView;
    UILabel *amountLabel;
    UILabel *percentageLabel;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    categoryLabel = [[UILabel alloc] init];
    categoryLabel.text = @"单选:";
    categoryLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:categoryLabel];
    
    progressBgView = [[UIView alloc] init];
    progressBgView.backgroundColor = kLightGray;
    progressBgView.layer.cornerRadius = 4;
    progressBgView.layer.masksToBounds = YES;
    [self addSubview:progressBgView];
    
    progressView = [[UIView alloc] init];
    progressView.backgroundColor = [UIColor redColor];
    progressView.layer.cornerRadius = 4;
    progressView.layer.masksToBounds = YES;
    [self addSubview:progressView];
    
    percentageLabel = [[UILabel alloc] init];
    percentageLabel.text = @"23";
    percentageLabel.font = [UIFont systemFontOfSize:14.f];
    percentageLabel.textColor = [UIColor grayColor];
    percentageLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:percentageLabel];
    
}

- (void)updateConstraints {
    
    [categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(100, 30));
        make.bottom.equalTo(self);
    }];
    [progressBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(categoryLabel.mas_right);
        make.right.equalTo(self).offset(-100);
        make.height.mas_equalTo(8);
        make.bottom.equalTo(self).offset(-8);
    }];
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(categoryLabel.mas_right);
        make.right.equalTo(self).offset(-160);
        make.height.mas_equalTo(8);
        make.bottom.equalTo(self).offset(-8);
    }];
    [percentageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(progressBgView.mas_right);
        make.right.equalTo(self);
        make.height.mas_equalTo(30);
        make.bottom.equalTo(self);
    }];
    [super updateConstraints];
}

- (void)proccessViewColor:(UIColor *)color {
    progressView.backgroundColor = color;
}

- (void)updateContentUseStatisticData:(NSDictionary *)data withViewType:(YSRecordStatisticViewType)type {
    if (type == YSRecordStatisticViewTypeSimple) {
        progressView.backgroundColor = [UIColor redColor];
    } else if (type == YSRecordStatisticViewTypeMultable) {
        progressView.backgroundColor = [UIColor orangeColor];
    } else {
        progressView.backgroundColor = [UIColor yellowColor];
    }
}

@end


@implementation YSRecordStatisticButton
{
    UIButton *button;
    UIImageView *imageView;
    UILabel *titleLabel;
    UILabel *subLabel;
}

- (instancetype)initWithButtonType:(UIButtonType)type {
    self = [super init];
    if (self) {
        button = [UIButton buttonWithType:type];
        [self addSubview:button];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    
    imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor redColor];
    [self addSubview:imageView];
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"查看错题";
    [self addSubview:titleLabel];
    
    subLabel = [[UILabel alloc] init];
    subLabel.text = @"做错2题,未做96题";
    subLabel.textColor = kLightGray;
    subLabel.font = [UIFont systemFontOfSize:14.f];
    [self addSubview:subLabel];
    
    titleLabel.backgroundColor = kRandomColor;
    subLabel.backgroundColor = kRandomColor;
}

- (void)layoutSubviews {
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self);
        make.height.equalTo(subLabel);
    }];
    
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(10);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self);
        make.height.equalTo(titleLabel);
    }];
}

@end







