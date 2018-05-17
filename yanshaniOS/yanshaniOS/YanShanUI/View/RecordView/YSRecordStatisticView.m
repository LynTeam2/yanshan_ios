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
    CGFloat percent;
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
    percentageLabel.text = @"--";
    percentageLabel.font = [UIFont systemFontOfSize:14.f];
    percentageLabel.textColor = [UIColor grayColor];
    percentageLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:percentageLabel];
    
    amountLabel = [[UILabel alloc] init];
    amountLabel.font = [UIFont systemFontOfSize:14.f];
    amountLabel.text = @"0";
    amountLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:amountLabel];
    
}

- (void)updateConstraints {
    
    [categoryLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(100, 30));
        make.bottom.equalTo(self);
    }];
    [progressBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(categoryLabel.mas_right);
        make.right.equalTo(self).offset(-100);
        make.height.mas_equalTo(8);
        make.bottom.equalTo(self).offset(-8);
    }];
    CGFloat progressWidth = [UIScreen mainScreen].bounds.size.width - 200;
    [progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(categoryLabel.mas_right);
        make.width.mas_equalTo(progressWidth*percent);
        make.height.mas_equalTo(8);
        make.bottom.equalTo(self).offset(-8);
    }];
    [percentageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(progressView.mas_right);
        make.bottom.equalTo(progressView.mas_top);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (void)updateContentUseStatisticData:(YSExaminationItemModel *)model withViewType:(YSRecordStatisticViewType)type {
    if (type == YSRecordStatisticViewTypeSimple) {
        categoryLabel.text = @"单选";
        percent = ([model getSCItem].count - [model getAllWrongSCItem].count - [model getAllUndoSCItem].count)/(CGFloat)[model getSCItem].count;
        amountLabel.text = [NSString stringWithFormat:@"%ld",[model getSCItem].count];
    } else if (type == YSRecordStatisticViewTypeMultable) {
        categoryLabel.text = @"多选";
        percent = ([model getMCItem].count - [model getAllWrongMCItem].count - [model getAllUndoMCItem].count)/(CGFloat)[model getMCItem].count;
        amountLabel.text = [NSString stringWithFormat:@"%ld",[model getMCItem].count];
    } else {
        categoryLabel.text = @"判断";
        percent = ([model getTFItem].count - [model getAllWrongTFItem].count - [model getAllUndoTFItem].count)/(CGFloat)[model getTFItem].count;
        amountLabel.text = [NSString stringWithFormat:@"%ld",[model getTFItem].count];
    }
    percent = isnan(percent) ? 0 :  percent;
    percentageLabel.text = [NSString stringWithFormat:@"%.0f%%",percent*100];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
//    [self layoutIfNeeded];
}

@end


@implementation YSRecordStatisticButton
{
    UIButton *button;
    UIImageView *imageView;
    UILabel *titleLabel;
    UILabel *subLabel;
}

- (instancetype)initWithStatisticButtonType:(StatisticButtonType)type {
    self = [super init];
    if (self) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        [self initSubViews];
        [self setImageIcon:type];
    }
    return self;
}

- (void)setImageIcon:(StatisticButtonType)type {
    NSString *imageName = @"newwrong";
    switch (type) {
        case StatisticButtonTypeDefault:
            
            break;
        case StatisticButtonTypeSC:
            imageName = @"newsc";
            break;
        case StatisticButtonTypeMC:
            imageName = @"newmc";
            break;
        case StatisticButtonTypeTF:
            imageName = @"newtf";
            break;
        default:
            break;
    }
    imageView.image = [UIImage imageNamed:imageName];
}

- (void)initSubViews {
    
    imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"查看错题";
    [self addSubview:titleLabel];
    
    subLabel = [[UILabel alloc] init];
    subLabel.text = @"做错-题,未做-题";
    subLabel.textColor = [UIColor grayColor];
    subLabel.font = [UIFont systemFontOfSize:11.f];
    [self addSubview:subLabel];
}

- (void)updateButtonContentWithData:(NSDictionary *)dic {
    imageView.image = [UIImage imageNamed:dic[@"image"]];
    titleLabel.text = dic[@"title"];
    subLabel.adjustsFontSizeToFitWidth = YES;
    subLabel.text = dic[@"subtitle"];
}

- (void)addTarget:(id)target andSel:(SEL)sel {
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
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
        make.bottom.equalTo(self.mas_centerY).offset(-5);
        make.height.equalTo(subLabel);
    }];
    
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self.mas_centerY).offset(5);
        make.height.equalTo(titleLabel);
    }];
}

@end







