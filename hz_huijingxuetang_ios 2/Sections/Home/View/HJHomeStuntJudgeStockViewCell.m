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
    CGFloat width = kWidth(220);
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
        
        //回答者的头像的信息
        UIImageView *iconImageV = [[UIImageView alloc] init];
        iconImageV.opaque = YES;
        [iconImageV sd_setImageWithURL:URL(model.updateiconurl) placeholderImage:V_IMAGE(@"默认头像") options:SDWebImageRefreshCached];
        [iconImageV clipWithCornerRadius:kWidth(12.0) borderColor:nil borderWidth:0];
        iconImageV.backgroundColor = Background_Color;
        [backView addSubview:iconImageV];
        [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView).offset(kWidth(10));
            make.width.height.mas_equalTo(kWidth(24.0));
            make.top.equalTo(backView).offset(kHeight(20.0));
        }];
        
        //老师的名称
        UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(model.updatename,MediumFont(font(11)),HEXColor(@"#666666"));
            label.textAlignment = NSTextAlignmentLeft;
            label.opaque = YES;
            [label sizeToFit];
        }];
        [backView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(iconImageV);
            make.left.equalTo(iconImageV.mas_right).offset(kWidth(8.0));
            make.height.mas_equalTo(kHeight(11.0));
        }];
        
        //左边分割线
        UIView *leftLineView = [[UIView alloc] init];
        leftLineView.backgroundColor = HEXColor(@"#E8AC4D");
        [backView addSubview:leftLineView];
        [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconImageV.mas_bottom).offset(kHeight(11.0));
            make.left.equalTo(backView);
            make.size.mas_equalTo(CGSizeMake(kWidth(3.0), kHeight(40.0)));
        }];
        
        //股票的代码或者名称
        UILabel *stockNameLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor([NSString stringWithFormat:@"%@%@",model.questiontitle,model.questiondes],BoldFont(font(14)),HEXColor(@"#333333"));
            label.textAlignment = NSTextAlignmentLeft;
            label.numberOfLines = 2;
            [label sizeToFit];
        }];
        [backView addSubview:stockNameLabel];
        [stockNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftLineView.mas_right).offset(kWidth(8.0));
            make.right.equalTo(backView).offset(-kWidth(10.0));
//            make.top.equalTo(leftLineView).offset(kHeight(3.0));
            make.centerY.equalTo(leftLineView);
            make.height.mas_equalTo(kHeight(44.0));
        }];
        
//        //问题
//        UILabel *questionLabel = [UILabel creatLabel:^(UILabel *label) {
//            label.ljTitle_font_textColor(model.questiondes,BoldFont(font(14)),HEXColor(@"#333333"));
//            label.textAlignment = NSTextAlignmentLeft;
//            label.numberOfLines = 0;
//            [label sizeToFit];
//        }];
//        [backView addSubview:questionLabel];
//        [questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(stockNameLabel);
//            make.right.equalTo(backView).offset(-kWidth(10.0));
//            make.top.equalTo(stockNameLabel.mas_bottom).offset(kHeight(10.0));
//            make.height.mas_equalTo(kHeight(14.0));
//        }];
        
        //推荐的标签
        UILabel *recommendedLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"推荐",MediumFont(font(10.0)),HEXColor(@"#999999"));
            label.backgroundColor = HEXColor(@"#F7F6FB");
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            [label sizeToFit];
        }];
        [recommendedLabel clipWithCornerRadius:kHeight(10.0) borderColor:HEXColor(@"#F7F6FB") borderWidth:0];
        [backView addSubview:recommendedLabel];
        [recommendedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(stockNameLabel.mas_bottom).offset(kHeight(14));
            make.left.equalTo(stockNameLabel);
            make.size.mas_equalTo(CGSizeMake(kWidth(40), kHeight(20)));
        }];
        
        //名师推荐的标签
        UILabel *teacherRecommendedLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"名师回复",MediumFont(font(10.0)),HEXColor(@"#999999"));
            label.backgroundColor = HEXColor(@"#F7F6FB");
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            [label sizeToFit];
        }];
        [teacherRecommendedLabel clipWithCornerRadius:kHeight(10.0) borderColor:HEXColor(@"#F7F6FB") borderWidth:0];
        [backView addSubview:teacherRecommendedLabel];
        [teacherRecommendedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(recommendedLabel);
            make.left.equalTo(recommendedLabel.mas_right).offset(kWidth(10.0));
            make.size.mas_equalTo(CGSizeMake(kWidth(60), kHeight(20)));
        }];
        
        //老师回答的内容
        NSString *answer = model.answer;
        UILabel *answerLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(answer,MediumFont(font(12)),HEXColor(@"#999999"));
            label.textAlignment = NSTextAlignmentLeft;
            label.numberOfLines = 0;
            [label sizeToFit];
        }];
        CGFloat answerHeight = [answer calculateSize:CGSizeMake(kWidth(220.0) - kWidth(21.0), MAXFLOAT)  font:MediumFont(font(12.0))].height;
        if(answerHeight > kHeight(84.0)) {
            answerHeight = kHeight(84.0);
        }
        [backView addSubview:answerLabel];
        [answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView).offset(kWidth(10.0));
            make.right.equalTo(backView).offset(-kWidth(11.0));
            make.top.equalTo(recommendedLabel.mas_bottom).offset(kHeight(14.0));
            make.height.mas_equalTo(answerHeight);
        }];
        
        //时间
        NSDate *date = [NSDate dateWithString:model.answertime formatString:@"yyyy-MM-dd HH:mm:ss"];
        UILabel *timeLabel = [UILabel creatLabel:^(UILabel *label) {
           label.ljTitle_font_textColor([NSString stringWithFormat:@"%@/%@/%@",[NSString convertDateSingleData:date.year],[NSString convertDateSingleData:date.month],[NSString convertDateSingleData:date.day]],MediumFont(font(10)),HEXColor(@"#999999"));
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
        [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
        return;
    }
    HJHomeStuntJudgeStockModel *model = self.listViewModel.stuntJudgeStockArray[tap.view.tag];
    NSDictionary *para = @{@"stuntId" : model.stuntId};
    [DCURLRouter pushURLString:@"route://stuntJudgeDetailVC" query:para animated:YES];
}


@end
