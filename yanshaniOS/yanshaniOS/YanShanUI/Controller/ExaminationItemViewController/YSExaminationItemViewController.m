//
//  YSExaminationItemViewController.m
//  yanshaniOS
//
//  Created by 代健 on 2017/12/31.
//  Copyright © 2017年 jiandai. All rights reserved.
//

#import "YSExaminationItemViewController.h"
#import "YSCourseManager.h"

@interface YSExaminationItemViewController ()<UITableViewDelegate,UITableViewDataSource,YSExaminationChoiceCellDelegate>
{
    UITableView *mainView;
    NSIndexPath *selectIndexPath;
    BOOL showAWS;
    NSMutableArray *mcChoices;
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
    mcChoices = [NSMutableArray arrayWithCapacity:0];
}

- (void)configView {
    mainView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    mainView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainView.delegate = self;
    mainView.dataSource = self;
    [self.view addSubview:mainView];
}

#pragma mark - UITableView delegate - datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1+1+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 == indexPath.row) {
        return [_itemModel getQuestionCellHeight]+20;
    }
    if (2 == indexPath.row) {
        return 300;
    }
    return ([_itemModel getAllChoiceHeight])+30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            UITextView *textView = [[UITextView alloc] init];
            textView.font = [UIFont systemFontOfSize:16.f];
            textView.frame = CGRectMake(10, 10, self.view.frame.size.width-20, [_itemModel getQuestionCellHeight]);
            textView.editable = NO;
            NSMutableAttributedString *mattr = [[NSMutableAttributedString alloc] initWithString:[_itemModel getQuestionTypeString] attributes:@{NSBackgroundColorAttributeName:kBlueColor,NSForegroundColorAttributeName:[UIColor whiteColor]}];
            [mattr appendAttributedString:[[NSAttributedString alloc] initWithString:_itemModel.question]];
            [mattr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.f] range:NSMakeRange(0, mattr.string.length)];
            textView.attributedText = mattr;
            [cell addSubview:textView];
            cell.userInteractionEnabled = NO;
            return cell;
        }
            break;
        case 1:{
            
            YSExaminationChoiceCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"choicescell"];
            if (cell == nil) {
                cell = [[YSExaminationChoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"choicescell"];
                cell.delegate = self;
            }
            cell.model = _itemModel;
            [cell createChoiceButton:[_itemModel getItemChoices]];
            cell.mcChoice = [_itemModel.questionType isEqualToString:@"mc"];
            if (cell.mcChoice) {
                cell.rightChoices = [_itemModel getMCAnswer];
            }else{
                cell.rightIndex = [_itemModel getSMAnswerOrTFAnswer];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
            if (showAWS) {
                [cell showMCConfirmButton:NO];
            }else{
                [cell showMCConfirmButton:[_itemModel mcChoiceType]];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addTarget:self confirmChoice:@selector(confirmChoice:)];
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
}

#pragma mark - resultCell delegate

- (void)selectChoice:(NSInteger)selectIndex isRight:(BOOL)right {
    self.selectChoice = selectIndex;
    self.isRight = right;
    if (right == NO) {
        showAWS = YES;
        [[YSCourseManager sharedCourseManager] saveCourseItem:_itemModel];
        [mainView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectAnwser:)]) {
        [self.delegate selectAnwser:self];
    }
}

- (void)selectChoice:(NSArray *)selectIndexs {
    [mcChoices addObjectsFromArray:selectIndexs];
    if (![[selectIndexs firstObject] boolValue]) {
        [self confirmChoice:nil];
    }
}

