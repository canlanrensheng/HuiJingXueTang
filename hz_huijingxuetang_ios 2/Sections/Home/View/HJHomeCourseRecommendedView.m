//
//  HJHomeCourseRecommendedView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/22.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJHomeCourseRecommendedView.h"
#import "HJHomeViewModel.h"
#import "HJHomeCourseRecommendedModel.h"
@interface HJHomeCourseRecommendedView ()

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) HJHomeViewModel *listViewModel;
@property (nonatomic,strong) UIView *lineView;

@end

@implementation HJHomeCourseRecommendedView

- (void)hj_configSubViews {
    self.backgroundColor = white_color;
    
    UIView *topiew = [[UIView alloc] init];
    topiew.backgroundColor = Background_Color;
    [self addSubview:topiew];
    [topiew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(kHeight(10.0));
    }];
    
    //限时秒杀
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = HEXColor(@"#22476B");
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10.0));
        make.size.mas_equalTo(CGSizeMake(kWidth(2.0), kHeight(14)));
        make.top.equalTo(topiew.mas_bottom).offset(kHeight(25));
    }];
    self.lineView = lineView;
    
    UILabel *timeKillLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"课程推荐",MediumFont(font(15)),HEXColor(@"#22476B"));
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:timeKillLabel];
    [timeKillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineView);
        make.left.equalTo(lineView.mas_right).offset(kWidth(5.0));
    }];
    
    //更多按钮
    UIButton *moreBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"",H15,white_color,0);
        [button setBackgroundImage:V_IMAGE(@"更多") forState:UIControlStateNormal];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            
        }];
    }];
    [self addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineView);
        make.right.equalTo(self).offset(-kWidth(10.0));
    }];
    
    //轮播图
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = Background_Color;
    _scrollView.scrollEnabled = NO;
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView);
        make.right.equalTo(self);
        make.top.equalTo(lineView.mas_bottom).offset(kHeight(20.0));
        make.height.mas_equalTo(kHeight(300));
    }];
    
}

- (void)reloadScrollViewWithImageArr:(NSArray *)assets{
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger assetCount = assets.count;
    CGFloat width = Screen_Width - kWidth(10);
    CGFloat height = kHeight(100.0);
//    CGFloat padding = kWidth(15.0);
    for (NSInteger i = 0; i < assetCount; i++) {
        HJHomeCourseRecommendedModel *model = assets[i];
        UIView *backView = [[UIView alloc] init];
        backView.frame = CGRectMake(0, height * i, width, height);
        backView.backgroundColor = white_color;
        [self.scrollView addSubview:backView];

        //图片
        UIImageView *imaV = [[UIImageView alloc] init];
//        imaV.image = V_IMAGE(@"");
        [imaV sd_setImageWithURL:URL(model.coursepic) placeholderImage:V_IMAGE(@"占位图")];
        imaV.backgroundColor = Background_Color;
        [backView addSubview:imaV];
        [imaV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backView);
            make.left.equalTo(backView).offset(kWidth(10.0));
            make.width.mas_equalTo(kWidth(140));
            make.height.mas_equalTo(kHeight(90));
        }];
        [imaV clipWithCornerRadius:kHeight(5.0) borderColor:nil borderWidth:0];

        //名称
        UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(model.coursename,BoldFont(font(11)),HEXColor(@"#333333"));
            label.textAlignment = NSTextAlignmentLeft;
            [label sizeToFit];
        }];
        [backView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imaV).offset(kHeight(5.0));
            make.left.equalTo(imaV.mas_right).offset(kWidth(12.0));
            make.height.mas_equalTo(kHeight(13.0));
        }];

        //星级
        UIView *starView = [[UIView alloc] init];
        starView.backgroundColor = white_color;
        [backView addSubview:starView];
        [starView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel);
            make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(8.0));
            make.height.mas_equalTo(kHeight(11));
        }];

        for(int i = 0; i < 5;i++) {
            UIImageView *starImageView = [[UIImageView alloc] init];
            starImageView.frame = CGRectMake((kWidth(2 + 11) * i), 0, kWidth(11), kWidth(11));
            starImageView.backgroundColor = white_color;
            starImageView.image = V_IMAGE(@"评价星星");
            [starView addSubview:starImageView];
        }

        //星级Label
        UILabel *starCountLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor([NSString stringWithFormat:@"5.0 %tu人学过",model.study_count],MediumFont(font(11)),HEXColor(@"#999999"));
            label.textAlignment = NSTextAlignmentLeft;
            [label sizeToFit];
        }];
        [backView addSubview:starCountLabel];
        [starCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(10.0));
            make.centerY.equalTo(starView);
            make.left.equalTo(imaV.mas_right).offset(kWidth(87.0));
            make.height.mas_equalTo(kHeight(13.0));
        }];

        //讲师
        UILabel *teacherLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"讲师：金建",MediumFont(font(13)),HEXColor(@"#666666"));
            label.textAlignment = NSTextAlignmentLeft;
            [label sizeToFit];
        }];
        [backView addSubview:teacherLabel];
        [teacherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(imaV).offset(-kHeight(5.0));
            make.left.equalTo(imaV.mas_right).offset(kWidth(13.0));
            make.height.mas_equalTo(kHeight(12.0));
        }];
        
        //天数
        UILabel *dayLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor([NSString stringWithFormat:@"/%@天",model.periods],MediumFont(font(11)),HEXColor(@"#FF4400"));
            label.textAlignment = NSTextAlignmentRight;
            [label sizeToFit];
        }];
        [backView addSubview:dayLabel];
        [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backView).offset(-kWidth(10.0));
            make.centerY.equalTo(teacherLabel);
            make.height.mas_equalTo(kHeight(12.0));
        }];

        //价格
        UILabel *priceLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor([NSString stringWithFormat:@"¥ %.0f",model.coursemoney],BoldFont(font(15)),HEXColor(@"#FF4400"));
            label.textAlignment = NSTextAlignmentRight;
            [label sizeToFit];
        }];
        [backView addSubview:priceLabel];
        
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(dayLabel.mas_left);
            make.centerY.equalTo(teacherLabel);
            make.height.mas_equalTo(kHeight(14.0));
        }];
        
        NSString *price = [NSString stringWithFormat:@"¥ %.0f",model.coursemoney];
        priceLabel.attributedText = [price attributeWithStr:@"¥" color:HEXColor(@"#FF4400") font:BoldFont(font(13))];
    }
    //self.scrollView.backgroundColor = [UIColor redColor];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY([[self.scrollView.subviews lastObject] frame]));

}


- (void)setViewModel:(BaseViewModel *)viewModel {
    self.listViewModel = (HJHomeViewModel *)viewModel;
    if(self.listViewModel.recommongCourceDataArray.count > 0) {
        [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lineView);
            make.right.equalTo(self);
            make.top.equalTo(self.lineView.mas_bottom).offset(kHeight(20.0));
            make.height.mas_equalTo(kHeight(self.listViewModel.recommongCourceDataArray.count * 100));
        }];
        [self reloadScrollViewWithImageArr:self.listViewModel.recommongCourceDataArray];
    }
}


@end
