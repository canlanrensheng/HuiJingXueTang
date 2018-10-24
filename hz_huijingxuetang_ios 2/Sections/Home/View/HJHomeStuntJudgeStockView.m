//
//  HJHomeStuntJudgeStockView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/22.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJHomeStuntJudgeStockView.h"
#import "HJHomeStuntJudgeStockModel.h"
#import "HJHomeViewModel.h"
@interface HJHomeStuntJudgeStockView ()

@property (nonatomic,strong) HJHomeViewModel *listViewModel;
@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation HJHomeStuntJudgeStockView

- (void)hj_configSubViews {
    
    self.backgroundColor = Background_Color;
    
    //限时秒杀
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = HEXColor(@"#22476B");
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10.0));
        make.size.mas_equalTo(CGSizeMake(kWidth(2.0), kHeight(14)));
        make.top.equalTo(self).offset(kHeight(25));
    }];
    
    UILabel *timeKillLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"绝技诊股",MediumFont(font(15)),HEXColor(@"#22476B"));
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
    _scrollView.scrollEnabled = YES;
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView);
        make.right.equalTo(self);
        make.top.equalTo(lineView.mas_bottom).offset(kHeight(20.0));
        make.height.mas_equalTo(kHeight(275));
    }];
}

- (void)reloadScrollViewWithImageArr:(NSArray *)assets{
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger assetCount = assets.count;
    CGFloat width = kWidth(225);
    CGFloat height = kHeight(275);
    CGFloat padding = kWidth(10.0);
    for (NSInteger i = 0; i < assetCount; i++) {
        UIView *backView = [[UIView alloc] init];
        backView.frame = CGRectMake((width + padding) * i, 0, width, height);
        backView.backgroundColor = white_color;
        [self.scrollView addSubview:backView];
        
        HJHomeStuntJudgeStockModel *model = assets[i];
        
        backView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        backView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
        backView.layer.shadowOffset = CGSizeMake(0,1);
        backView.layer.shadowOpacity = 1;
        backView.layer.shadowRadius = 5;
        backView.layer.cornerRadius = 5;
        backView.clipsToBounds = YES;
        
        //头像图片
        UIImageView *iconImageV = [[UIImageView alloc] init];
//        iconImageV.image = V_IMAGE(@"");
        [iconImageV sd_setImageWithURL:URL(model.createiconurl) placeholderImage:V_IMAGE(@"占位图")];
        [iconImageV clipWithCornerRadius:kWidth(10.0) borderColor:nil borderWidth:0];
        iconImageV.backgroundColor = Background_Color;
        [backView addSubview:iconImageV];
        [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView).offset(kWidth(10));
            make.width.height.mas_equalTo(kWidth(20));
            make.top.equalTo(backView).offset(kHeight(15.0));
        }];
        
        //标题
        UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(model.createname,MediumFont(font(11)),HEXColor(@"#666666"));
            label.textAlignment = NSTextAlignmentLeft;
            [label sizeToFit];
        }];
        [backView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(iconImageV);
            make.left.equalTo(iconImageV.mas_right).offset(kWidth(5.0));
            make.height.mas_equalTo(kHeight(11.0));
        }];
        
        UIButton *wenBtn = [UIButton creatButton:^(UIButton *button) {
            button.ljTitle_font_titleColor_state(@"问",MediumFont(font(10)),white_color,0);
            [button setBackgroundImage:V_IMAGE(@"问标签") forState:UIControlStateNormal
                 ];
        }];
        [backView addSubview:wenBtn];
        [wenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backView);
            make.top.equalTo(backView).offset(kHeight(21.0));
        }];
        
        //问题描述
        UILabel *questionDesLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(model.questiondes,BoldFont(font(14)),HEXColor(@"#333333"));
            label.textAlignment = NSTextAlignmentLeft;
            label.numberOfLines = 2;
            [label sizeToFit];
        }];
        NSString *question = [NSString stringWithFormat:@"%@ %@",model.questiontitle,model.questiondes];
        questionDesLabel.attributedText = [question fuWenBenWithStr:model.questiontitle withColor:HEXColor(@"#22476B") withFont:BoldFont(font(14))];
        [backView addSubview:questionDesLabel];
        [questionDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageV);
            make.right.equalTo(backView).offset(-kWidth(12));
            make.top.equalTo(iconImageV.mas_bottom).offset(kHeight(15.0));
        }];
        
        //分割线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
        [backView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(backView);
            make.height.mas_equalTo(kHeight(0.5));
            make.top.equalTo(questionDesLabel.mas_bottom).offset(kHeight(42.0));
        }];
        
        //答的人
        //头像图片
        UIImageView *answerIconImageV = [[UIImageView alloc] init];
