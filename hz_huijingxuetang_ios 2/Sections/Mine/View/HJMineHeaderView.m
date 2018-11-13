//
//  HJMineHeaderView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/7.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMineHeaderView.h"

@interface HJMineHeaderView ()

@property (nonatomic,strong) UIView *teamBackView;

@end

@implementation HJMineHeaderView

- (void)hj_configSubViews {
    
    UIImageView *topView = [[UIImageView alloc] init];
    topView.image = V_IMAGE(@"我的");
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(kHeight(166));
    }];
    
    //通知按钮的操作
    UIButton *notyBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"",H15,white_color,0);
        [button setBackgroundImage:V_IMAGE(@"通知") forState:UIControlStateNormal];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [DCURLRouter pushURLString:@"route://messageVC" animated:YES];
        }];
    }];
    [self addSubview:notyBtn];
    [notyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(11.0));
        make.top.equalTo(self).offset(kHeight(10) + kStatusBarHeight);
//        make.size.mas_equalTo(CGSizeMake(kWidth(24), kHeight(24)));
    }];
    
    UILabel *redBotLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"0",MediumFont(font(11)),white_color);
        [label clipWithCornerRadius:kHeight(7.5) borderColor:nil borderWidth:0];
        label.textAlignment = TextAlignmentCenter;
        label.backgroundColor = HEXColor(@"#FF0000");
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [notyBtn addSubview:redBotLabel];
    [redBotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kWidth(15), kHeight(15)));
        make.left.equalTo(notyBtn.mas_right).offset(-kWidth(5.0));
        make.centerY.equalTo(notyBtn).offset(-kHeight(9.0));
    }];
    
//    if(self.viewModel.notreadednum > 0 ) {
//        self.viewModel.toolView.repleyedRedLabel.hidden = NO;
//        if(self.viewModel.notreadednum < 10) {
//            self.viewModel.toolView.repleyedRedLabel.text = [NSString stringWithFormat:@"%ld",(long)self.viewModel.notreadednum];
//            [self.viewModel.toolView.repleyedRedLabel clipWithCornerRadius:kHeight(7.5) borderColor:nil borderWidth:0];
//            [self.viewModel.toolView.repleyedRedLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(CGSizeMake(kWidth(15), kHeight(15)));
//                make.centerX.equalTo(self.viewModel.toolView.liveButton).offset(kWidth(25));
//                make.centerY.equalTo(self.viewModel.toolView).offset(-kHeight(9.0));
//            }];
//        } else if (self.viewModel.notreadednum < 100) {
//            self.viewModel.toolView.repleyedRedLabel.text = [NSString stringWithFormat:@"%ld",self.viewModel.notreadednum];
//            [self.viewModel.toolView.repleyedRedLabel clipWithCornerRadius:kHeight(7.5) borderColor:nil borderWidth:0];
//            [self.viewModel.toolView.repleyedRedLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(CGSizeMake(kWidth(20), kHeight(15)));
//                make.centerX.equalTo(self.viewModel.toolView.liveButton).offset(kWidth(25));
//                make.centerY.equalTo(self.viewModel.toolView).offset(-kHeight(9.0));
//            }];
//        } else  if(self.viewModel.notreadednum > 99){
//            self.viewModel.toolView.repleyedRedLabel.text = @"99+";
//            [self.viewModel.toolView.repleyedRedLabel clipWithCornerRadius:kHeight(7.5) borderColor:nil borderWidth:0];
//            [self.viewModel.toolView.repleyedRedLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(CGSizeMake(kWidth(28), kHeight(15)));
//                make.centerX.equalTo(self.viewModel.toolView.liveButton).offset(kWidth(25));
//                make.centerY.equalTo(self.viewModel.toolView.liveButton).offset(-kHeight(9.0));
//            }];
//        }
//    } else {
//        self.viewModel.toolView.repleyedRedLabel.hidden = YES;
//    }
    
    //客服按钮
    UIButton *csBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"",H15,white_color,0);
        [button setBackgroundImage:V_IMAGE(@"联系客服") forState:UIControlStateNormal];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            NSURL *url = URL(string(@"telprompt://", @"10086"));
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
    }];
    [self addSubview:csBtn];
    [csBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-kWidth(10.0));
        make.centerY.equalTo(notyBtn);
        make.size.mas_equalTo(CGSizeMake(kWidth(24), kHeight(24)));
    }];
    
    //背景按钮
    UIButton *backViewBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"",H15,white_color,0);
        button.backgroundColor = clear_color;
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            
        }];
    }];
    [self addSubview:backViewBtn];
    [backViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(topView).offset(-kHeight(20.0));
        make.left.right.equalTo(self);
        make.height.mas_offset(kHeight(60));
    }];
    
    //头像
    UIImageView *liveImageV = [[UIImageView alloc] init];
    liveImageV.image = V_IMAGE(@"默认头像");
    [backViewBtn addSubview:liveImageV];
    [liveImageV clipWithCornerRadius:kHeight(30.0) borderColor:white_color borderWidth:kHeight(1.0)];
    [liveImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(11));
        make.bottom.equalTo(backViewBtn);
        make.size.mas_equalTo(CGSizeMake(kWidth(60), kHeight(60)));
    }];
    
    //名称
    UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"慧明智行",MediumFont(font(17)),white_color);
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [backViewBtn addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(liveImageV).offset(kHeight(11));
        make.left.equalTo(liveImageV.mas_right).offset(kWidth(11.0));
        make.height.mas_offset(kHeight(16));
    }];
    
    //会员等级图片
    UIImageView *vipLevelImageV = [[UIImageView alloc] init];
