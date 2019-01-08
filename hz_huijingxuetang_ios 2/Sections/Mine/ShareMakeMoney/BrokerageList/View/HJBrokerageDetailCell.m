//
//  HJBrokerageDetailCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJBrokerageDetailCell.h"
#import "HJBrokerageDetailViewModel.h"
#import "HJBrokerageDetailModel.h"

@interface HJBrokerageDetailCell()

@property (nonatomic,strong) UILabel *courseNameLabel;
@property (nonatomic,strong) UILabel *finishOrderCountLabel;
@property (nonatomic,strong) UILabel *brokerageLabel;

@end

@implementation HJBrokerageDetailCell

- (void)hj_configSubViews {
    //课程的名称
    UILabel *courseNameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(11)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 1;
        [label sizeToFit];
    }];
    [self addSubview:courseNameLabel];
    [courseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10));
        make.centerY.equalTo(self);
        make.height.equalTo(self);
    }];
    
    self.courseNameLabel = courseNameLabel;
    //成交量
    UILabel *finishOrderCountLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"0",MediumFont(font(11)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 1;
        [label sizeToFit];
    }];
    [self addSubview:finishOrderCountLabel];
    [finishOrderCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    self.finishOrderCountLabel = finishOrderCountLabel;
    
    //佣金
    UILabel * brokerageLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"￥0",MediumFont(font(11)),HEXColor(@"#FF4400"));
        label.textAlignment = NSTextAlignmentRight;
        label.numberOfLines = 1;
        [label sizeToFit];
    }];
    [self addSubview:brokerageLabel];
    [brokerageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(Screen_Width / 3);
        make.top.equalTo(self);
//        make.left.equalTo(finishOrderCountLabel.mas_right);
        make.right.equalTo(self).offset(-kWidth(10));
        make.height.equalTo(self);
    }];
    
    self.brokerageLabel = brokerageLabel;
}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    HJBrokerageDetailViewModel *listViewModel = (HJBrokerageDetailViewModel *)viewModel;
    HJBrokerageDetailModel *model = listViewModel.brokerageDetailArray[indexPath.row];
    self.courseNameLabel.text = model.coursename;
    self.finishOrderCountLabel.text = [NSString stringWithFormat:@"%ld",model.count];
    self.brokerageLabel.text = [NSString stringWithFormat:@"￥%.2f",model.commission];
}

@end
