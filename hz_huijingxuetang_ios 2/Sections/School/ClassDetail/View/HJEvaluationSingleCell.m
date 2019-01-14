//
//  HJEvaluationSingleCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/25.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJEvaluationSingleCell.h"
#import "HJClassDetailViewModel.h"
#import "HJCourseDetailCommentModel.h"

@interface HJEvaluationSingleCell ()

@property (nonatomic,strong) UIView *starView;
@property (nonatomic,strong) NSMutableArray *starImgMarr;
@property (nonatomic,strong) UIImageView *imaV;
@property (nonatomic,strong) UILabel *starCountLabel;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *desLabel;

@end

@implementation HJEvaluationSingleCell

- (void)hj_configSubViews {
    //图片
    UIImageView *imaV = [[UIImageView alloc] init];
    imaV.image = V_IMAGE(@"默认头像");
    imaV.backgroundColor = Background_Color;
    [self addSubview:imaV];
    [imaV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kHeight(13.0));
        make.left.equalTo(self).offset(kWidth(10.0));
        make.width.mas_equalTo(kWidth(45));
        make.height.mas_equalTo(kHeight(45));
    }];
    [imaV clipWithCornerRadius:kHeight(22.5) borderColor:nil borderWidth:0];
    self.imaV = imaV;
    
    //名称
    UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"明天会更好",MediumFont(font(11)),HEXColor(@"#666666"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imaV).offset(kHeight(8.0));
        make.left.equalTo(imaV.mas_right).offset(kWidth(10.0));
        make.height.mas_equalTo(kHeight(11.0));
    }];
    self.nameLabel = nameLabel;
    
    //时间
    UILabel *timeLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"8月24日",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentRight;
        [label sizeToFit];
    }];
    [self addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameLabel);
        make.right.equalTo(self).offset(-kWidth(10.0));
        make.height.mas_equalTo(kHeight(10.0));
    }];
    self.timeLabel = timeLabel;
    
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
    self.starView = starView;
    
    self.starImgMarr = [NSMutableArray array];
    for(int i = 0; i < 5;i++) {
        UIImageView *starImageView = [[UIImageView alloc] init];
        starImageView.frame = CGRectMake((kWidth(2 + 11) * i), 0, kWidth(11), kWidth(11));
        starImageView.backgroundColor = white_color;
        starImageView.image = V_IMAGE(@"评价星星");
        [starView addSubview:starImageView];
        [self.starImgMarr addObject:starImageView];
    }
    
    //星级Label
    UILabel *starCountLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:starCountLabel];
    [starCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(starView);
        make.left.equalTo(starView.mas_right).offset(kWidth(6.0));
        make.height.mas_equalTo(kHeight(9.0));
    }];
    self.starCountLabel = starCountLabel;
    
    //描述
    UILabel *desLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(13)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:desLabel];
//    desLabel.backgroundColor = red_color;
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-kWidth(10.0));
        make.top.equalTo(starView.mas_bottom).offset(kHeight(10.0));
        make.left.equalTo(nameLabel);
        make.bottom.equalTo(self).offset(-kHeight(16.0));
    }];
    self.desLabel = desLabel;
    
    //分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = Line_Color;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(kHeight(0.5));
    }];
}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    HJClassDetailViewModel *listViewModel = (HJClassDetailViewModel *)viewModel;
    HJCourseDetailCommentModel *model = listViewModel.commentArray[indexPath.row];
    if(model){
        [self.imaV sd_setImageWithURL:URL(model.iconurl) placeholderImage:V_IMAGE(@"默认头像") options:SDWebImageRefreshCached];
        self.nameLabel.text = model.nickname;
        float fStaLevel = model.coursescore.floatValue;
        if(fStaLevel == model.coursescore.intValue) {
            for (int i = 0;i < 5 ;i++){
                UIImageView *imaV = self.starImgMarr[i];
                if(i < model.coursescore.intValue) {
                    imaV.image = V_IMAGE(@"评价星亮色");
                } else {
                    imaV.image = V_IMAGE(@"评价星 暗色");
                }
            }
        } else{
            for (int i = 0;i < 5 ;i++){
                UIImageView *imaV = self.starImgMarr[i];
                if(i < ceilf(model.coursescore.floatValue) - 1) {
                    imaV.image = V_IMAGE(@"评价星亮色");
                }  else if(i == ceilf(model.coursescore.floatValue) - 1){
                    imaV.image = V_IMAGE(@"评价星亮色-1");
                } else {
                    imaV.image = V_IMAGE(@"评价星 暗色");
                }
            }
        }
        self.starCountLabel.text = [NSString stringWithFormat:@"%.1f",model.coursescore.floatValue];
        self.desLabel.text = model.commentcontent;
        NSDate *date = [NSDate dateWithString:model.createtime formatString:@"yyyy-MM-dd HH:mm:ss"];
        self.timeLabel.text = [NSString stringWithFormat:@"%@月%@日",[NSString convertDateSingleData:date.month],[NSString convertDateSingleData:date.day]];
    }
}

@end
