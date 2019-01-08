//
//  HJFindRecommondTextCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/31.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJFindRecommondTextCell.h"

#import "HJFindViewModel.h"
#import "HJFindRecommondModel.h"

@interface HJFindRecommondTextCell ()

@property (nonatomic,strong) UIImageView *iconImageV;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIButton *careBtn;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UILabel *dateLabel;

@property (nonatomic,strong) HJFindViewModel *viewModel;
@property (nonatomic,strong) HJFindRecommondModel *model;

@end

@implementation HJFindRecommondTextCell

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
        button.ljTitle_font_titleColor_state(@"",MediumFont(font(13)),HEXColor(@"#FF4400"),0);
        [button setTitle:@"+ 关注" forState:UIControlStateNormal];
        [button setTitle:@"已关注" forState:UIControlStateSelected];
        [button setTitleColor:RGBA(0, 0, 0, 0.4) forState:UIControlStateSelected];
        [button setTitleColor:HEXColor(@"#FF4400") forState:UIControlStateNormal];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if([APPUserDataIofo AccessToken].length <= 0) {
                [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
                return;
            }
            if(self.model.isinterest == 0) {
                [self.viewModel careOrCancleCareWithTeacherId:self.model.teacherid accessToken:[APPUserDataIofo AccessToken] insterest:@"1" Success:^{
                    button.selected = !button.selected;
//                    ShowMessage(@"关注成功");
                    [self.backRefreshSubject sendNext:@(1)];
                    self.model.isinterest = 1;
                    // 刷新关注的列表
                    if(self.viewModel.findSegmentType == FindSegmentTypeRecommond) {
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreFindCareData" object:nil userInfo:nil];
                    } else {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreFindCommondData" object:nil userInfo:nil];
                    }
                }];
            } else {
                [self.viewModel careOrCancleCareWithTeacherId:self.model.teacherid accessToken:[APPUserDataIofo AccessToken] insterest:@"0" Success:^{
                    button.selected = !button.selected;
                    [self.backRefreshSubject sendNext:@(0)];
                    self.model.isinterest = 0;
                    // 刷新关注的列表
                    if(self.viewModel.findSegmentType == FindSegmentTypeRecommond) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreFindCareData" object:nil userInfo:nil];
                    }else {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreFindCommondData" object:nil userInfo:nil];
                    }
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
    
    
    //日期
    UILabel *dateLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"1小时前",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desLabel.mas_bottom).offset(kHeight(15.0));
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
    self.viewModel = listViewModel;
    HJFindRecommondModel *model = nil;
    if(listViewModel.findSegmentType == 0) {
        model = listViewModel.findArray[indexPath.row];
    } else {
        model = listViewModel.careArray[indexPath.row];
    }
    self.viewModel = (HJFindViewModel *)viewModel;
    self.model = model;
    [self.iconImageV sd_setImageWithURL:URL(model.iconurl) placeholderImage:V_IMAGE(@"默认头像")];
    self.nameLabel.text = model.realname;
    self.careBtn.selected = model.isinterest == 1 ? YES : NO;
    self.contentLabel.text = model.dynamiccontent;
    self.dateLabel.text = [DateFormatter getDate:model.createtime];
}

- (RACSubject *)backRefreshSubject {
    if(!_backRefreshSubject) {
        _backRefreshSubject = [[RACSubject alloc] init];
    }
    return _backRefreshSubject;
}

@end
