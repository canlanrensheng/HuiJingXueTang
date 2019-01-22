//
//  HJWatchHistoryLiveCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/9.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJWatchHistoryLiveCell.h"

@interface HJWatchHistoryLiveCell ()

@property (nonatomic,strong) UIImageView *imaV;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *teacherLabel;
@property (nonatomic,strong) UILabel *timeLabel;

@end

@implementation HJWatchHistoryLiveCell

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
    self.imaV = imaV;
    
    //名称
    UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",BoldFont(font(13)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 2;
        [label sizeToFit];
    }];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imaV).offset(kHeight(5.0));
        make.left.equalTo(imaV.mas_right).offset(kWidth(10.0));
//        make.height.mas_equalTo(kHeight(13.0));
        make.right.equalTo(self).offset(-kWidth(10));
    }];
    self.nameLabel = nameLabel;
    
    //天数
    UILabel *dayLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"讲师：",MediumFont(font(11)),HEXColor(@"#666666"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:dayLabel];
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.bottom.equalTo(imaV).offset(-kHeight(5.0));
        make.height.mas_equalTo(kHeight(11.0));
    }];
    self.teacherLabel = dayLabel;
    
    //时间
    UILabel *timeLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"继续学习",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentRight;
        [label sizeToFit];
    }];
    [self addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(dayLabel);
        make.right.equalTo(self).offset(-kWidth(10.0));
        make.height.mas_equalTo(kHeight(11.0));
    }];
    self.timeLabel = timeLabel;
    
}

- (void)setModel:(HJLiveDetailModel *)model {
    Course *courseModel = model.course;
    [self.imaV sd_setImageWithURL:URL(courseModel.coursepic) placeholderImage:V_IMAGE(@"占位图") options:SDWebImageRefreshCached];
    self.nameLabel.text = courseModel.coursename;
    self.teacherLabel.text = [NSString stringWithFormat:@"讲师：%@",courseModel.realname];
    NSDate *startDate = model.course.date;
    self.timeLabel.text = [NSDate compareCurrentTime:startDate];
}


@end
