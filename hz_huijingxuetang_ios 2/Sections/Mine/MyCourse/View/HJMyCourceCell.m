//
//  HJMyCourceCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/9.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMyCourceCell.h"
#import "HJBuyedCourceViewModel.h"
#import "HJMyCourseModel.h"

@interface HJMyCourceCell()

@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *teacherLabel;
@property (nonatomic,strong) UILabel *dayLabel;

@end

@implementation HJMyCourceCell

- (void)hj_configSubViews {
    //图片
    UIImageView *imaV = [[UIImageView alloc] init];
    imaV.image = V_IMAGE(@"占位图");
    imaV.backgroundColor = Background_Color;
    imaV.userInteractionEnabled = YES;
    [self addSubview:imaV];
    [imaV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(kWidth(10.0));
        make.width.mas_equalTo(kWidth(127));
        make.height.mas_equalTo(kHeight(70));
    }];
    [imaV clipWithCornerRadius:kHeight(2.5) borderColor:nil borderWidth:0];
    self.imageV = imaV;
    
    //名称
    UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"重温经典系列之新K线战法",BoldFont(font(13)),HEXColor(@"#333333"));
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imaV).offset(kHeight(5.0));
        make.left.equalTo(imaV.mas_right).offset(kWidth(10.0));
        make.right.equalTo(self).offset(-kWidth(10.0));
//        make.height.mas_equalTo(kHeight(13.0));
    }];
    self.nameLabel = nameLabel;

    //讲师
    UILabel *teacherLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"讲师：金建",MediumFont(font(10)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:teacherLabel];
    [teacherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(7.0));
        make.left.equalTo(nameLabel);
        make.height.mas_equalTo(kHeight(11.0));
    }];
    self.teacherLabel = teacherLabel;
    
    //天数
    UILabel *dayLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"下一节课： 09月29日 10:30-11:30",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:dayLabel];
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.bottom.equalTo(imaV).offset(-kHeight(5.0));
        make.height.mas_equalTo(kHeight(11.0));
    }];
    self.dayLabel = dayLabel;

}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    HJBuyedCourceViewModel *listViewModel = (HJBuyedCourceViewModel *)viewModel;
    HJMyCourseModel *model = listViewModel.courseListArray[indexPath.row];
    if (model){
        [self.imageV sd_setImageWithURL:URL(model.coursepic) placeholderImage:V_IMAGE(@"占位图") options:SDWebImageRefreshCached];
        self.nameLabel.text = model.coursename;
        self.teacherLabel.text = [NSString stringWithFormat:@"讲师：%@",model.realname];
        self.dayLabel.text = @"继续学习";
    }
}

@end
