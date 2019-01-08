//
//  HJSchoolLiveCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/24.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSchoolLiveCell.h"
#import "HJSchoolLiveListViewModel.h"
#import "HJTeacherLiveModel.h"
@interface HJSchoolLiveCell ()

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIImageView *freeLiveImageV;
@property (nonatomic,strong) UILabel *courceLabel;
@property (nonatomic,strong) UILabel *studentCountLabel;
@property (nonatomic,strong) UILabel *liveTypeLabel;

@property (nonatomic,strong) UILabel *liveWarnLabel;
@property (nonatomic,strong) UILabel *liveNameLabel;

@property (nonatomic,strong) NSMutableArray *fireArray;
@property (nonatomic,strong) UIImageView *liveImageV;

@end


@implementation HJSchoolLiveCell

- (void)hj_configSubViews {
    //图片
    UIImageView *imaV = [[UIImageView alloc] init];
    imaV.image = V_IMAGE(@"占位图");
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
    
    //免费直播的标签
    UIImageView *freeLiveImageV = [[UIImageView alloc] init];
    freeLiveImageV.image = V_IMAGE(@"免费标签");
    [self addSubview:freeLiveImageV];
    freeLiveImageV.hidden = YES;
    [freeLiveImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imaV);
        make.top.equalTo(imaV);
    }];
    
    self.freeLiveImageV = freeLiveImageV;
    
    //名称
    UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",BoldFont(font(14)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 2;
        [label sizeToFit];
    }];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imaV).offset(kHeight(5.0));
        make.left.equalTo(imaV.mas_right).offset(kWidth(12.0));
        make.right.equalTo(self).offset(-kWidth(10));
    }];
    
    self.courceLabel = nameLabel;
    
    
    //星级
    CGFloat width = (kWidth(9) * 5 + kWidth(4) * 4);
    UIView *starView = [[UIView alloc] init];
    starView.backgroundColor = white_color;
    [self addSubview:starView];
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(7.0));
        make.height.mas_equalTo(kHeight(12));
        make.width.mas_equalTo(width);
    }];
    
    self.fireArray = [NSMutableArray array];
    for(int i = 0; i < 5;i++) {
        UIImageView *starImageView = [[UIImageView alloc] init];
        starImageView.frame = CGRectMake((kWidth(4 + 9) * i), 0, kWidth(9), kWidth(12));
        starImageView.backgroundColor = white_color;
        starImageView.image = V_IMAGE(@"火苗暗");
        [starView addSubview:starImageView];
        [self.fireArray addObject:starImageView];
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
        make.left.equalTo(starView.mas_right).offset(kWidth(4.0));
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
    UILabel *teacherLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"下次直播 : 暂无通告",MediumFont(font(11)),HEXColor(@"#666666"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:teacherLabel];
    
    [teacherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imaV).offset(-kHeight(5.0));
        make.left.equalTo(imaV.mas_right).offset(kWidth(13.0));
        make.height.mas_equalTo(kHeight(12.0));
    }];
    self.liveWarnLabel = teacherLabel;
    
    //直播图片
    UIImageView *liveImageV = [[UIImageView alloc] init];
    liveImageV.image = V_IMAGE(@"直播icon-1");
    [self addSubview:liveImageV];
    [liveImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(teacherLabel.mas_right).offset(kWidth(5.0));
        make.centerY.equalTo(teacherLabel);
    }];
    self.liveImageV = liveImageV;
    
    //直播的名称
    UILabel *liveNameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"《K线走势图》讲师：余春",MediumFont(font(13)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:liveNameLabel];
    [liveNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(teacherLabel.mas_top).offset(-kHeight(8.0));
        make.left.equalTo(teacherLabel);
        make.height.mas_equalTo(kHeight(13.0));
    }];
    self.liveNameLabel = liveNameLabel;
}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    HJSchoolLiveListViewModel *listViewModel = (HJSchoolLiveListViewModel *)viewModel;
    HJTeacherLiveModel *model = listViewModel.liveListArray[indexPath.row];
    if (model) {
        [self.imgView sd_setImageWithURL:URL(model.coursepic) placeholderImage:V_IMAGE(@"占位图")];
        
        if (model.courseid.integerValue == -1) {
            //免费直播
            self.courceLabel.text = [NSString stringWithFormat:@"%@老师的免费直播",model.realname];
            self.freeLiveImageV.hidden = NO;
            self.liveTypeLabel.text = @"免费直播";
            self.liveTypeLabel.textColor = HEXColor(@"#FF4400");
            [self.liveTypeLabel clipWithCornerRadius:kHeight(2.5) borderColor:HEXColor(@"#FF4400") borderWidth:kHeight(1.0)];
        } else {
            //付费直播
            self.courceLabel.text = [NSString stringWithFormat:@"%@",model.coursename];
            self.freeLiveImageV.hidden = YES;
            self.liveTypeLabel.text = @"付费直播";
            self.liveTypeLabel.textColor = HEXColor(@"#22476B");
            [self.liveTypeLabel clipWithCornerRadius:kHeight(2.5) borderColor:HEXColor(@"#22476B") borderWidth:kHeight(1.0)];
        }
        
        if(MaJia) {
            self.freeLiveImageV.hidden = YES;
            self.liveTypeLabel.hidden = YES;
        }
        
        if(model.l_courseid.length > 0) {
            //正在直播
            NSString *livecoursename = [NSString stringWithFormat:@"《%@》 讲师：%@",model.l_livecoursename,model.realname];
            self.liveNameLabel.attributedText = [livecoursename attributeWithStr:[NSString stringWithFormat:@"讲师：%@",model.realname] color:HEXColor(@"#999999") font:MediumFont(font(11))];
            
            self.liveImageV.hidden = NO;
            self.liveWarnLabel.text = @"正在直播";
            self.liveWarnLabel.textColor = HEXColor(@"#0ABC64");
            for (int i = 0;i < 5 ;i++){
                UIImageView *imaV = self.fireArray[i];
                if(i < model.l_buzz.intValue) {
                    imaV.image = V_IMAGE(@"热度ICON");
                } else {
                    imaV.image = V_IMAGE(@"火苗暗");
                }
            }
        } else if (model.a_courseid.length > 0) {
            //直播预告
            NSString *livecoursename = [NSString stringWithFormat:@"《%@》 讲师：%@",model.a_livecoursename,model.realname];
            self.liveNameLabel.attributedText = [livecoursename attributeWithStr:[NSString stringWithFormat:@"讲师：%@",model.realname] color:HEXColor(@"#999999") font:MediumFont(font(11))];
            
            self.liveImageV.hidden = YES;
            if(model.a_starttime.length > 0) {
                NSDate *startDate = [NSDate dateWithString:model.a_starttime formatString:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *endDate = [NSDate dateWithString:model.a_endtime formatString:@"yyyy-MM-dd HH:mm:ss"];
                self.liveWarnLabel.text = [NSString stringWithFormat:@"下次直播 : %@月%@日 %@:%@-%@:%@",[NSString convertDateSingleData:startDate.month],[NSString convertDateSingleData:startDate.day],[NSString convertDateSingleData:startDate.hour],[NSString convertDateSingleData:startDate.minute],[NSString convertDateSingleData:endDate.hour],[NSString convertDateSingleData:endDate.minute]];
            } else {
                self.liveWarnLabel.text = @"下次直播 : 暂无通告";
            }
            
            self.liveWarnLabel.textColor = HEXColor(@"#666666");
            for (int i = 0;i < 5 ;i++){
                UIImageView *imaV = self.fireArray[i];
                if(i < model.a_buzz.intValue) {
                    imaV.image = V_IMAGE(@"热度ICON");
                } else {
                    imaV.image = V_IMAGE(@"火苗暗");
                }
            }
        } else if (model.p_courseid.length > 0) {
            //直播回放
            NSString *livecoursename = [NSString stringWithFormat:@"讲师：%@",model.realname];
            self.liveNameLabel.attributedText = [livecoursename attributeWithStr:[NSString stringWithFormat:@"讲师：%@",model.realname] color:HEXColor(@"#999999") font:MediumFont(font(11))];
            self.liveImageV.hidden = YES;
//            if(model.p_starttime.length > 0) {
//                NSDate *startDate = [NSDate dateWithString:model.p_starttime formatString:@"yyyy-MM-dd HH:mm:ss"];
//                NSDate *endDate = [NSDate dateWithString:model.p_starttime formatString:@"yyyy-MM-dd HH:mm:ss"];
//                self.liveWarnLabel.text = [NSString stringWithFormat:@"下次直播 : %@月%@日 %@:%@-%@:%@",[NSString convertDateSingleData:startDate.month],[NSString convertDateSingleData:startDate.day],[NSString convertDateSingleData:startDate.hour],[NSString convertDateSingleData:startDate.minute],[NSString convertDateSingleData:endDate.hour],[NSString convertDateSingleData:endDate.minute]];
//            } else {
                self.liveWarnLabel.text = @"下次直播 : 暂无通告";
//            }
            self.liveWarnLabel.textColor = HEXColor(@"#666666");
            for (int i = 0;i < 5 ;i++){
                UIImageView *imaV = self.fireArray[i];
                if(i < model.p_buzz.intValue) {
                    imaV.image = V_IMAGE(@"热度ICON");
                } else {
                    imaV.image = V_IMAGE(@"火苗暗");
                }
            }
        } else {
            NSString *livecoursename = [NSString stringWithFormat:@"讲师：%@",model.realname];
            self.liveNameLabel.attributedText = [livecoursename attributeWithStr:[NSString stringWithFormat:@"讲师：%@",model.realname] color:HEXColor(@"#999999") font:MediumFont(font(11))];
            
            self.liveImageV.hidden = YES;
            self.liveWarnLabel.text = @"下次直播 : 暂无通告";
            self.liveWarnLabel.textColor = HEXColor(@"#666666");
            for (int i = 0;i < 5 ;i++){
                UIImageView *imaV = self.fireArray[i];
                imaV.image = V_IMAGE(@"火苗暗");
            }
        }
        
    }
}

@end
