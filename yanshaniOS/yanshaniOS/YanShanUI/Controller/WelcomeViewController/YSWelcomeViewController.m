//
//  YSWelcomeViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2018/11/16.
//  Copyright © 2018 jiandai. All rights reserved.
//

#import "YSWelcomeViewController.h"

@interface YSWelcomeViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *welcomeView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthContrains;
@property (strong, nonatomic) IBOutlet UIButton *skipButton;
@property (strong, nonatomic) IBOutlet UIButton *enterButton;

@end

@implementation YSWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)configView {
    NSArray *images = @[@"w1",@"w2",@"w3",@"w4"];
    
    CGRect bounds = self.view.bounds;
    
    self.widthContrains.constant = images.count*bounds.size.width;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.skipButton.hidden = YES;
    self.enterButton.hidden = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == (scrollView.contentSize.width-scrollView.bounds.size.width)) {
        self.enterButton.hidden = NO;
    }else{
        self.skipButton.hidden = NO;
    }
}


- (IBAction)enterApp:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNewApp];
    [[NSUserDefaults standardUserDefaults] synchronize];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    [UIApplication sharedApplication].keyWindow.rootViewController = [sb instantiateViewControllerWithIdentifier:@"loginViewController"];
}



@end