//        answerIconImageV.image = V_IMAGE(@"");
        [answerIconImageV sd_setImageWithURL:URL(model.updateiconurl) placeholderImage:V_IMAGE(@"占位图")];
        [answerIconImageV clipWithCornerRadius:kWidth(10.0) borderColor:nil borderWidth:0];
        answerIconImageV.backgroundColor = Background_Color;
        [backView addSubview:answerIconImageV];
        [answerIconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView).offset(kWidth(10));
            make.width.height.mas_equalTo(kWidth(20));
            make.top.equalTo(lineView.mas_bottom).offset(kHeight(16.0));
        }];
        
        //标题
        UILabel *answerNameLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(model.updatename,MediumFont(font(11)),HEXColor(@"#666666"));
            label.textAlignment = NSTextAlignmentLeft;
            [label sizeToFit];
        }];
        [backView addSubview:answerNameLabel];
        [answerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(answerIconImageV);
            make.left.equalTo(answerIconImageV.mas_right).offset(kWidth(5.0));
            make.height.mas_equalTo(kHeight(11.0));
        }];
        
        UIButton *answerBtn = [UIButton creatButton:^(UIButton *button) {
            button.ljTitle_font_titleColor_state(@"答",MediumFont(font(10)),white_color,0);
            [button setBackgroundImage:V_IMAGE(@"答标签") forState:UIControlStateNormal
             ];
        }];
        [backView addSubview:answerBtn];
        [answerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backView);
//            make.top.equalTo(backView).offset(kHeight(21.0));
            make.centerY.equalTo(answerNameLabel);
        }];
        
        //问题描述
        UILabel *answerDesLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(model.answer,BoldFont(font(14)),HEXColor(@"#333333"));
            label.textAlignment = NSTextAlignmentLeft;
            label.numberOfLines = 2;
            [label sizeToFit];
        }];
        [backView addSubview:answerDesLabel];
        [answerDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(answerIconImageV);
            make.right.equalTo(backView).offset(-kWidth(12));
            make.top.equalTo(answerIconImageV.mas_bottom).offset(kHeight(15.0));
        }];
        
        //时间
        UILabel *timeLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(model.answertime,MediumFont(font(10)),HEXColor(@"#999999"));
            label.textAlignment = NSTextAlignmentLeft;
            [label sizeToFit];
        }];
        [backView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView).offset(kWidth(10.0));
            make.bottom.equalTo(backView).offset(-kHeight(10.0));
            make.height.mas_equalTo(kHeight(10.0));
        }];
        
        //箭头图标
        UIImageView *arrowImageV = [[UIImageView alloc] init];
        arrowImageV.image = V_IMAGE(@"查看更多箭头");
        [backView addSubview:arrowImageV];
        [arrowImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(timeLabel);
            make.right.equalTo(backView).offset(-kWidth(10));
        }];
        
        //查看详情
        UIButton *loodDetailBtn = [UIButton creatButton:^(UIButton *button) {
            button.ljTitle_font_titleColor_state(@"查看详情",MediumFont(font(13)),HEXColor(@"#1D3043"),0);
        }];
        [backView addSubview:loodDetailBtn];
        [loodDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(timeLabel);
            make.right.equalTo(arrowImageV.mas_left).offset(-kWidth(5.0));
        }];
        
    }
    //self.scrollView.backgroundColor = [UIColor redColor];
    self.scrollView.contentSize = CGSizeMake((width + padding) * assetCount, CGRectGetMaxY([[self.scrollView.subviews lastObject] frame]));
    
}

- (void)setViewModel:(BaseViewModel *)viewModel {
    self.listViewModel = (HJHomeViewModel *)viewModel;
    if(self.listViewModel.stuntJudgeStockArray.count > 0) {
        [self reloadScrollViewWithImageArr:self.listViewModel.stuntJudgeStockArray];
    }
}


@end
