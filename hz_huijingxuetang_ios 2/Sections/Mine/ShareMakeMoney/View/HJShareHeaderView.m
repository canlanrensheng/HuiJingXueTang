//
//  HJShareHeaderView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJShareHeaderView.h"
#import "HJShareViewModel.h"
@interface HJShareHeaderView ()

@property (nonatomic,strong) UILabel *currentAreaCountLabel;
@property (nonatomic,strong) UILabel *finishOrderCountLabel;

@end

@implementation HJShareHeaderView

- (void)hj_configSubViews {
    self.backgroundColor = white_color;
    UIImageView *topHeaderImageV = [[UIImageView alloc] init];
    topHeaderImageV.image = V_IMAGE(@"banner");
    topHeaderImageV.userInteractionEnabled = YES;
    [self addSubview:topHeaderImageV];
    [topHeaderImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(kHeight(188));
    }];
    
    UITapGestureRecognizer *topHeaderImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topHeaderImageTap)];
    [topHeaderImageV addGestureRecognizer:topHeaderImageTap];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = white_color;
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(topHeaderImageV.mas_bottom);
    }];
    
    //好课分享
    UILabel *goodCourseLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"好课分享",BoldFont(font(15)),HEXColor(@"#22476B"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [bottomView addSubview:goodCourseLabel];
    [goodCourseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10.0));
        make.height.mas_equalTo(kHeight(15));
        make.centerY.equalTo(bottomView);
    }];
}

- (void)topHeaderImageTap {
    [DCURLRouter pushURLString:@"route://shareMoneyHelpVC" animated:YES];
}

- (void)setViewModel:(BaseViewModel *)viewModel {
    HJShareViewModel *listViewModel = (HJShareViewModel *)viewModel;
    if(listViewModel.model) {
        NSString *currentPerson = [NSString stringWithFormat:@"%@ 人",listViewModel.model.commCount];
        self.currentAreaCountLabel.attributedText = [currentPerson attributeWithStr:@"人" color:white_color font:MediumFont(font(11))];
        NSString *orderNum = [NSString stringWithFormat:@"%@ 单",listViewModel.model.orderCount];
        self.finishOrderCountLabel.attributedText = [orderNum attributeWithStr:@"单" color:white_color font:MediumFont(font(11))];
    }
}

@end
