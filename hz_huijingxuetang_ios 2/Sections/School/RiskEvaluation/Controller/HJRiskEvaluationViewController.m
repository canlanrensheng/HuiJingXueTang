//
//  HJRiskEvaluationViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/21.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJRiskEvaluationViewController.h"
#import "HJRiskEvaluationTitleCell.h"
#import "HJRiskEvaluationAnswerCell.h"
#import "YSProgressView.h"
#import "HJRiskEvaluationViewModel.h"

#import "HJRiskEvaluationModel.h"

@interface HJRiskEvaluationViewController ()

@property (nonatomic,strong) YSProgressView *procress;
@property (nonatomic,strong) UILabel *pageCountLabel;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIButton *lastItemButton;

//警告试图
@property (nonatomic,strong) UIView *warnHeaderView;

@property (nonatomic,strong) HJRiskEvaluationViewModel *viewModel;

@property (nonatomic,strong) NSMutableArray *selectMarr;


@end

@implementation HJRiskEvaluationViewController

- (NSMutableArray *)selectMarr {
    if(!_selectMarr){
        _selectMarr = [NSMutableArray array];
    }
    return _selectMarr;
}

- (HJRiskEvaluationViewModel *)viewModel {
    if (!_viewModel){
        _viewModel = [[HJRiskEvaluationViewModel alloc] init];
    }
    return _viewModel;
}

- (UIButton *)lastItemButton {
    if(!_lastItemButton) {
        _lastItemButton = [UIButton creatButton:^(UIButton *button) {
            button.ljTitle_font_titleColor_state(@"上一题",MediumFont(font(13)),HEXColor(@"#999999"),0);
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                [self.selectMarr removeLastObject];
                [DCURLRouter popViewControllerAnimated:YES];
            }];
        }];
        [_lastItemButton clipWithCornerRadius:kHeight(5.0) borderColor:HEXColor(@"#999999") borderWidth:kHeight(1.0)];
    }
    return  _lastItemButton;
}

- (UIView *)warnHeaderView {
    if(!_warnHeaderView){
        _warnHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kHeight(30))];
        _warnHeaderView.backgroundColor = HEXColor(@"#EB5050");
        UILabel *warnTitleLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"温馨提示：首次购买需进行风险评估，请根据自身情况如实填写!",MediumFont(font(11)),white_color);
            label.textAlignment = NSTextAlignmentLeft;
            label.numberOfLines = 0;
            [label sizeToFit];
        }];
        [_warnHeaderView addSubview:warnTitleLabel];
        [warnTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_warnHeaderView);
            make.left.equalTo(_warnHeaderView).offset(kWidth(10));
        }];
    }
    return _warnHeaderView;
    
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kHeight(84))];
        
        YSProgressView *progress = [[YSProgressView alloc] initWithFrame:CGRectMake(0, kHeight(40), kWidth(110), kHeight(7.0))];
        progress.progressHeight = kHeight(7.0);
        progress.trackTintColor = HEXColor(@"#22476B");
        progress.progressTintColor = RGBA(0, 0, 0, 0.1);
        [_headerView addSubview:progress];
        progress.centerX = _headerView.centerX;
        
        self.procress = progress;
        
        UILabel *pageCountLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"",MediumFont(font(10)),HEXColor(@"#999999"));
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
        }];
        pageCountLabel.frame = CGRectMake(0, CGRectGetMaxY(progress.frame) + kHeight(10), kWidth(40), kHeight(11));
        [_headerView addSubview:pageCountLabel];
        pageCountLabel.centerX = _headerView.centerX;
        
        self.pageCountLabel = pageCountLabel;
        
    }
    return _headerView;
}

- (void)hj_setNavagation {
    self.title = @"风险评估";
    NSArray *selectArray = self.params[@"selectMarr"];
    [self.selectMarr addObjectsFromArray:selectArray];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 26, 40);
    [backButton setImage:[UIImage imageNamed:@"导航返回按钮"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backSelf) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarItem1 = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItems = @[leftBarItem1];
}

- (void)backSelf {
     [DCURLRouter popToRootViewControllerAnimated:YES];
}


- (void)hj_configSubViews{
    self.tableView.backgroundColor = white_color;
    self.numberOfSections = 1;
    self.sectionFooterHeight = 0.001f;
    [self.tableView registerClass:[HJRiskEvaluationTitleCell class] forCellReuseIdentifier:NSStringFromClass([HJRiskEvaluationTitleCell class])];
    [self.tableView registerClassCell:[HJRiskEvaluationAnswerCell class]];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.tableView.tableHeaderView = self.headerView;
}

