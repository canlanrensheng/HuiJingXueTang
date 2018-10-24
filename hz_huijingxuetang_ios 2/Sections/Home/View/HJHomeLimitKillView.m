//
//  HJHomeLimitKillView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/22.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJHomeLimitKillView.h"

@interface HJHomeLimitKillView ()

@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation HJHomeLimitKillView

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
    
    UILabel *timeKillLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"限时秒杀",MediumFont(font(15)),HEXColor(@"#22476B"));
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
        make.top.equalTo(lineView.mas_bottom).offset(kHeight(22.0));
        make.height.mas_equalTo(kHeight(170));
    }];
    
    
    [self reloadScrollViewWithImageArr:@[@"1",@"2",@"3"]];
}

- (void)reloadScrollViewWithImageArr:(NSArray *)assets{
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger assetCount = assets.count;
    CGFloat width = kWidth(143);
    CGFloat height = kHeight(170);
    CGFloat padding = kWidth(15.0);
    for (NSInteger i = 0; i < assetCount; i++) {
        UIView *backView = [[UIView alloc] init];
        backView.frame = CGRectMake((width + padding) * i, 0, width, height);
        backView.backgroundColor = white_color;
        [self.scrollView addSubview:backView];
        
        
        backView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
        backView.layer.shadowOffset = CGSizeMake(0,1);
        backView.layer.shadowOpacity = 1;
        backView.layer.shadowRadius = 5;
        backView.layer.cornerRadius = 2.5;
        backView.clipsToBounds = YES;
        
        //图片
        UIImageView *imaV = [[UIImageView alloc] init];
        imaV.image = V_IMAGE(@"占位图");
        [backView addSubview:imaV];
        [imaV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(backView);
            make.height.mas_equalTo(kHeight(85));
        }];
        
        //标题
        UILabel *faultCodeLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"三板斧战法",MediumFont(font(14)),HEXColor(@"#333333"));
            [label sizeToFit];
        }];
        [backView addSubview:faultCodeLabel];
        [faultCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imaV.mas_bottom).offset(kHeight(10.0));
            make.left.equalTo(backView).offset(kWidth(5.0));
            make.height.mas_equalTo(kHeight(14));
        }];
        
        //价格
        UILabel *priceLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"￥1980",MediumFont(font(11)),HEXColor(@"#FF4400"));
            [label sizeToFit];
        }];
        [backView addSubview:priceLabel];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(faultCodeLabel.mas_bottom).offset(kHeight(9.0));
            make.left.equalTo(backView).offset(kWidth(5.0));
            make.height.mas_equalTo(kHeight(14));
        }];
        
        //原来的价格
        UILabel *originPriceLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"￥1980",MediumFont(font(11)),HEXColor(@"#999999"));
            [label sizeToFit];
        }];
        [backView addSubview:originPriceLabel];
        [originPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(priceLabel);
            make.left.equalTo(priceLabel.mas_right).offset(kWidth(5.0));
            make.height.mas_equalTo(kHeight(8.0));
        }];
        
        //画线
        UIView *priceLineView= [[UIView alloc] init];
        priceLineView.backgroundColor = HEXColor(@"#999999");
        [backView addSubview:priceLineView];
        [priceLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(priceLabel);
            make.left.right.equalTo(originPriceLabel);
            make.height.mas_equalTo(kHeight(1.0));
        }];
        
        //只剩下多少小时
        UILabel *leftTimeLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"只剩24小时",MediumFont(font(10)),HEXColor(@"#999999"));
            [label sizeToFit];
        }];
        [backView addSubview:leftTimeLabel];
        [leftTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(priceLabel.mas_bottom).offset(kHeight(19.0));
            make.left.equalTo(backView).offset(kWidth(5.0));
            make.height.mas_equalTo(kHeight(14));
        }];
        
        //立即秒杀
        UIButton *killBtn = [UIButton creatButton:^(UIButton *button) {
            button.ljTitle_font_titleColor_state(@"立即秒杀",MediumFont(font(11)),white_color,0);
            button.backgroundColor = HEXColor(@"#FF4400");
            [button clipWithCornerRadius:kHeight(2.5) borderColor:nil borderWidth:0];
            @weakify(self);
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                
            }];
        }];
        [backView addSubview:killBtn];
        [killBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backView).offset(-kWidth(5.0));
            make.centerY.equalTo(leftTimeLabel);
            make.size.mas_equalTo(CGSizeMake(kWidth(58), kHeight(23)));
        }];
    }
    //self.scrollView.backgroundColor = [UIColor redColor];
    self.scrollView.contentSize = CGSizeMake((width + padding) * assetCount, CGRectGetMaxY([[self.scrollView.subviews lastObject] frame]));

}

@end
