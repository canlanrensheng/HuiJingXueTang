//
//  HJTeachBestDetailHotCommontCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/5.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJTeachBestDetailHotCommontCell.h"
#import "HJTeachDetailViewModel.h"
#import "HJTeachBestDetailCommentModel.h"

@interface HJTeachBestDetailHotCommontCell ()

@property (nonatomic,strong) UIImageView *iconImageV;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *addressLabel;
@property (nonatomic,strong) UILabel *desLabel;

@end

@implementation HJTeachBestDetailHotCommontCell

- (void)hj_configSubViews {
    //头像
    UIImageView *iconImageV = [[UIImageView alloc] init];
    iconImageV.image = V_IMAGE(@"默认头像");
    iconImageV.backgroundColor = Background_Color;
    [self addSubview:iconImageV];
    [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10.0));
        make.top.equalTo(self).offset(kHeight(15.0));
        make.width.height.mas_equalTo(kHeight(45));
    }];
    [iconImageV clipWithCornerRadius:kHeight(22.5) borderColor:nil borderWidth:0];
    
    
    
    //昵称
    UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"明天会更好",MediumFont(font(11)),HEXColor(@"#666666"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageV).offset(kHeight(8.0));
        make.height.mas_equalTo(kHeight(12));
        make.left.equalTo(iconImageV.mas_right).offset(kWidth(10.0));
    }];
    
    //日期
    UILabel *dateLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentRight;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kHeight(10));
        make.centerY.equalTo(nameLabel);
        make.right.equalTo(self).offset(-kWidth(10.0));
    }];
    
    //地址
    UILabel *addressLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(8.0));
        make.height.mas_equalTo(kHeight(11));
        make.left.equalTo(iconImageV.mas_right).offset(kWidth(10.0));
    }];
    
    //问题描述
    UILabel *desLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(13)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressLabel.mas_bottom).offset(kHeight(12.0));
        make.left.equalTo(nameLabel);
        make.right.equalTo(self).offset(-kWidth(10.0));
    }];
    
    self.iconImageV = iconImageV;
    self.nameLabel = nameLabel;
    self.dateLabel = dateLabel;
    self.addressLabel = addressLabel;
    self.desLabel = desLabel;
}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    HJTeachDetailViewModel *listViewModel = (HJTeachDetailViewModel *)viewModel;
    HJTeachBestDetailCommentModel *model = listViewModel.infoCommondArray[indexPath.row];
    if(model){
        [self.iconImageV sd_setImageWithURL:URL(model.iconurl) placeholderImage:V_IMAGE(@"默认头像") options:SDWebImageRefreshCached];
        self.nameLabel.text = model.nickname;
        NSDate *date = [NSDate dateWithString:model.createtime formatString:@"yyyy-MM-dd HH:mm:ss"];
        self.dateLabel.text = [NSString stringWithFormat:@"%@月%@日",[NSString convertDateSingleData:date.month],[NSString convertDateSingleData:date.day]];
        if ([HJDealNullTool isNotNULL:model.userzone] && [HJDealNullTool isNotNULL:model.userterminal]) {
            self.addressLabel.text = [NSString stringWithFormat:@"%@网友 %@",model.userzone,model.userterminal];
        } else {
            self.addressLabel.text = [NSString stringWithFormat:@"未知区域网友"];
        }
        self.desLabel.text = model.commentcontent;
    }
}

@end
