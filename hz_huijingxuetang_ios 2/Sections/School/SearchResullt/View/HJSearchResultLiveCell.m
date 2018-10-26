//
//  HJSearchResultLiveCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/26.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSearchResultLiveCell.h"

@interface HJSearchResultLiveCell ()

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *courceLabel;
@property (nonatomic,strong) UILabel *studentCountLabel;
@property (nonatomic,strong) UILabel *liveTypeLabel;

@end


@implementation HJSearchResultLiveCell

- (void)hj_configSubViews {
    //图片
    UIImageView *imaV = [[UIImageView alloc] init];
    imaV.image = V_IMAGE(@"占位图");
    //    [imaV sd_setImageWithURL:URL(model.coursepic) placeholderImage:nil];
    imaV.backgroundColor = Background_Color;
    [self addSubview:imaV];
    [imaV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kHeight(11.0));
        make.left.equalTo(self).offset(kWidth(10.0));
        make.width.mas_equalTo(kWidth(145));
        make.height.mas_equalTo(kHeight(90));
    }];
    [imaV clipWithCornerRadius:kHeight(5.0) borderColor:nil borderWidth:0];
    self.imgView = imaV;
    
    //名称
    UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"重温经典系列之新K线战法",BoldFont(font(14)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imaV).offset(kHeight(5.0));
        make.left.equalTo(imaV.mas_right).offset(kWidth(12.0));
        make.height.mas_equalTo(kHeight(13.0));
    }];
    
    self.courceLabel = nameLabel;
    
    
    //星级
    UIView *starView = [[UIView alloc] init];
    starView.backgroundColor = white_color;
    [self addSubview:starView];
    CGFloat totalWidth = kWidth(11) * 5 + kWidth(2.0) * 4;
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(8.0));
        make.height.mas_equalTo(kHeight(11));
        make.width.mas_equalTo(kWidth(totalWidth));
    }];
    
    for(int i = 0; i < 5;i++) {
        UIImageView *starImageView = [[UIImageView alloc] init];
        starImageView.frame = CGRectMake((kWidth(2 + 11) * i), 0, kWidth(11), kWidth(11));
        starImageView.backgroundColor = white_color;
        starImageView.image = V_IMAGE(@"热度ICON");
        [starView addSubview:starImageView];
    }
    
    //星级Label
    UILabel *starCountLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"人气",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:starCountLabel];
    [starCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(10.0));
        make.centerY.equalTo(starView);
        make.left.equalTo(imaV.mas_right).offset(kWidth(87.0));
        make.height.mas_equalTo(kHeight(13.0));
    }];
    
    self.studentCountLabel = starCountLabel;
    
    //价格
    _liveTypeLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"付费直播",BoldFont(font(10)),HEXColor(@"#22476B"));
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
    }];
    [self.liveTypeLabel clipWithCornerRadius:kHeight(2.5) borderColor:HEXColor(@"#22476B") borderWidth:kHeight(1.0)];
    
    [self addSubview:_liveTypeLabel];
    [_liveTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(starCountLabel.mas_right).offset(kWidth(8.0));
        make.centerY.equalTo(starCountLabel);
        make.width.mas_equalTo(kHeight(45.0));
        make.height.mas_equalTo(kHeight(15.0));
    }];
    
    //讲师
    UILabel *nextLiveTimeLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"下次直播 09月28日 10:30-11:30",MediumFont(font(11)),HEXColor(@"#666666"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:nextLiveTimeLabel];
    
    [nextLiveTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imaV).offset(-kHeight(5.0));
        make.left.equalTo(imaV.mas_right).offset(kWidth(13.0));
        make.height.mas_equalTo(kHeight(12.0));
    }];
    
    
    
    
}

@end
