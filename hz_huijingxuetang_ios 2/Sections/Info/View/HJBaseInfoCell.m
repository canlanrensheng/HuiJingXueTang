//
//  HJBaseInfoCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/6.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJBaseInfoCell.h"
#import "HJInfoViewModel.h"
#import "HJInfoListModel.h"
@interface HJBaseInfoCell ()

@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic,strong) UILabel *contentTitleLabel;
@property (nonatomic,strong) UILabel *contentDesLabel;
@property (nonatomic,strong) UILabel *readCountLabel;
@property (nonatomic,strong) UILabel *dateLabel;

@end

@implementation HJBaseInfoCell

- (void)hj_configSubViews {
    //图片
    UIImageView *liveImageV = [[UIImageView alloc] init];
    liveImageV.image = V_IMAGE(@"占位图");
    liveImageV.backgroundColor = Background_Color;
    [self addSubview:liveImageV];
    [liveImageV clipWithCornerRadius:kHeight(5.0) borderColor:nil borderWidth:0];
    [liveImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-kWidth(10));
        make.width.mas_equalTo(kWidth(124));
        make.height.mas_equalTo(kHeight(70));
    }];
    
    //标题
    UILabel *contentTitleLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",BoldFont(font(14)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 2;
        [label sizeToFit];
    }];
    [self addSubview:contentTitleLabel];
    [contentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kHeight(16.0));
        make.left.equalTo(self).offset(kWidth(10));
        make.right.equalTo(liveImageV.mas_left).offset(-kWidth(10));
    }];
    
//    //描述
//    UILabel *contentDesLabel = [UILabel creatLabel:^(UILabel *label) {
//        label.ljTitle_font_textColor(@"如何在动荡股市中求得一颗平常心唯一可以...",MediumFont(font(11)),HEXColor(@"#666666"));
//        label.textAlignment = NSTextAlignmentLeft;
//        label.numberOfLines = 2;
//        [label sizeToFit];
//    }];
//    [self addSubview:contentDesLabel];
//    [contentDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(contentTitleLabel.mas_bottom).offset(kHeight(10.0));
//        make.left.equalTo(self).offset(kWidth(10));
//        make.right.equalTo(liveImageV.mas_left).offset(-kWidth(30));
//        make.height.mas_equalTo(kHeight(35.0));
//    }];
    
    //阅读图片
    UIImageView *readImageV = [[UIImageView alloc] init];
    readImageV.image = V_IMAGE(@"阅读ICON");
    [self addSubview:readImageV];
    [readImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(liveImageV).offset(-kHeight(6.0));
        make.left.equalTo(self).offset(kWidth(10));
        make.width.mas_equalTo(kWidth(12));
        make.height.mas_equalTo(kHeight(8));
    }];
    
    //阅读数量
    UILabel *readCountLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"2208",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:readCountLabel];
    [readCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(readImageV);
        make.left.equalTo(readImageV.mas_right).offset(kWidth(5.0));
    }];
    self.readCountLabel = readCountLabel;
    
    //日期
    UILabel *dateLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"18/08/29",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentRight;
        [label sizeToFit];
    }];
    [self addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(readImageV);
        make.right.equalTo(liveImageV.mas_left).offset(-kWidth(20.0));
    }];
    
    self.imageV = liveImageV;
    self.contentTitleLabel = contentTitleLabel;
    self.readCountLabel = readCountLabel;
    self.dateLabel = dateLabel;
}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    HJInfoViewModel *listViewModel = (HJInfoViewModel *)viewModel;
    HJInfoListModel *model = listViewModel.infoListArray[indexPath.row];
    if(model){
        [self.imageV sd_setImageWithURL:URL(model.picurl) placeholderImage:V_IMAGE(@"占位图") options:SDWebImageRefreshCached];
        self.contentTitleLabel.text = model.infomationtitle;
        self.readCountLabel.text = [NSString stringWithFormat:@"%ld",model.readingquantity];
        NSDate *date = [NSDate dateWithString:model.createtime formatString:@"yyyy-MM-dd HH:mm:ss"];
        self.dateLabel.text = [NSString stringWithFormat:@"%ld/%@/%@ %@:%@",date.year,[NSString convertDateSingleData:date.month],[NSString convertDateSingleData:date.day],[NSString convertDateSingleData:date.hour],[NSString convertDateSingleData:date.minute]];
    }
}

@end

