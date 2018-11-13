//
//  HJFindRecommondLinkCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/31.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJFindRecommondLinkCell.h"

#import "HJFindViewModel.h"
#import "HJFindRecommondModel.h"

@interface HJFindRecommondLinkCell ()

@property (nonatomic,strong) UIImageView *linkImageView;
@property (nonatomic,strong) UILabel *warnLabel;
@property (nonatomic,strong) UIImageView *iconImageV;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIButton *careBtn;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UILabel *dateLabel;

@property (nonatomic,strong) HJFindViewModel *viewModel;
@property (nonatomic,strong) HJFindRecommondModel *model;

@end

@implementation HJFindRecommondLinkCell

- (void)hj_configSubViews {
    
    //头像
    UIImageView *iconImageV = [[UIImageView alloc] init];
    iconImageV.image = V_IMAGE(@"默认头像");
    iconImageV.backgroundColor = Background_Color;
    [self addSubview:iconImageV];
    [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10.0));
        make.top.equalTo(self).offset(kHeight(15.0));
        make.width.height.mas_equalTo(kHeight(40));
    }];
    [iconImageV clipWithCornerRadius:kHeight(20.0) borderColor:nil borderWidth:0];
    
    //昵称
    UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"俞春",BoldFont(font(14)),HEXColor(@"#22476B"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageV).offset(kHeight(5.0));
        make.height.mas_equalTo(kHeight(14));
        make.left.equalTo(iconImageV.mas_right).offset(kWidth(5.0));
    }];
    
    //关注的
    UIButton *loodDetailBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"+ 关注",MediumFont(font(13)),HEXColor(@"#FF4400"),0);
        [button setTitle:@"+ 关注" forState:UIControlStateNormal];
        [button setTitle:@"已关注" forState:UIControlStateSelected];
        [button setTitleColor:RGBA(0, 0, 0, 0.4) forState:UIControlStateSelected];
        [button setTitleColor:HEXColor(@"#FF4400") forState:UIControlStateNormal];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if([APPUserDataIofo AccessToken].length <= 0) {
                ShowMessage(@"您还未登录");
                [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
                return;
            }
            if(self.model.isinterest == 0) {
                [self.viewModel careOrCancleCareWithTeacherId:self.model.teacherid accessToken:[APPUserDataIofo AccessToken] insterest:@"1" Success:^{
                    button.selected = !button.selected;
                }];
            } else {
                [self.viewModel careOrCancleCareWithTeacherId:self.model.teacherid accessToken:[APPUserDataIofo AccessToken] insterest:@"0" Success:^{
                    button.selected = !button.selected;
                }];
            }
        }];
    }];
    [self addSubview:loodDetailBtn];
    [loodDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-kWidth(10));
        make.size.mas_equalTo(CGSizeMake(kWidth(45), kHeight(13)));
        make.centerY.equalTo(nameLabel);
    }];
    
    //描述
    UILabel *desLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"今晚八点三十分我将准时开播为大家带来最新一期的股市快评希望各位学员准时参加！",MediumFont(font(13)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(10.0));
        make.left.equalTo(nameLabel);
        make.right.equalTo(self).offset(-kWidth(10));
    }];
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = HEXColor(@"#F2F5FA");
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(55));
        make.top.equalTo(desLabel.mas_bottom).offset(kHeight(15));
        make.height.mas_equalTo(kHeight(60));
        make.right.equalTo(self).offset(-kWidth(10));
    }];
    
    //图片链接
    _linkImageView = [[UIImageView alloc] init];
    [backView addSubview:_linkImageView];
    [_linkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView);
        make.size.mas_equalTo(CGSizeMake(kWidth(40), kHeight(40)));
        make.left.equalTo(backView).offset(kWidth(10));
    }];
    
    //文本
    _warnLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"点击查阅文章",MediumFont(font(13)),HEXColor(@"#141E2F"));
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [backView addSubview:_warnLabel];
    [_warnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_linkImageView);
        make.left.equalTo(_linkImageView.mas_right).offset(kWidth(10.0));
    }];
    
    UIView *coverView = [[UIView alloc] init];
    coverView.backgroundColor = RGBA(0, 0, 0, 0.4);
    [backView addSubview:coverView];
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(_linkImageView);
    }];
    
    //蒙版
    UIImageView *coverImageView = [[UIImageView alloc] init];
    coverImageView.image = V_IMAGE(@"链接标志");
    [backView addSubview:coverImageView];
    [coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_linkImageView);
        make.size.mas_equalTo(CGSizeMake(kWidth(24), kHeight(24)));
    }];
    
    //日期
    UILabel *dateLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"1小时前",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_bottom).offset(kHeight(15.0));
        make.left.equalTo(nameLabel);
        make.height.mas_equalTo(kHeight(11.0));
    }];

    self.iconImageV = iconImageV;
    self.nameLabel = nameLabel;
    self.careBtn = loodDetailBtn;
    self.contentLabel = desLabel;
    self.dateLabel = dateLabel;

}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    HJFindViewModel *listViewModel = (HJFindViewModel *)viewModel;
    HJFindRecommondModel *model = nil;
    if(listViewModel.findSegmentType == 0) {
        model = listViewModel.findArray[indexPath.row];
    } else {
        model = listViewModel.careArray[indexPath.row];
    }
    self.viewModel = (HJFindViewModel *)viewModel;
    self.model = model;
    
    [_linkImageView sd_setImageWithURL:URL(model.dynamiclinkpic) placeholderImage:V_IMAGE(@"默认头像")];
    [self.iconImageV sd_setImageWithURL:URL(model.iconurl) placeholderImage:V_IMAGE(@"默认头像")];
    self.nameLabel.text = model.realname;
    self.careBtn.selected = model.isinterest == 1 ? YES : NO;
    self.contentLabel.text = model.dynamiccontent;
    self.dateLabel.text = [DateFormatter getDate:model.createtime];
    
    if(model.type == 1 || model.type == 2) {
        self.warnLabel.text = @"点击查阅文章";
    } else if (model.type == 3 || model.type == 4) {
        self.warnLabel.text = @"点击进入直播间";
    } else if(model.type == 5) {
        self.warnLabel.text = @"点击查看课程详情";
    } else {
        self.warnLabel.text = @"";
    }
}


@end