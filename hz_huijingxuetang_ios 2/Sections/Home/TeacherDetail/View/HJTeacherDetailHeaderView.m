//
//  HJTeacherDetailHeaderView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/5.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJTeacherDetailHeaderView.h"

@implementation HJTeacherDetailHeaderView

- (void)hj_configSubViews {
    self.backgroundColor = NavigationBar_Color;
    
    UIImageView *liveImageV = [[UIImageView alloc] init];
    liveImageV.image = V_IMAGE(@"占位图");
    [self addSubview:liveImageV];
    [liveImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10));
        make.top.equalTo(self).offset(kHeight(12.0));
        make.size.mas_equalTo(CGSizeMake(kWidth(60), kHeight(60)));
    }];
    
    [liveImageV clipWithCornerRadius:kHeight(30.0) borderColor:nil borderWidth:0.0];
    
    //姓名
    UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"张泼",MediumFont(font(20)),white_color);
        label.textAlignment = TextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(liveImageV.mas_bottom).offset(kHeight(20));
        make.centerX.equalTo(liveImageV);
        make.height.mas_equalTo(kHeight(19));
    }];
    
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
        make.left.equalTo(nameLabel.mas_right).offset(kWidth(10));
        make.centerY.equalTo(nameLabel);
        make.width.mas_equalTo(kHeight(81));
        make.height.mas_equalTo(kHeight(20));
    }];
    
    //关注
    UIButton *careBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"",MediumFont(font(13)),white_color,0);
        [button setTitle:@"+ 关注" forState:UIControlStateNormal];
        [button setTitle:@"已关注" forState:UIControlStateSelected];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            button.selected = !button.selected;
            if(button.selected) {
                [careBtn clipWithCornerRadius:kHeight(12.5) borderColor:white_color borderWidth:kHeight(1.0)];
            } else {
                [careBtn clipWithCornerRadius:kHeight(12.5) borderColor:nil borderWidth:0.0];
            }
        }];
    }];
    [careBtn clipWithCornerRadius:kHeight(12.5) borderColor:white_color borderWidth:kHeight(1.0)];
    [self addSubview:careBtn];
    
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
        label.ljTitle_font_textColor(@"1093",MediumFont(font(21)),white_color);
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
    
    //老师的简介
    UILabel *messageLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"多年的股市实战经验,曾经担任浙江某大型私募基金投资总监，对市场的波动有独到理解，价值投资大资金运作如鱼得水，短线热点炒作登峰造极，操盘手法静如洪钟动如狡兔，丰富的实盘操作经验得到了江浙沪私募圈高度评价和认可，外号炒股养家。",MediumFont(font(11)),white_color);
        label.textAlignment = TextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(15));
        make.left.equalTo(self).offset(kWidth(10));
        make.right.equalTo(self).offset(-kWidth(10));
    }];
}

@end