//    vipLevelImageV.image = V_IMAGE(@"学习小组");
    [backViewBtn addSubview:vipLevelImageV];
    [vipLevelImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).offset(kWidth(12));
        make.centerY.equalTo(nameLabel);
    }];
    
    //成员名称
    UILabel *vipLevelLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"普通会员",MediumFont(font(13)),white_color);
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [backViewBtn addSubview:vipLevelLabel];
    [vipLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(10));
        make.left.equalTo(nameLabel);
        make.height.mas_offset(kHeight(13));
    }];
    
    //箭头的按钮
    UIButton *arrowBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"",H15,white_color,0);
        [button setBackgroundImage:V_IMAGE(@"形状 837") forState:UIControlStateNormal];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            
        }];
    }];
    [backViewBtn addSubview:arrowBtn];
    [arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backViewBtn);
        make.right.equalTo(backViewBtn).offset(-kWidth(10.0));
    }];
    
    //下边的
    [self addSubview:self.teamBackView];
    [self.teamBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(kHeight(100.0));
    }];
}

- (UIView *)teamBackView{
    if(!_teamBackView){
        _teamBackView = [[UIView alloc] init];
        _teamBackView.backgroundColor = white_color;
        CGFloat width = Screen_Width / 3;
        CGFloat height = kHeight(100.0);
        NSArray *moneyTextArray = @[@"我的课程",@"学习小组",@"推广赚钱"];
        NSArray *moneyImgArray = @[@"我的课程",@"学习小组",@"我的钱包"];
        for(int i = 0 ;i < 3;i++){
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake((width + 1) * i, 0, width, height)];
            backView.tag = i + 10;
            [_teamBackView addSubview:backView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
            [backView addGestureRecognizer:tap];
            
            UIImageView *teamImageView = [[UIImageView alloc] init];
            teamImageView.image = V_IMAGE(moneyImgArray[i]);
            [backView addSubview:teamImageView];
            [teamImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(backView);
                make.size.mas_equalTo(CGSizeMake(kWidth(56), kWidth(56)));
                make.top.equalTo(backView).offset(kHeight(15));
            }];
            
            UILabel *moneyLabel = [UILabel creatLabel:^(UILabel *label) {
                label.ljTitle_font_textColor(moneyTextArray[i],MediumFont(font(14)),HEXColor(@"#333333"));
                label.textAlignment = TextAlignmentCenter;
                [label sizeToFit];
            }];
            [backView addSubview:moneyLabel];
            [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(backView);
                make.height.mas_equalTo(kHeight(13));
                make.top.equalTo(teamImageView.mas_bottom).offset(kHeight(0));
            }];
        }
    }
    return _teamBackView;
}

- (void)tapClick:(UITapGestureRecognizer *)tap{
    UIView *backView = (UIView *)tap.view;
    switch (backView.tag - 10) {
        case 0:{
            //我的课程
            [DCURLRouter pushURLString:@"route://myCourceVC" animated:YES];
        }
            break;
        case 1:{
            //学习小组
           
        }
            break;
            
        default:{
            //推广赚钱
           
        }
            break;
    }
}

@end
