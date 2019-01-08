//
//  HJSearchResultInfomationCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/26.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSearchResultInfomationCell.h"
#import "HJSearchResultViewModel.h"
#import "HJSearchResultModel.h"
@interface HJSearchResultInfomationCell ()

@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic,strong) UILabel *contentTitleLabel;
@property (nonatomic,strong) UILabel *contentDesLabel;
@property (nonatomic,strong) UILabel *readCountLabel;
@property (nonatomic,strong) UILabel *dateLabel;

@end

@implementation HJSearchResultInfomationCell

- (void)hj_configSubViews {
    //图片
    UIImageView *imaV = [[UIImageView alloc] init];
    imaV.image = V_IMAGE(@"占位图");
    //    [imaV sd_setImageWithURL:URL(model.coursepic) placeholderImage:nil];
    imaV.backgroundColor = Background_Color;
    [self addSubview:imaV];
    [imaV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-kWidth(10.0));
        make.width.mas_equalTo(kWidth(160));
        make.height.mas_equalTo(kHeight(90));
    }];
    [imaV clipWithCornerRadius:kHeight(5.0) borderColor:nil borderWidth:0];

    self.imageV = imaV;
    
    //名称
    UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",BoldFont(font(14)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imaV).offset(kHeight(6.0));
        make.left.equalTo(self).offset(kWidth(10.0));
        make.height.mas_equalTo(kHeight(14.0));
        make.right.equalTo(imaV.mas_left).offset(-kWidth(10.0));
    }];
    
    self.contentTitleLabel = nameLabel;
    
    
    //描述
    UILabel *desLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(11)),HEXColor(@"#666666"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 2;
        [label sizeToFit];
    }];
    [self addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(10.0));
        make.left.equalTo(self).offset(kWidth(10.0));
//        make.height.mas_equalTo(kHeight(26.0));
        make.right.equalTo(imaV.mas_left).offset(-kWidth(20.0));
    }];
    
    self.contentDesLabel = desLabel;
    
    //阅读的图标
    UIImageView *readImaV = [[UIImageView alloc] init];
    readImaV.image = V_IMAGE(@"阅读ICON");
    //    [imaV sd_setImageWithURL:URL(model.coursepic) placeholderImage:nil];
    readImaV.backgroundColor = Background_Color;
    [self addSubview:readImaV];
    [readImaV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10.0));
        make.bottom.equalTo(imaV.mas_bottom).offset(-kHeight(5.0));
    }];
    
    //阅读的数量
    UILabel *readCountLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"0",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:readCountLabel];
    [readCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(readImaV.mas_right).offset(kWidth(5.0));
        make.centerY.equalTo(readImaV);
        make.height.mas_equalTo(kHeight(9.0));
    }];
    
    self.readCountLabel = readCountLabel;
    
    //时间
    UILabel *timeLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentRight;
        [label sizeToFit];
    }];
    [self addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imaV.mas_left).offset(-kWidth(20.0));
        make.centerY.equalTo(readImaV);
        make.height.mas_equalTo(kHeight(11.0));
    }];
    
    self.dateLabel = timeLabel;
    
    //分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = HEXColor(@"#EAEAEA");
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(kHeight(0.5));
    }];
   
}

//- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
//    HJSearchResultViewModel *listViewModel = (HJSearchResultViewModel *)viewModel;
//    InformationResponses *model = listViewModel.model.informationResponses[indexPath.row];
//    if(model){
//        [self.imageV sd_setImageWithURL:URL(model.picurl) placeholderImage:V_IMAGE(@"占位图")];
//        self.contentTitleLabel.text = model.infomationtitle;
//        self.readCountLabel.text = [NSString stringWithFormat:@"%@",model.readcounts];
//        NSDate *date = [NSDate dateWithString:model.createtime formatString:@"yyyy-MM-dd HH:mm:ss"];
//        self.dateLabel.text = [NSString stringWithFormat:@"%ld/%ld/%ld",date.year,date.month,date.day];
//    }
//}

- (void)setModel:(InformationResponses *)model {
    _model = model;
    if(model){
        [self.imageV sd_setImageWithURL:URL(model.picurl) placeholderImage:V_IMAGE(@"占位图")];
        self.contentTitleLabel.text = model.infomationtitle;
        self.readCountLabel.text = [NSString stringWithFormat:@"%@",model.readcounts];
        NSDate *date = [NSDate dateWithString:model.createtime formatString:@"yyyy-MM-dd HH:mm:ss"];
        self.dateLabel.text = [NSString stringWithFormat:@"%ld/%@/%@",date.year,[NSString convertDateSingleData:date.month],[NSString convertDateSingleData:date.day]];
    }
}

@end