- (void)hj_loadData {
    //获取风险评估的问题的列表
    [self.viewModel.loadingView startAnimating];
    [self.viewModel getRiskEvaluationListWithSuccess:^(BOOL successFlag) {
        [self.viewModel.loadingView stopLoadingView];
        NSString *page = self.params[@"index"];
        self.procress.progressValue = (page.integerValue + 1) * kWidth(110) / self.viewModel.riskEvaluationListArray.count;
        self.pageCountLabel.text = [NSString stringWithFormat:@"%ld/%ld",page.integerValue + 1,self.viewModel.riskEvaluationListArray.count];
        if (page.integerValue != 0) {
            [self.view addSubview:self.lastItemButton];
            [self.lastItemButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view);
                make.bottom.equalTo(self.view).offset(-kHeight(59));
                make.size.mas_equalTo(CGSizeMake(kWidth(110), kHeight(40)));
            }];
        } else {
            [self.view addSubview:self.warnHeaderView];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSString *page = self.params[@"index"];
        Question *model = self.viewModel.riskEvaluationListArray[page.integerValue];
        return model.questionCellHeight;
    }
    NSString *page = self.params[@"index"];
    Question *model = self.viewModel.riskEvaluationListArray[page.integerValue];
    Answer *answerModel = model.answer[indexPath.row];
    return answerModel.answerCellHeight + kHeight(24.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    NSString *page = self.params[@"index"];
    Question *model = self.viewModel.riskEvaluationListArray[page.integerValue];
    return model.answer.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HJRiskEvaluationTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJRiskEvaluationTitleCell class]) forIndexPath:indexPath];
        self.tableView.separatorColor = clear_color;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *page = self.params[@"index"];
        Question *model = self.viewModel.riskEvaluationListArray[page.integerValue];
        NSString *questionDes = [NSString stringWithFormat:@"%@：%@",model.classname,model.questionname];
        cell.titleTextLabel.attributedText = [questionDes attributeWithStr:[NSString stringWithFormat:@"%@：",model.classname] color:HEXColor(@"#22476B") font:BoldFont(font(14))];
        
//        cell.backgroundColor = red_color;
        return cell;
    }
    HJRiskEvaluationAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJRiskEvaluationAnswerCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = clear_color;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *page = self.params[@"index"];
    Question *model = self.viewModel.riskEvaluationListArray[page.integerValue];
    if (indexPath.row < model.answer.count) {
        Answer *answerModel = model.answer[indexPath.row];
        cell.model = answerModel;
    }
//    cell.backgroundColor = blue_color;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    kRepeatClickTime(1.0);
     NSString *page = self.params[@"index"];
    if(indexPath.section == 1 ) {
        if(page.integerValue != self.viewModel.riskEvaluationListArray.count - 1) {
            NSString *page = self.params[@"index"];
            Question *model = self.viewModel.riskEvaluationListArray[page.integerValue];
            Answer *answerModel = model.answer[indexPath.row];
            [self.selectMarr addObject:answerModel.answerid];
            
            DLog(@"获取到的选中的答案的ids是:%@",self.selectMarr);
            NSDictionary *para = @{@"index" : [NSString stringWithFormat:@"%ld",page.integerValue + 1],@"selectMarr" : self.selectMarr
                                   };
            [DCURLRouter pushURLString:@"route://riskEvaluationVC" query:para animated:YES];
        } else {
            NSString *page = self.params[@"index"];
            Question *model = self.viewModel.riskEvaluationListArray[page.integerValue];
            Answer *answerModel = model.answer[indexPath.row];
            [self.selectMarr addObject:answerModel.answerid];
            
            DLog(@"获取到的选中的答案的ids是:%@",self.selectMarr);
            //提交风险评估的数据操作
            NSString *ids = [self.selectMarr componentsJoinedByString:@","];
//            ShowHint(@"正在提交...");
            [self.viewModel submmitRiskEvaluationDataWithAnserids:ids Success:^{
//                hideHud();
                [APPUserDataIofo getEval:@"1"];
                ShowMessage(@"评估成功");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [DCURLRouter popToRootViewControllerAnimated:YES];
                });
            }];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

#pragma mark 数据为空的占位视图
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"绝技诊股空白页"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂时还没有内容哦";
    NSDictionary *attribute = @{NSFontAttributeName: MediumFont(font(15)), NSForegroundColorAttributeName: HEXColor(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}






@end
