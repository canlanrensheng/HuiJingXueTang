//
//  HJBrokerageDetailFooterView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/3.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJBrokerageDetailFooterView.h"

#import "HJBrokerageDetailViewModel.h"

@interface HJBrokerageDetailFooterView ()

@property (nonatomic,strong) HJBrokerageDetailViewModel *listViewModel;
@property (nonatomic,strong) UILabel *courseNameLabel;
@property (nonatomic,strong) UILabel *finishNumLabel;
@property (nonatomic,strong) UILabel *brokerageLabel;

@end

@implementation HJBrokerageDetailFooterView

- (void)hj_configSubViews {
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = HEXColor(@"#F8FCFF");
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(kHeight(40));
    }];
    
    UILabel *courseNameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"合计",BoldFont(font(13)),HEXColor(@"#22476B"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 1;
        [label sizeToFit];
    }];
    [topView addSubview:courseNameLabel];
    [courseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(Screen_Width / 3);
//        make.left.top.equalTo(topView);
//        make.height.equalTo(topView);
        make.left.equalTo(topView).offset(kWidth(10));
        make.centerY.equalTo(topView);
    }];
    
    self.courseNameLabel = courseNameLabel;
    
    //成交量
    UILabel *finishOrderCountLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"0",BoldFont(font(13)),HEXColor(@"#FF4400"));
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 1;
        [label sizeToFit];
    }];
    [topView addSubview:finishOrderCountLabel];
    [finishOrderCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(Screen_Width / 3);
//        make.top.equalTo(topView);
//        make.left.equalTo(courseNameLabel.mas_right);
//        make.height.equalTo(topView);
        make.center.equalTo(topView);
    }];
    
    self.finishNumLabel = finishOrderCountLabel;
    
    //佣金
    UILabel *brokerageLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"￥0",BoldFont(font(13)),HEXColor(@"#FF4400"));
        label.textAlignment = NSTextAlignmentRight;
        label.numberOfLines = 1;
        [label sizeToFit];
    }];
    [topView addSubview:brokerageLabel];
    [brokerageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(Screen_Width / 3);
//        make.top.equalTo(topView);
//        make.left.equalTo(finishOrderCountLabel.mas_right);
//        make.height.equalTo(topView);
        make.centerY.equalTo(topView);
        make.right.equalTo(topView).offset(-kWidth(10.0));
    }];
    
    self.brokerageLabel = brokerageLabel;
}

- (void)setViewModel:(BaseViewModel *)viewModel {
    self.listViewModel = (HJBrokerageDetailViewModel *)viewModel;
    self.finishNumLabel.text = [NSString stringWithFormat:@"%ld",self.listViewModel.ordersum];
    NSString *brokerage = [NSString stringWithFormat:@"￥%.2f",self.listViewModel.commissionsum];
    self.brokerageLabel.attributedText = [brokerage attributeWithStr:@"￥" color:HEXColor(@"#FF4400") font:BoldFont(font(10))];
}

@end
