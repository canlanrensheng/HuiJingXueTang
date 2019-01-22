//
//  HJTeacherDetailHeaderView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/5.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJTeacherDetailHeaderView.h"
#import "HJTextAndPicButoton.h"
#import "LJAvatarBrowser.h"
@interface HJTeacherDetailHeaderView ()

@property (nonatomic,strong) UIImageView *liveImageV;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *jobLabel;
@property (nonatomic,strong) UIButton *careBtn;
@property (nonatomic,strong) UILabel *fenCountLabel;
@property (nonatomic,strong) UILabel *messageLabel;
@property (nonatomic,strong) HJTextAndPicButoton *detailButton;

@end

@implementation HJTeacherDetailHeaderView

- (void)hj_configSubViews {
    self.backgroundColor = NavigationBar_Color;
    UIImageView *backGroundImageV = [[UIImageView alloc] init];
    backGroundImageV.image = V_IMAGE(@"讲师背景");
    [self addSubview:backGroundImageV];
    [backGroundImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(kHeight(255.0) + kStatusBarHeight);
    }];
    
    //返回的按钮
    UIButton *backBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"",H15,white_color,0);
        [button setImage:V_IMAGE(@"导航返回按钮") forState:UIControlStateNormal];
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [VisibleViewController().navigationController popViewControllerAnimated:YES];
        }];
    }];
    [self addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kStatusBarHeight + kHeight(15));
        make.left.equalTo(self).offset(kWidth(10));
        make.size.mas_equalTo(CGSizeMake(kWidth(24), kHeight(24)));
    }];
    
    
    UIImageView *liveImageV = [[UIImageView alloc] init];
    liveImageV.image = V_IMAGE(@"默认头像");
    liveImageV.userInteractionEnabled = YES;
    [self addSubview:liveImageV];
    [liveImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10));
        make.top.equalTo(self).offset(kHeight(56.0) + kStatusBarHeight);
        make.size.mas_equalTo(CGSizeMake(kWidth(60), kHeight(60)));
    }];
    
    [liveImageV clipWithCornerRadius:kHeight(30.0) borderColor:nil borderWidth:0.0];
    UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTap)];
    [liveImageV addGestureRecognizer:iconTap];
    
    self.liveImageV = liveImageV;
    
    //姓名
    UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"未知",MediumFont(font(20)),white_color);
        label.textAlignment = TextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(liveImageV.mas_bottom).offset(kHeight(20));
        make.left.equalTo(liveImageV);
        make.height.mas_equalTo(kHeight(19));
    }];
    
    self.nameLabel = nameLabel;
    
    //职位名称
    UILabel *jobLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(11)),HEXColor(@"#FBA215"));
        label.textAlignment = TextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:jobLabel];
    [jobLabel clipWithCornerRadius:kHeight(10.0) borderColor:HEXColor(@"#FBA215") borderWidth:kHeight(1.0)];
    [jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).offset(kWidth(10));
        make.centerY.equalTo(nameLabel);
        make.width.mas_equalTo(kHeight(81));
        make.height.mas_equalTo(kHeight(20));
    }];
    
    self.jobLabel = jobLabel;
    
    //关注
    UIButton *careBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"",MediumFont(font(13)),white_color,0);
        [button setBackgroundImage:V_IMAGE(@"点击关注") forState:UIControlStateNormal];
        [button setBackgroundImage:V_IMAGE(@"已关注-1") forState:UIControlStateSelected];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if([APPUserDataIofo AccessToken].length <= 0) {
                [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
                return;
            }
            if (!button.selected) {
                [_viewModel careOrCancleCareWithTeacherId:_viewModel.teacherId accessToken:[APPUserDataIofo AccessToken] insterest:@"1" Success:^{
                    button.selected = !button.selected;
                    self.model.fans_count += 1;
                    self.fenCountLabel.text = [NSString stringWithFormat:@"%ld",self.model.fans_count];
                    //刷新老师的动态列表
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshTeacherDynamicVCData" object:nil userInfo:nil];
                }];
            } else {
                [_viewModel careOrCancleCareWithTeacherId:_viewModel.teacherId accessToken:[APPUserDataIofo AccessToken] insterest:@"0" Success:^{
                    button.selected = !button.selected;
                    self.model.fans_count -= 1;
                    self.fenCountLabel.text = [NSString stringWithFormat:@"%ld",self.model.fans_count];
                    //刷新老师的动态列表的数据
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshTeacherDynamicVCData" object:nil userInfo:nil];
                }];
            }
        }];
    }];

    [self addSubview:careBtn];
    
    self.careBtn = careBtn;
    
    [careBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-kWidth(10));
        make.size.mas_equalTo(CGSizeMake(kWidth(62), kHeight(25)));
        make.centerY.equalTo(nameLabel);
    }];
    
    //粉丝
    UILabel *fenLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"粉丝",MediumFont(font(11)),white_color);
        label.textAlignment = TextAlignmentRight;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:fenLabel];
    [fenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-kWidth(10));
        make.bottom.equalTo(careBtn.mas_top).offset(-kHeight(16));
        make.height.mas_equalTo(kHeight(11));
    }];
    
    //粉丝的数量
    UILabel *fenCountLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"0",MediumFont(font(21)),white_color);
        label.textAlignment = TextAlignmentRight;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:fenCountLabel];
    [fenCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-kWidth(10));
        make.bottom.equalTo(fenLabel.mas_top).offset(-kHeight(10));
        make.height.mas_equalTo(kHeight(16));
    }];
    
    self.fenCountLabel = fenCountLabel;
    
    //老师的简介
    UILabel *messageLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(11)),RGBA(255, 255, 255, 0.6));
        label.textAlignment = TextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(15));
        make.left.equalTo(self).offset(kWidth(10));
        make.right.equalTo(self).offset(-kWidth(10));
        make.height.mas_equalTo(kHeight(62));
    }];
    
    self.messageLabel = messageLabel;
    
    //详情的按钮
    HJTextAndPicButoton *detailButton = [[HJTextAndPicButoton alloc] initWithFrame:CGRectMake(0, 0, kWidth(35), kHeight(11.0)) type:HJTextAndPicButotonTypePicRight picSize:CGSizeMake(kWidth(6.0), kWidth(11.0)) textSize:CGSizeMake(kWidth(25), kHeight(11)) space:kWidth(5.0) picName:@"箭头" selctPicName:@"箭头" text:@"详情" selectText:@"详情" textColor:white_color selectTextColor:white_color font:MediumFont(font(11.0)) selectFont:MediumFont(font(11.0))];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailBtnClick)];
    [detailButton addGestureRecognizer:tap];
    [self addSubview:detailButton];
    [detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kWidth(33.0), kHeight(11.0)));
        make.right.equalTo(self).offset(-kWidth(10.0));
        if(isFringeScreen) {
            make.bottom.equalTo(self).offset(-kHeight(16));
        } else {
            make.bottom.equalTo(self).offset(-kHeight(16));
        }
    }];
    
    self.detailButton = detailButton;
}

