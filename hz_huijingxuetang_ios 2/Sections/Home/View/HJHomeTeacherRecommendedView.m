//
//  HJHomeTeacherRecommendedView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/22.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJHomeTeacherRecommendedView.h"


@interface HJHomeTeacherRecommendedView ()

@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation HJHomeTeacherRecommendedView

- (void)hj_configSubViews {
    
    self.backgroundColor = white_color;
    
    UIView *topiew = [[UIView alloc] init];
    topiew.backgroundColor = Background_Color;
    [self addSubview:topiew];
    [topiew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(kHeight(25.0));
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
    
    UILabel *timeKillLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"名师推荐",MediumFont(font(15)),HEXColor(@"#22476B"));
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
    _scrollView.backgroundColor = white_color;
    _scrollView.scrollEnabled = YES;
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView);
        make.right.equalTo(self);
        make.top.equalTo(lineView.mas_bottom).offset(kHeight(15.0));
        make.height.mas_equalTo(kHeight(126));
    }];
    
    
    [self reloadScrollViewWithImageArr:@[@"1",@"2",@"3",@"1",@"2",@"3"]];
}

- (void)reloadScrollViewWithImageArr:(NSArray *)assets{
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger assetCount = assets.count;
    CGFloat width = kWidth(76);
    CGFloat height = kHeight(126);
    CGFloat padding = kWidth(10.0);
    for (NSInteger i = 0; i < assetCount; i++) {
        UIView *backView = [[UIView alloc] init];
        backView.frame = CGRectMake((width + padding) * i, kHeight(7.0), width, height);
        backView.backgroundColor = white_color;
        [self.scrollView addSubview:backView];
        
        //图片
        UIImageView *imaV = [[UIImageView alloc] init];
        imaV.image = V_IMAGE(@"");
        imaV.backgroundColor = Background_Color;
        [backView addSubview:imaV];
        [imaV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(backView);
            make.width.height.mas_equalTo(kWidth(60));
        }];
        [imaV clipWithCornerRadius:30.0 borderColor:nil borderWidth:0];
        
        //live
        UIImageView *liveImageV = [[UIImageView alloc] init];
        liveImageV.image = V_IMAGE(@"特级");
        [backView addSubview:liveImageV];
        [liveImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imaV.mas_right).offset(-kWidth(29.0 / 2 + 3.0));
            make.top.equalTo(imaV.mas_top).offset(-kHeight(7.0));
            make.width.height.mas_equalTo(kWidth(29));
        }];
        
        //标题
        UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"何晶莹",BoldFont(font(13)),HEXColor(@"#333333"));
            label.textAlignment = NSTextAlignmentCenter;
            [label sizeToFit];
        }];
        [backView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imaV.mas_bottom).offset(kHeight(10.0));
            make.centerX.equalTo(imaV);
            make.height.mas_equalTo(kHeight(13));
        }];
        
        
        //职位
        UILabel *jobLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"股票分析师",MediumFont(font(11)),HEXColor(@"#999999"));
            label.textAlignment = NSTextAlignmentCenter;
            [label sizeToFit];
        }];
        [backView addSubview:jobLabel];
        [jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(7.0));
            make.left.equalTo(nameLabel);
            make.height.mas_equalTo(kHeight(11.0));
        }];
        
    }
    //self.scrollView.backgroundColor = [UIColor redColor];
    self.scrollView.contentSize = CGSizeMake((width + padding) * assetCount, CGRectGetMaxY([[self.scrollView.subviews lastObject] frame]));
    
}



@end
