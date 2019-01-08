//
//  HJTeacherMoreDetailCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/16.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJTeacherMoreDetailCell.h"
#import "LJAvatarBrowser.h"
@interface HJTeacherMoreDetailCell ()

@property (nonatomic,strong) UIImageView *liveImageV;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *jobLabel;
@property (nonatomic,strong) UILabel *messageLabel;

@end

@implementation HJTeacherMoreDetailCell

- (void)hj_configSubViews {
    
    UIImageView *liveImageV = [[UIImageView alloc] init];
    liveImageV.image = V_IMAGE(@"默认头像");
    liveImageV.userInteractionEnabled = YES;
    [self addSubview:liveImageV];
    [liveImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(kHeight(20));
        make.size.mas_equalTo(CGSizeMake(kWidth(60), kHeight(60)));
    }];
    
    [liveImageV clipWithCornerRadius:kHeight(30.0) borderColor:nil borderWidth:0.0];
    UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTap)];
    [liveImageV addGestureRecognizer:iconTap];
    
    self.liveImageV = liveImageV;
    
    //姓名
    UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"张泼",MediumFont(font(20)),HEXColor(@"#333333"));
        label.textAlignment = TextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(liveImageV.mas_bottom).offset(kHeight(11));
        make.centerX.equalTo(self);
        make.height.mas_equalTo(kHeight(19));
    }];
    
    self.nameLabel = nameLabel;
    
    //职位名称
    UILabel *jobLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"慧鲸特邀专家",MediumFont(font(11)),HEXColor(@"#FBA215"));
        label.textAlignment = TextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:jobLabel];
    [jobLabel clipWithCornerRadius:kHeight(10.0) borderColor:HEXColor(@"#FBA215") borderWidth:kHeight(1.0)];
    [jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(kWidth(10));
        make.centerX.equalTo(self);
        make.width.mas_equalTo(kHeight(81));
        make.height.mas_equalTo(kHeight(20));
    }];
    
    self.jobLabel = jobLabel;
    
    //老师的简介
    UILabel *messageLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"多年的股市实战经验,曾经担任浙江某大型私募基金投资总监，对市场的波动有独到理解，价值投资大资金运作如鱼得水，短线热点炒作登峰造极，操盘手法静如洪钟动如狡兔，丰富的实盘操作经验得到了江浙沪私募圈高度评价和认可，外号炒股养家。",MediumFont(font(13)),HEXColor(@"#666666"));
        label.textAlignment = TextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(jobLabel.mas_bottom).offset(kHeight(20));
        make.left.equalTo(self).offset(kWidth(10));
        make.right.equalTo(self).offset(-kWidth(10));
    }];
    
    self.messageLabel = messageLabel;
}

- (void)setModel:(HJTeacherDetailModel *)model {
    _model = model;
    [self.liveImageV sd_setImageWithURL:URL(model.iconurl) placeholderImage:V_IMAGE(@"默认头像")];
    self.nameLabel.text = model.realname;
    self.jobLabel.text = model.teacprofessional;
    self.messageLabel.text = [NSString stringWithFormat:@"      %@",model.introduction];
    
    CGFloat width = [model.teacprofessional calculateWidthWithSize:CGSizeMake(MAXFLOAT, kHeight(20)) font:MediumFont(font(11))];
    [self.jobLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(kWidth(10));
        make.centerY.equalTo(self.nameLabel);
        make.width.mas_equalTo(kHeight(16) + width);
        make.height.mas_equalTo(kHeight(20));
    }];
}

- (void)iconTap {
    [LJAvatarBrowser showImageView:self.liveImageV];
}

@end
