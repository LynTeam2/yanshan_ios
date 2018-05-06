//
//  YSHomeReusableView.m
//  yanshaniOS
//
//  Created by 代健 on 2017/10/9.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSHomeReusableView.h"
#import "yanshaniOS-Swift.h"

@interface YSHomeReusableView ()<FSPagerViewDelegate,FSPagerViewDataSource>

@end

@implementation YSHomeReusableView
{
    FSPagerView *_pageView;
    FSPageControl *pageControl;
    UIButton *menuBtns[4];
    NSArray *bannerDatas;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGRect pageFrame = frame;
        pageFrame.size.height -= 125;
        _pageView = [[FSPagerView alloc] initWithFrame:pageFrame];
        _pageView.dataSource = self;
        _pageView.delegate = self;
        [_pageView registerClass:[FSPagerViewCell class] forCellWithReuseIdentifier:@"pageCell"];
        [self addSubview:_pageView];
        pageFrame.origin.y = pageFrame.size.height-120;
        pageControl = [[FSPageControl alloc] initWithFrame:pageFrame];
        [self addSubview:pageControl];
        CGFloat xposition = 20;
        CGFloat yposition = pageFrame.size.height+20;
        CGFloat space = 15;
        CGFloat width = (frame.size.width-20*2-15*3)/4;
        CGFloat height = 130-40;
        NSArray *images = @[@"kechengxuexi", @"zhuanxianglianxi", @"kaoshi", @"falvfagui"];
        NSArray *titles = @[@"课程学习", @"专项练习", @"测评考试", @"法律法规"];
        for (int i = 0; i < 4; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(xposition+(width+space)*i, yposition, width, height);
            [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, height-width, 0)];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(width, -height, 0, 0)];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            menuBtns[i] = btn;
            [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    return self;
}

- (NSInteger)numberOfItemsInPagerView:(FSPagerView *)pagerView {
    return bannerDatas.count;
}

- (FSPagerViewCell *)pagerView:(FSPagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    FSPagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"pageCell" atIndex:index];
    NSDictionary *dic = bannerDatas[index];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"path"]] placeholderImage:[UIImage imageNamed:@"bannerplaceholder"]];
    cell.backgroundColor = kRandomColor;
    return cell;

}

- (void)pagerView:(FSPagerView *)pagerView didSelectItemAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickBannerAtIndex:with:)]) {
        [self.delegate clickBannerAtIndex:index with:nil];
    }
}

- (void)pagerViewDidEndDecelerating:(FSPagerView *)pagerView {
    pageControl.currentPage = pagerView.currentIndex;
}

- (void)clickButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickMenuButton:)]) {
        [self.delegate clickMenuButton:sender];
    }
}

- (void)updateBanners:(NSArray *)banners {
    if (!banners) {
        return;
    }
    bannerDatas = [banners copy];
    pageControl.numberOfPages = bannerDatas.count;
    [_pageView reloadData];
}

@end
