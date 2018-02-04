//
//  YSExaminationItemViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2017/12/31.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSExaminationItemViewController.h"

@interface YSExaminationItemViewController ()<UITableViewDelegate,UITableViewDataSource,YSExaminationChoiceCellDelegate>
{
    UITableView *mainView;
    NSIndexPath *selectIndexPath;
    BOOL showAWS;
}
@end

@implementation YSExaminationItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - config view controller

- (void)configViewControllerParameter {
    
}

- (void)configView {
    mainView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    mainView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainView.delegate = self;
    mainView.dataSource = self;
    [self.view addSubview:mainView];
}

- (void)configContainer {
    
}

- (void)addNavigationItems {
    
}

#pragma mark - UITableView delegate - datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1+1+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 == indexPath.row) {
        return 160;
    }
    if (2 == indexPath.row) {
        return 300;
    }
    return 44*[_itemModel getItemChoices].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.textLabel.numberOfLines = 0;
            }
            cell.userInteractionEnabled = NO;
            cell.textLabel.text = _itemModel.question;
            return cell;
        }
            break;
        case 1:{
            
            YSExaminationChoiceCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"choicescell"];
            if (cell == nil) {
                cell = [[YSExaminationChoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"choicescell"];
                cell.delegate = self;
            }
            [cell createChoiceButton:[_itemModel getItemChoices]];
            cell.mcChoice = [_itemModel.questionType isEqualToString:@"mc"];
            if (cell.mcChoice) {
                cell.rightChoices = [_itemModel getMCAnswer];
            }else{
                cell.rightIndex = [_itemModel getSMAnswerOrTFAnswer];
            }
            return cell;
        }
            break;
            
        case 2:{
            YSExaminationItemReslutsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultscell"];
            if (cell == nil) {
                cell = [[YSExaminationItemReslutsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"resultscell"];
            }
            [cell updateAwsChoice:_itemModel.answer];
            [cell updateAwsAnalysis:_itemModel.analysis];
            [cell showResults:showAWS];
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (selectIndexPath.row != indexPath.row) {
//        return;
//    }
    selectIndexPath = indexPath;
//    UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];
//    selectCell.selected = YES;
//    _itemModel.selectItems = @[[NSNumber numberWithInteger:indexPath.row]];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectAnwser:)]) {
        [self.delegate selectAnwser:self];
    }
}

- (void)selectChoice:(NSInteger)selectIndex isRight:(BOOL)right {
    self.selectChoice = selectIndex;
    self.isRight = right;
    if (right == NO) {
        showAWS = YES;
        [mainView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectAnwser:)]) {
        [self.delegate selectAnwser:self];
    }
}

@end

@implementation YSExaminationChoiceCell
{
    NSMutableArray *choiceButtons;
    UIButton *iconButtons[4];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        choiceButtons = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)createChoiceButton:(NSArray *)choices {
    [choiceButtons removeAllObjects];
    [choiceButtons addObjectsFromArray:choiceButtons];
    CGFloat height = 44;
    CGFloat width = self.frame.size.width;
    NSArray *titles = @[@"A",@"B",@"C",@"D"];
    for (int i = 0; i < choices.count; i++) {
        UIButton *sender = [UIButton buttonWithType:UIButtonTypeCustom];
        [sender setTitle:choices[i] forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        sender.frame = CGRectMake(20, height*i, width-40, height);
        sender.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [sender addTarget:self action:@selector(selectChoice:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        iconButton.frame = CGRectMake(0, 5, height-10, height-10);
        [iconButton setTitle:titles[i] forState:UIControlStateNormal];
        [iconButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        iconButton.layer.borderColor = [UIColor grayColor].CGColor;
        iconButton.layer.borderWidth = 0.5;
        iconButton.layer.cornerRadius = height/2 - 5;
        iconButton.layer.masksToBounds = YES;
        [sender addSubview:iconButton];
        
        iconButtons[i] = iconButton;
        [sender setTitleEdgeInsets:UIEdgeInsetsMake(0, height-15, 0, 0)];
        [self.contentView addSubview:sender];
        [choiceButtons addObject:sender];
    }
}

- (void)selectChoice:(UIButton *)sender {
    sender.selected = YES;
    
    for (int i = 0; i < choiceButtons.count; i++) {
        if ([sender isEqual:choiceButtons[i]]) {
            if (_rightChoices.count) {
                for (int j = 0; j < _rightChoices.count; j++) {
                    NSString *str1 = _rightChoices[j];
                    NSString *str2 = [choiceButtons[i] currentTitle];
                    NSString *imageName = [str2 containsString:str1] ? @"rchoice" : @"wchoice";
                    [iconButtons[i] setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                    [iconButtons[i] setTitle:@" " forState:UIControlStateNormal];
                }
                
            }else{
                NSString *imageName = _rightIndex == i ? @"rchoice" : @"wchoice";
                [iconButtons[i] setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                [iconButtons[_rightIndex] setBackgroundImage:[UIImage imageNamed:@"rchoice"] forState:UIControlStateNormal];
                [iconButtons[i] setTitle:@" " forState:UIControlStateNormal];
                [iconButtons[_rightIndex] setTitle:@" " forState:UIControlStateNormal];
                BOOL isRight = _rightIndex == i ? YES : NO;
                if ([self.delegate respondsToSelector:@selector(selectChoice:isRight:)]&& self.delegate) {
                    [self.delegate selectChoice:i isRight:isRight];
                }
                self.userInteractionEnabled = NO;
            }
        }
    }
}

@end

@implementation YSExaminationItemReslutsCell
{
    UILabel *titleLabel;
    UILabel *anwserLabel;
    UILabel *nanduLabel;
    UILabel *contentLabel;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"------------ 试题详解 ------------";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    
    anwserLabel = [[UILabel alloc] init];
    anwserLabel.text = @"答案 B";
    [self.contentView addSubview:anwserLabel];
    
    nanduLabel = [[UILabel alloc] init];
    nanduLabel.text = @"难度 🌟🌟🌟🌟🌟🌟";
    nanduLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:nanduLabel];
    
    contentLabel = [[UILabel alloc] init];
    contentLabel.text = @"标签为页面上的所有链接规定默认地址或默认目标。通常情况下，浏览器会从当前文档的 URL 中提取相应的元素来填写相对 URL 中的空白。";
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
}

- (void)layoutSubviews {
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(40);
    }];
    [anwserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView.mas_centerX);
        make.height.mas_equalTo(40);
    }];
    [nanduLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom);
        make.left.equalTo(self.contentView.mas_centerX);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(40);
    }];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nanduLabel.mas_bottom);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
}

- (void)updateAwsChoice:(NSString *)awsChoice {
    anwserLabel.text = [NSString stringWithFormat:@"答案: %@",awsChoice];
}

- (void)updateAwsAnalysis:(NSString *)analysis {
    contentLabel.text = analysis;
}

- (void)showResults:(BOOL)awsbool {
    titleLabel.hidden = !awsbool;
    anwserLabel.hidden = !awsbool;
    nanduLabel.hidden = !awsbool;
    contentLabel.hidden = !awsbool;
}

@end

