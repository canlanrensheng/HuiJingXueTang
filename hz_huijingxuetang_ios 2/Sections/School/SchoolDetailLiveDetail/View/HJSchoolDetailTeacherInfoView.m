//
//  HJSchoolDetailTeacherInfoView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/26.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSchoolDetailTeacherInfoView.h"
#import "HJPicAndTextButton.h"

@interface HJSchoolDetailTeacherInfoView ()

@property (nonatomic,strong) UIImageView *iconImageV;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *desLabel;
@property (nonatomic,strong) HJPicAndTextButton *careButton;

@end

@implementation HJSchoolDetailTeacherInfoView

- (void)hj_configSubViews {
    self.backgroundColor = white_color;
    
    UIImageView *iconImageV = [[UIImageView alloc] init];
    iconImageV.image = V_IMAGE(@"默认头像");
    iconImageV.backgroundColor = Background_Color;
    [self addSubview:iconImageV];
    [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10.0));
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(kHeight(40));
    }];
    [iconImageV clipWithCornerRadius:kHeight(20.0) borderColor:nil borderWidth:0];
    self.iconImageV = iconImageV;
    
    //昵称
    UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"暂无名称",BoldFont(font(13)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageV).offset(kHeight(5.0));
        make.height.mas_equalTo(kHeight(13));
        make.left.equalTo(iconImageV.mas_right).offset(kWidth(10.0));
    }];
    
    self.nameLabel = nameLabel;
    
    //关注的按钮
    HJPicAndTextButton *careButton = [HJPicAndTextButton buttonWithType:UIButtonTypeCustom withSpace:kHeight(5.0)];
    careButton.buttonStyle = ButtonImageTop;
    [careButton setImage:V_IMAGE(@"已关注") forState:UIControlStateNormal];
    [careButton setTitle:@"关注" forState:UIControlStateNormal];
    [careButton setTitleColor:HEXColor(@"#e3763d") forState:UIControlStateNormal];
    [careButton setTitleColor:HEXColor(@"#999999") forState:UIControlStateSelected];
    careButton.titleLabel.font = MediumFont(font(10));
    [careButton addTarget:self action:@selector(carBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:careButton];
    [careButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kWidth(50), kHeight(60)));
        make.right.equalTo(self).offset(-kWidth(10.0));
    }];
    self.careButton = careButton;
    
    //分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = Background_Color;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(kHeight(5.0));
    }];
    
    //描述
    UILabel *desLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"暂无个性标签",MediumFont(font(11)),HEXColor(@"#666666"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(7.0));
        make.height.mas_equalTo(kHeight(13));
        make.left.equalTo(iconImageV.mas_right).offset(kWidth(10.0));
        make.right.equalTo(careButton.mas_left).offset(-kWidth(10));
    }];
    self.desLabel = desLabel;
   
}

- (void)carBtnClick:(UIButton *)btn {
    if([APPUserDataIofo AccessToken].length <= 0) {
        [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
        return;
    }
    btn.selected = !btn.selected;
    if(btn.selected) {
        //关注
        [self.viewModel careOrCancleCareWithTeacherId:self.viewModel.model.course.userid accessToken:[APPUserDataIofo AccessToken] insterest:@"1" Success:^{
            [btn setImage:V_IMAGE(@"未关注") forState:UIControlStateNormal];
            [btn setTitle:@"已关注" forState:UIControlStateNormal];
            [btn setTitleColor:HEXColor(@"#999999") forState:UIControlStateNormal];
            
            if(self.careSubject){
                [self.careSubject sendNext:@(btn.selected)];
            }
        }];
    } else {
        //取消关注
        [self.viewModel careOrCancleCareWithTeacherId:self.viewModel.model.course.userid accessToken:[APPUserDataIofo AccessToken] insterest:@"0" Success:^{
            [btn setImage:V_IMAGE(@"已关注") forState:UIControlStateNormal];
            [btn setTitle:@"关注" forState:UIControlStateNormal];
            [btn setTitleColor:HEXColor(@"#22476B") forState:UIControlStateNormal];
            
            if(self.careSubject){
                [self.careSubject sendNext:@(btn.selected)];
            }
        }];
    }
}

- (void)setViewModel:(HJSchoolLiveDetailViewModel *)viewModel {
    _viewModel = viewModel;
    if (viewModel.model) {
        [self.iconImageV sd_setImageWithURL:URL(viewModel.model.course.iconurl) placeholderImage:V_IMAGE(@"默认头像") options:SDWebImageRefreshCached];
        self.nameLabel.text = viewModel.model.course.realname;
        self.desLabel.text = viewModel.model.course.slogen.length > 0 ? viewModel.model.course.slogen : @"暂无个性标签";
        if (viewModel.model.course.isinterest == 1) {
            self.careButton.selected = YES;
            self.careSelected = YES;
        } else {
            self.careButton.selected = NO;
            self.careSelected = NO;
        }
    }
}

- (RACSubject *)careSubject {
    if(!_careSubject) {
        _careSubject = [[RACSubject alloc] init];
    }
    return _careSubject;
}

- (void)setCareSelected:(BOOL)careSelected {
    _careSelected = careSelected;
    if(_careSelected) {
        self.careButton.selected = YES;
        [self.careButton setImage:V_IMAGE(@"未关注") forState:UIControlStateNormal];
        [self.careButton setTitle:@"已关注" forState:UIControlStateNormal];
        [self.careButton setTitleColor:HEXColor(@"#999999") forState:UIControlStateNormal];
    } else {
        self.careButton.selected = NO;
        [self.careButton setImage:V_IMAGE(@"已关注") forState:UIControlStateNormal];
        [self.careButton setTitle:@"关注" forState:UIControlStateNormal];
        [self.careButton setTitleColor:HEXColor(@"#22476B") forState:UIControlStateNormal];
    }
}

@end
