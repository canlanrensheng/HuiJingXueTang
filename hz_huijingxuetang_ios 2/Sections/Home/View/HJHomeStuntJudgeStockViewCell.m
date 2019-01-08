//
//  HJHomeStuntJudgeStockView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/22.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJHomeStuntJudgeStockViewCell.h"
#import "HJHomeStuntJudgeStockModel.h"
#import "HJHomeViewModel.h"
#import "HJStuntJudgeListModel.h"
@interface HJHomeStuntJudgeStockViewCell ()

@property (nonatomic,strong) HJHomeViewModel *listViewModel;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSIndexPath *indexPath;

@end

@implementation HJHomeStuntJudgeStockViewCell

- (void)hj_configSubViews {
    self.backgroundColor = Background_Color;
    self.opaque = YES;
    
    //轮播图
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.opaque = YES;
    _scrollView.backgroundColor = clear_color;
    _scrollView.scrollEnabled = YES;
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10));
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(kHeight(275 + 1));
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
        backView.opaque = YES;
        backView.frame = CGRectMake((width + padding) * i, 0, width, height);
        backView.tag = i;
        backView.backgroundColor = white_color;
        [self.scrollView addSubview:backView];
        
        HJHomeStuntJudgeStockModel *model = assets[i];
        
        backView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
        backView.layer.shadowOffset = CGSizeMake(0,1);
        backView.layer.shadowOpacity = 1;
        backView.layer.shadowRadius = 5;
        backView.layer.cornerRadius = 5;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTap:)];
        [backView addGestureRecognizer:tap];
        
        //头像图片
        UIImageView *iconImageV = [[UIImageView alloc] init];
//        iconImageV.image = V_IMAGE(@"");
        iconImageV.opaque = YES;
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
            label.opaque = YES;
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
            button.opaque = YES;
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
            label.opaque = YES;
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
        lineView.opaque = YES;
        [backView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(backView);
            make.height.mas_equalTo(kHeight(0.5));
//            make.top.equalTo(questionDesLabel.mas_bottom).offset(kHeight(42.0));
            make.centerY.equalTo(backView);
        }];
        
        //答的人
        //头像图片
        UIImageView *answerIconImageV = [[UIImageView alloc] init];
        answerIconImageV.opaque = YES;
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
            label.opaque = YES;
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
            button.opaque = YES;
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
            label.opaque = YES;
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
            label.opaque = YES;
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
        arrowImageV.opaque = YES;
        [backView addSubview:arrowImageV];
        [arrowImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(timeLabel);
            make.right.equalTo(backView).offset(-kWidth(10));
        }];
        
        //查看详情
        UIButton *loodDetailBtn = [UIButton creatButton:^(UIButton *button) {
            button.ljTitle_font_titleColor_state(@"查看详情",MediumFont(font(13)),HEXColor(@"#294D70"),0);
            //查看详情
            button.opaque = YES;
            @weakify(self);
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                if([APPUserDataIofo AccessToken].length <= 0) {
//                    ShowMessage(@"您还未登录");
                    [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
                    return;
                }
                
                HJHomeStuntJudgeStockModel *model = self.listViewModel.stuntJudgeStockArray[self.indexPath.row];
                NSDictionary *para = @{@"stuntId" : model.stuntId};
                [DCURLRouter pushURLString:@"route://stuntJudgeDetailVC" query:para animated:YES];
            }];
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

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    self.listViewModel = (HJHomeViewModel *)viewModel;
    self.indexPath = indexPath;
    if(self.listViewModel.stuntJudgeStockArray.count > 0) {
        [self reloadScrollViewWithImageArr:self.listViewModel.stuntJudgeStockArray];
    }
}

- (void)backTap:(UITapGestureRecognizer *)tap {
    if([APPUserDataIofo AccessToken].length <= 0) {
//        ShowMessage(@"您还未登录");
        [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
        return;
    }

    HJHomeStuntJudgeStockModel *model = self.listViewModel.stuntJudgeStockArray[tap.view.tag];
    NSDictionary *para = @{@"stuntId" : model.stuntId};
    [DCURLRouter pushURLString:@"route://stuntJudgeDetailVC" query:para animated:YES];
}


@end