- (void)detailBtnClick {
    if(_model){
       [DCURLRouter pushURLString:@"route://teacherMoreDetailVC" query:@{@"model" : _model} animated:YES];
    }
}

- (void)setModel:(HJTeacherDetailModel *)model {
    _model = model;
    if(model) {
        [self.liveImageV sd_setImageWithURL:URL(model.iconurl) placeholderImage:V_IMAGE(@"默认头像") options:SDWebImageRefreshCached];
        self.nameLabel.text = model.realname;
        
        //计算宽度
        CGFloat width = [model.teacprofessional calculateWidthWithSize:CGSizeMake(MAXFLOAT, kHeight(20)) font:MediumFont(font(11))];
        [self.jobLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_right).offset(kWidth(10));
            make.centerY.equalTo(self.nameLabel);
            make.width.mas_equalTo(kHeight(16) + width);
            make.height.mas_equalTo(kHeight(20));
        }];
        
        self.jobLabel.text = model.teacprofessional;
        if(model.isinterest == 0) {
            self.careBtn.selected = NO;
        } else {
            self.careBtn.selected = YES;
        }
        self.fenCountLabel.text = [NSString stringWithFormat:@"%ld",model.fans_count];
        NSString * introduction = model.introduction;
        if(model.introduction.length > 106) {
            introduction = [NSString stringWithFormat:@"%@...",[introduction substringWithRange:NSMakeRange(0, 107)]];
        }
        self.messageLabel.text = introduction;
        
        //计算高度
        CGFloat height = [model.introduction calculateSize:CGSizeMake(Screen_Width - kWidth(20), MAXFLOAT) font:MediumFont(font(11))].height;
        DLog(@"高度时:%f",height);
        if(height >= kHeight(62)) {
            self.detailButton.hidden = NO;
        } else {
            self.detailButton.hidden = YES;
        }
        
    }
}

- (void)setViewModel:(HJTeacherDetailViewModel *)viewModel {
    _viewModel = viewModel;
}

- (void)iconTap {
    [LJAvatarBrowser showImageView:self.liveImageV];
}

@end
