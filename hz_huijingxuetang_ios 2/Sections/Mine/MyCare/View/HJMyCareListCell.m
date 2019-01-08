//
//  HJMyCareListCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/9.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMyCareListCell.h"
#import "HJMyCareViewModel.h"
#import "HJMyCareListModle.h"

@interface HJMyCareListCell ()

@property (nonatomic,strong) UIImageView *liveImageV;
@property (nonatomic,strong) UILabel *titleTextLabel;
@property (nonatomic,strong) UILabel *desTextLabel;

@end

@implementation HJMyCareListCell

- (void)hj_configSubViews {
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIImageView *liveImageV = [[UIImageView alloc] init];
    liveImageV.image = V_IMAGE(@"占位图");
    [self addSubview:liveImageV];
    [liveImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kWidth(40), kHeight(40)));
    }];
    [liveImageV clipWithCornerRadius:kHeight(20.0) borderColor:nil borderWidth:0.0];
    
    self.liveImageV = liveImageV;
    
    //标题
    UILabel *titleTextLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"俞春",MediumFont(font(15)),HEXColor(@"#333333"));
        label.textAlignment = TextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:titleTextLabel];
    [titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(liveImageV).offset(kHeight(4.0));
        make.left.equalTo(liveImageV.mas_right).offset(kWidth(11.0));
        make.height.mas_equalTo(kHeight(15));
    }];
    self.titleTextLabel = titleTextLabel;
    
    //描述
    UILabel *desTextLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"慧鲸特邀专家",MediumFont(font(13)),HEXColor(@"#999999"));
        label.textAlignment = TextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:desTextLabel];
    [desTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleTextLabel.mas_bottom).offset(kHeight(5.0));
        make.left.equalTo(titleTextLabel);
        make.height.mas_equalTo(kHeight(13));
    }];
    self.desTextLabel = desTextLabel;
}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    HJMyCareViewModel *listViewModel = (HJMyCareViewModel *)viewModel;
    HJMyCareListModle *model = listViewModel.myCareArray[indexPath.row];
    if (model) {
        [self.liveImageV sd_setImageWithURL:URL(model.iconurl) placeholderImage:V_IMAGE(@"默认头像")];
        self.titleTextLabel.text = model.realname;
        self.desTextLabel.text = model.teacprofessional;
    }
}

@end
