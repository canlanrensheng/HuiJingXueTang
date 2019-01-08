//
//  HJAccountManagerCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJAccountManagerCell.h"
#import "HJAccountManagerViewModel.h"
#import "HJAccountManagerModel.h"

@interface HJAccountManagerCell ()

@property (nonatomic,strong) HJAccountManagerViewModel *listViewModel;
@property (nonatomic,strong) HJAccountManagerModel *model;
@property (nonatomic,strong) UIButton *setDefaultWithDrawBtn;

@end

@implementation HJAccountManagerCell

- (void)hj_configSubViews {
    UIImageView *payImageV = [[UIImageView alloc] init];
    payImageV.image = V_IMAGE(@"支付宝1");
    [self addSubview:payImageV];
    [payImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kWidth(25), kHeight(25)));
    }];
    
    self.payImageV = payImageV;
    
    //提现类型名称
    UILabel *payTypeLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"支付宝",MediumFont(font(11)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:payTypeLabel];
    [payTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payImageV);
        make.left.equalTo(payImageV.mas_right).offset(kWidth(10.0));
        make.height.mas_equalTo(kHeight(11));
    }];
    
    self.payTypeLabel = payTypeLabel;
    
    //支付宝名称
    UILabel *payNameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"rexyehaiahi@gmail.com",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:payNameLabel];
    [payNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payTypeLabel.mas_bottom).offset(kHeight(5));
        make.left.equalTo(payTypeLabel);
        make.height.mas_equalTo(kHeight(11));
    }];
    self.payNameLabel = payNameLabel;
    
    //解绑的按钮
    UIButton *unBindBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"解绑",MediumFont(font(13)),HEXColor(@"#22476B"),0);
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [TXAlertView showAlertWithTitle:@"温馨提示" message:@"确认要解绑吗?" cancelButtonTitle:@"取消" style:TXAlertViewStyleAlert buttonIndexBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    self.listViewModel.accountId = self.model.acccountId;
                    self.listViewModel.type = [NSString stringWithFormat:@"%ld",self.model.type];
                    [self.listViewModel removeaccountWithSuccess:^{
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            //刷新列表
                            ShowMessage(@"解绑成功");
                            [self.backSub sendNext:nil];
                        });
                    }];
                }
            } otherButtonTitles:@"确定", nil];
        }];
    }];
    [self addSubview:unBindBtn];
    [unBindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-kWidth(10.0));
        make.height.mas_equalTo(kHeight(13));
    }];
    
    self.unBindBtn = unBindBtn;
    
    //设置为默认的提现账户
    UIButton *setDefaultWithDrawBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"当前提现账户",MediumFont(font(13)),HEXColor(@"#999999"),0);
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            __weak typeof(self)weakSelf = self;
            self.listViewModel.accountId = self.model.acccountId;
            [self.listViewModel setDefaultaccountWithSuccess:^{
                ShowMessage(@"设置默认打款账户成功");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.backSub sendNext:nil];
                });
            }];
        }];
    }];
    [self addSubview:setDefaultWithDrawBtn];
    [setDefaultWithDrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.unBindBtn.mas_left).offset(-kWidth(20.0));
    }];
    
    self.setDefaultWithDrawBtn = setDefaultWithDrawBtn;
}

- (RACSubject *)backSub {
    if (!_backSub){
        _backSub = [[RACSubject alloc] init];
    }
    return _backSub;
}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    HJAccountManagerViewModel *listViewModel = (HJAccountManagerViewModel *)viewModel;
    HJAccountManagerModel *model = listViewModel.accountManagerArray[indexPath.row];
    self.listViewModel = listViewModel;
    self.model = model;
    if (model.type == 1) {
        self.payImageV.image = V_IMAGE(@"支付宝1");
        self.payTypeLabel.text = @"支付宝";
        if(model.bingdingstatus == 1) {
            //已经绑定
            self.unBindBtn.hidden = NO;
            self.payNameLabel.text = model.accountname;
            if (model.defaultstatus == 1) {
                //默认的提现的账户
                self.setDefaultWithDrawBtn.hidden = NO;
                self.setDefaultWithDrawBtn.userInteractionEnabled = NO;
                [self.setDefaultWithDrawBtn setTitle:@"当前提现账户" forState:UIControlStateNormal];
                [self.setDefaultWithDrawBtn setTitleColor:HEXColor(@"#999999") forState:UIControlStateNormal];
                self.setDefaultWithDrawBtn.titleLabel.font = MediumFont(font(13));
            } else {
                self.setDefaultWithDrawBtn.hidden = NO;
                self.setDefaultWithDrawBtn.userInteractionEnabled = YES;
                [self.setDefaultWithDrawBtn setTitle:@"设置为提现账户" forState:UIControlStateNormal];
                [self.setDefaultWithDrawBtn setTitleColor:HEXColor(@"#22476B") forState:UIControlStateNormal];
                self.setDefaultWithDrawBtn.titleLabel.font = MediumFont(font(13));
            }
        } else {
            self.setDefaultWithDrawBtn.hidden = YES;
            self.unBindBtn.hidden = YES;
            self.payNameLabel.text = @"添加账户";
        }
        
    } else if (model.type == 2){
        self.payImageV.image = V_IMAGE(@"微信支付1");
        self.payTypeLabel.text = @"微信";
        if(model.bingdingstatus == 1) {
            //已经绑定
            if (model.defaultstatus == 1) {
                //默认的提现的账户
                self.setDefaultWithDrawBtn.hidden = NO;
                self.setDefaultWithDrawBtn.userInteractionEnabled = NO;
                [self.setDefaultWithDrawBtn setTitle:@"当前提现账户" forState:UIControlStateNormal];
                [self.setDefaultWithDrawBtn setTitleColor:HEXColor(@"#999999") forState:UIControlStateNormal];
                self.setDefaultWithDrawBtn.titleLabel.font = MediumFont(font(13));
            } else {
                self.setDefaultWithDrawBtn.hidden = NO;
                self.setDefaultWithDrawBtn.userInteractionEnabled = YES;
                [self.setDefaultWithDrawBtn setTitle:@"设置为提现账户" forState:UIControlStateNormal];
                [self.setDefaultWithDrawBtn setTitleColor:HEXColor(@"#22476B") forState:UIControlStateNormal];
                self.setDefaultWithDrawBtn.titleLabel.font = MediumFont(font(13));
            }
            self.unBindBtn.hidden = NO;
            self.payNameLabel.text = model.accountname;
        } else {
            //未绑定
            self.setDefaultWithDrawBtn.hidden = YES;
            self.unBindBtn.hidden = YES;
            self.payNameLabel.text = @"添加账户";
        }
    }
}

@end
