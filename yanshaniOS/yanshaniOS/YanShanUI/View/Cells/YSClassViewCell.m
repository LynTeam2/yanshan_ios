//
//  YSClassViewCell.m
//  yanshaniOS
//
//  Created by 代健 on 2017/10/8.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSClassViewCell.h"

#import "YSCourseModel.h"

@implementation YSClassViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _coverImgView = [[UIImageView alloc] init];
        _coverImgView.userInteractionEnabled = YES;
        [self addSubview:_coverImgView];
        
        _inforLabel = [[UILabel alloc] init];
        _inforLabel.userInteractionEnabled = YES;
        _inforLabel.numberOfLines = 2;
        _inforLabel.font = [UIFont systemFontOfSize:13];
        _inforLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_inforLabel];
    }
    return self;
}

- (void)layoutSubviews {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    _coverImgView.frame = CGRectMake(0, 0, width, height*0.6);
    _inforLabel.frame = CGRectMake(0, height*0.65, width, height*0.35);
}

- (void)updateClassCellWith:(id)model {
    NSArray *images = @[@"classplaceholder",@"bannerplaceholder"];
    NSInteger index = arc4random()%images.count;
    if ([model isMemberOfClass:[YSCourseModel class]]) {
        YSCourseModel *obj = (YSCourseModel *)model;
        _inforLabel.text = obj.courseName;
        [_coverImgView sd_setImageWithURL:[NSURL URLWithString:obj.icon] placeholderImage:[UIImage imageNamed:@"classplaceholder"]];
        return;
    }
    NSArray *titles = @[@"安全生产教育培训",@"工业企业标准知识讲座"];
    _inforLabel.text = titles[index];
    _coverImgView.image = [UIImage imageNamed:images[index]];
}

@end
