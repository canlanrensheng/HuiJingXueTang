//
//  HJAddAccountViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJAddAccountViewController.h"
#import "HJAddAccountViewModel.h"
#import "HJAddAccountMessageCell.h"
@interface HJAddAccountViewController ()

@property (nonatomic,strong) HJAddAccountViewModel *viewModel;
@property (nonatomic,strong) UIButton *sureAddBtn;

@end

@implementation HJAddAccountViewController

- (HJAddAccountViewModel *)viewModel {
    if (!_viewModel){
        _viewModel = [[HJAddAccountViewModel alloc] init];
    }
    return  _viewModel;
}

- (void)hj_setNavagation {
    self.title = @"添加账户";
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 26, 40);
    [backButton setImage:[UIImage imageNamed:@"导航返回按钮"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backSelf) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarItem1 = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(32, 0, 26, 40);
    [closeButton setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarItem2 = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.leftBarButtonItems = @[leftBarItem1,leftBarItem2];
}

- (void)backSelf {
    [DCURLRouter popViewControllerAnimated:YES];
}

- (void)closeSelf {
    [DCURLRouter popToRootViewControllerAnimated:YES];
}

- (void)hj_configSubViews{
    //    self.tableView.scrollEnabled = NO;
    self.numberOfSections = 1;
    
    self.sectionFooterHeight = 0.001f;
    
    [self.tableView registerClass:[HJAddAccountMessageCell class] forCellReuseIdentifier:NSStringFromClass([HJAddAccountMessageCell class])];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //设置footerView
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kHeight(65))];
    footerView.backgroundColor = clear_color;
    //确认添加的按钮
    UIButton *sureAddBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"确认添加",MediumFont(font(13)),white_color,0);
        button.backgroundColor = HEXColor(@"#22476B");
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            self.viewModel.type = [NSString stringWithFormat:@"%@",self.params[@"type"]];
            [self.viewModel addAccountWithSuccess:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    ShowMessage(@"提交成功");
                });
                RACSubject *subject = self.params[@"subject"];
                [subject sendNext:nil];
                [DCURLRouter popViewControllerAnimated:YES];
            }];
            
        }];
    }];
    sureAddBtn.layer.shadowColor = [UIColor colorWithRed:34/255.0 green:71/255.0 blue:107/255.0 alpha:0.25].CGColor;
    sureAddBtn.layer.shadowOffset = CGSizeMake(0,9);
    sureAddBtn.layer.shadowOpacity = 1;
    sureAddBtn.layer.shadowRadius = 10;
    sureAddBtn.layer.cornerRadius = 2.5;
    
    [footerView addSubview:sureAddBtn];
    [sureAddBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView).offset(kHeight(25));
        make.left.equalTo(footerView).offset(kWidth(10));
        make.right.equalTo(footerView).offset(-kWidth(10));
        make.height.mas_equalTo(kHeight(40));
    }];
   
    self.sureAddBtn = sureAddBtn;
    self.sureAddBtn.userInteractionEnabled = NO;
    self.sureAddBtn.backgroundColor = HEXColor(@"#DDDDDD");
    
    self.tableView.tableFooterView = footerView;
}

- (void)hj_loadData {
    
}

- (void)hj_bindViewModel {
    //添加KVO监听
    [self.viewModel addObserver:self forKeyPath:@"accountname" options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld context:NULL];
    [self.viewModel addObserver:self forKeyPath:@"phoneNum" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [self.viewModel addObserver:self forKeyPath:@"name"options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
        if(self.viewModel.accountname.length > 0  && self.viewModel.phoneNum.length > 0 && self.viewModel.name.length > 0){
        self.sureAddBtn.userInteractionEnabled = YES;
        [self.sureAddBtn setBackgroundColor:HEXColor(@"#22476B")];
    } else {
        self.sureAddBtn.userInteractionEnabled = NO;
        self.sureAddBtn.backgroundColor = HEXColor(@"#DDDDDD");
    }
}

//移除观察者
- (void)dealloc{
    [self.viewModel removeObserver:self forKeyPath:@"accountname"];
    [self.viewModel removeObserver:self forKeyPath:@"phoneNum"];
    [self.viewModel removeObserver:self forKeyPath:@"name"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  kHeight(45.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJAddAccountMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJAddAccountMessageCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = HEXColor(@"#EAEAEA");
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.messageTextLabel.text = @"账户名";
        NSInteger type = [self.params[@"type"] intValue];
        if(type == 1) {
            cell.messageTf.placeholder = @"请填写支付宝账户名";
        } else {
            cell.messageTf.placeholder = @"请填写微信账户名";
        }
        
    } else if (indexPath.row == 1) {
        cell.messageTextLabel.text = @"手机号";
        cell.messageTf.placeholder = @"请输入手机号";
    } else {
        cell.messageTextLabel.text = @"姓名";
        cell.messageTf.placeholder = @"请输入您的真实姓名";
    }
    [cell setViewModel:self.viewModel indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}


@end

