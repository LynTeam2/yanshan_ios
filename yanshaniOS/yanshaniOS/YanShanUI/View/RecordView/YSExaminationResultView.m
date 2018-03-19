//
//  YSExaminationResultView.m
//  yanshaniOS
//
//  Created by 代健 on 2017/12/31.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSExaminationResultView.h"

@implementation YSExaminationResultView
{
    UILabel *titlesLabel[3];
    UIButton *btn;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headericon"]];
        [self addSubview:iconView];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(25);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = @"用户名";
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:nameLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(iconView.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(160, 20));
        }];
        
        NSArray *titles = @[@{@"title1":@"答对题目",@"title2":@"90分"},
                            @{@"title1":@"是否合格",@"title2":@"合格"},
                            @{@"title1":@"考试时间",@"title2":@"90分钟"}];
        
        for (int i = 0; i < titles.count; i++) {
            NSDictionary *dic = titles[i];
            UILabel *label1 = [[UILabel alloc] init];
            label1.textAlignment = NSTextAlignmentRight;
            label1.text = dic[@"title1"];
            [self addSubview:label1];
            
            UILabel *label2 = [[UILabel alloc] init];
            label2.text = dic[@"title2"];
            [self addSubview:label2];
            titlesLabel[i] = label2;
            [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_centerX).offset(-20);
                make.top.equalTo(self).offset(140 + (40)*i);
                make.size.mas_equalTo(CGSizeMake(160, 20));
            }];
            [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_centerX).offset(20);
                make.top.equalTo(self).offset(140 + (40)*i);
                make.size.mas_equalTo(CGSizeMake(160, 20));
            }];
        }
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"完成考试" forState:UIControlStateNormal];
        [btn setBackgroundColor:kBlueColor];
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-70);
            make.left.equalTo(self).offset(30);
            make.right.equalTo(self).offset(-30);
            make.height.mas_equalTo(40);
        }];
    }
    return self;
}

- (void)updateScoreValue:(NSString *)score costTime:(NSString *)costTime {
    titlesLabel[0].text = score;
    titlesLabel[2].text = costTime;
}

- (void)userPassTheExam:(BOOL)pass {
    titlesLabel[1].text = pass ? @"合格" : @"不合格";
    titlesLabel[1].textColor = pass ? [UIColor blackColor] : [UIColor redColor];
}

- (void)addTarget:(id)target andSEL:(SEL)action {
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
