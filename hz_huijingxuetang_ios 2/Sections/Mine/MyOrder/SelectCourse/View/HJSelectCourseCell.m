//
//  HJSelectCourseCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/11.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSelectCourseCell.h"

@interface HJSelectCourseCell ()

@property (nonatomic,strong) UIImageView *courseImageView;
@property (nonatomic,strong) UILabel *courseNameLabel;

@property (nonatomic,strong) UILabel *evaluationStatusLabel;

@end

@implementation HJSelectCourseCell

- (void)hj_configSubViews {
    UIImageView *imaV = [[UIImageView alloc] init];
//    [imaV sd_setImageWithURL:URL(model.coursepic) placeholderImage:V_IMAGE(@"占位图")];
    imaV.backgroundColor = Background_Color;
    [self addSubview:imaV];
    [imaV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(kWidth(10.0));
        make.width.mas_equalTo(kWidth(97));
        make.height.mas_equalTo(kHeight(60));
    }];
    [imaV clipWithCornerRadius:kHeight(5.0) borderColor:nil borderWidth:0];
    
    self.courseImageView = imaV;
    
    //名称
    UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",BoldFont(font(13)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 2.0;
        [label sizeToFit];
    }];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imaV).offset(kHeight(5.0));
        make.left.equalTo(imaV.mas_right).offset(kWidth(10.0));
        make.right.equalTo(self).offset(-kWidth(10));
    }];
    self.courseNameLabel = nameLabel;
    
    //去评价的提示
    UILabel *toEvaluationLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"已评价",MediumFont(font(13)),HEXColor(@"#666666"));
        label.textAlignment = NSTextAlignmentRight;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:toEvaluationLabel];
    [toEvaluationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-kWidth(10));
        make.bottom.equalTo(self).offset(-kHeight(16.0));
        make.height.mas_equalTo(kHeight(13.0));
    }];
    self.evaluationStatusLabel = toEvaluationLabel;
}

- (void)setModel:(CourseResponsesModel *)model {
    _model = model;
    [self.courseImageView sd_setImageWithURL:URL(model.coursepic) placeholderImage:V_IMAGE(@"占位图")];
    self.courseNameLabel.text = model.coursename;
    NSString *isToStudy = VisibleViewController().params[@"isToStudy"];
    if([isToStudy integerValue] == 1) {
        //跳转到课程详情
        self.evaluationStatusLabel.text = @"去学习";
        self.evaluationStatusLabel.textColor = NavigationBar_Color;
    } else {
        //跳转到评价的页面
        if([model.courseCommentStatus isEqualToString:@"y"]) {
            self.evaluationStatusLabel.text = @"已评价";
            self.evaluationStatusLabel.textColor = HEXColor(@"#666666");
        } else {
            self.evaluationStatusLabel.text = @"去评价";
            self.evaluationStatusLabel.textColor = HEXColor(@"#DD9C50");
        }
    }
    
}

@end