- (void)confirmChoice:(UIButton *)sender {
    
    //选择选项==争取选项
    BOOL rightBtn = YES;
    for (int i = 0; i < mcChoices.count; i++) {
        if (![mcChoices[i] boolValue]) {
            rightBtn = NO;
            break;
        }
    }
    
    if (mcChoices.count < 2 && rightBtn) {
        [self.view makeToast:@"多选题至少选择2个答案!!!" duration:2.0 position:@"center"];
        return;
    }
    
    UITableViewCell *cell = [mainView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.userInteractionEnabled = NO;
    sender.hidden = YES;
    showAWS = YES;
    [mainView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
    //选择选项和正确选项数目不相等
    if (mcChoices.count != [_itemModel getMCAnswer].count) {
        self.isRight = NO;
        [[YSCourseManager sharedCourseManager] saveCourseItem:_itemModel];
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectAnwser:)]) {
            [self.delegate selectAnwser:self];
        }
        return;
    }
    
    if (!rightBtn) {
        self.isRight = NO;
        [[YSCourseManager sharedCourseManager] saveCourseItem:_itemModel];
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectAnwser:)]) {
            [self.delegate selectAnwser:self];
        }
        return;
    }
    self.isRight = YES;
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
        _selectChoices = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)createChoiceButton:(NSArray *)choices {
    [choiceButtons removeAllObjects];
    [choiceButtons addObjectsFromArray:choiceButtons];

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    NSArray *titles = @[@"A",@"B",@"C",@"D"];
    CGFloat height = 0.0;
    for (int i = 0; i < choices.count; i++) {
        height += i == 0 ? 0 : [_model getChoiceHeight:choices[i-1]];
        height += (i == 0 ? 0 : 5);
        UIButton *sender = [UIButton buttonWithType:UIButtonTypeCustom];
        [sender setTitle:choices[i] forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        sender.frame = CGRectMake(20, height, width-40, [_model getChoiceHeight:choices[i]]);
        sender.titleLabel.font = [UIFont systemFontOfSize:16.f];
        sender.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        sender.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [sender addTarget:self action:@selector(selectChoice:) forControlEvents:UIControlEventTouchUpInside];
        sender.titleLabel.numberOfLines = 0;
        
        UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        iconButton.frame = CGRectMake(0, 5, 34, 34);
        [iconButton setTitle:titles[i] forState:UIControlStateNormal];
        [iconButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        iconButton.layer.borderColor = [UIColor grayColor].CGColor;
        iconButton.layer.borderWidth = 0.5;
        iconButton.layer.cornerRadius = 34/2;
        iconButton.layer.masksToBounds = YES;
        [sender addSubview:iconButton];
        
        [iconButton addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];

        iconButtons[i] = iconButton;
        [sender setTitleEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 0)];
        [self.contentView addSubview:sender];
        [choiceButtons addObject:sender];
    }
}

- (void)select:(UIButton *)sender {
    UIButton *BTN = (UIButton *)sender.superview;
    [self selectChoice:BTN];
}

- (void)selectChoice:(UIButton *)sender {
    sender.selected = YES;
    sender.enabled = NO;
    if (![_model mcChoiceType]) {
        _rightIndex = [_model getSMAnswerOrTFAnswer];
        for (int i = 0; i < choiceButtons.count; i++) {
            if ([sender isEqual:choiceButtons[i]]) {
                NSString *imageName = _rightIndex == i ? @"right" : @"wrong";
                [iconButtons[i] setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                [iconButtons[_rightIndex] setBackgroundImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
                [iconButtons[i] setTitle:@" " forState:UIControlStateNormal];
                [iconButtons[_rightIndex] setTitle:@" " forState:UIControlStateNormal];
                BOOL isRight = _rightIndex == i ? YES : NO;
                if ([self.delegate respondsToSelector:@selector(selectChoice:isRight:)]&& self.delegate) {
                    [self.delegate selectChoice:i isRight:isRight];
                }
                self.userInteractionEnabled = NO;
            }
        }
    }else{
        if (_rightChoices.count) {
            NSString *imageName = @"wrong";
            for (int j = 0; j < _rightChoices.count; j++) {
                NSString *str1 = [_rightChoices[j] stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSString *str2 = [[sender currentTitle] stringByReplacingOccurrencesOfString:@" " withString:@""];
                if ([str2 containsString:str1]) {
                    imageName = @"right";
//                    //TODO:
//                    if (self.delegate && [self.delegate respondsToSelector:@selector(selectChoice:)]) {
//                        [self.delegate selectChoice:@[sender]];
//                    }
                }
            }
            for (int i = 0; i < choiceButtons.count; i++) {
                if ([sender isEqual:choiceButtons[i]]) {
                    [iconButtons[i] setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                    [iconButtons[i] setTitle:@" " forState:UIControlStateNormal];
                    [_selectChoices addObject:choiceButtons[i]];
                }
            }
            //TODO:
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectChoice:)]) {
                BOOL selectValue = [imageName isEqualToString:@"right"] ? YES : NO;
                [self.delegate selectChoice:@[@(selectValue)]];
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
    UITextView *contentView;
    UIButton *mcButton;
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
    anwserLabel.text = @"--";
    [self.contentView addSubview:anwserLabel];
    
    nanduLabel = [[UILabel alloc] init];
    nanduLabel.text = @"难度 🌟🌟🌟🌟🌟🌟";
    nanduLabel.adjustsFontSizeToFitWidth = YES;
    nanduLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:nanduLabel];
    
    contentView = [[UITextView alloc] init];
    contentView.text = @"--";
    contentView.editable = NO;
    [self.contentView addSubview:contentView];
    
    mcButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mcButton setTitle:@"确认答案" forState:UIControlStateNormal];
    [mcButton setBackgroundColor:kBlueColor];
    [self.contentView addSubview:mcButton];
    mcButton.hidden = YES;
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
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nanduLabel.mas_bottom);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    [mcButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(40);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(50);
    }];
}

- (void)updateAwsChoice:(NSString *)awsChoice {
    anwserLabel.text = [[NSString stringWithFormat:@"答案: %@",awsChoice] stringByReplacingOccurrencesOfString:@"choice" withString:@""];
}

- (void)updateAwsAnalysis:(NSString *)analysis {
    contentView.text = analysis;
}

- (void)showResults:(BOOL)awsbool {
    titleLabel.hidden = !awsbool;
    anwserLabel.hidden = !awsbool;
    nanduLabel.hidden = !awsbool;
    contentView.hidden = !awsbool;
}

- (void)showMCConfirmButton:(BOOL)show {
    mcButton.hidden = !show;
}

- (void)addTarget:(id)target confirmChoice:(SEL)choiceSEL {
    [mcButton addTarget:target action:choiceSEL forControlEvents:UIControlEventTouchUpInside];
}

@end

