//
//  HJHomeLiveOnlineView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/22.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJHomeLiveOnlineView.h"

@interface HJHomeLiveOnlineView ()

@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation HJHomeLiveOnlineView

- (void)hj_configSubViews {
    
    self.backgroundColor = Background_Color;

    //限时特惠
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = HEXColor(@"#22476B");
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10.0));
        make.size.mas_equalTo(CGSizeMake(kWidth(2.0), kHeight(14)));
        make.top.equalTo(self).offset(kHeight(25));
    }];
    
    UILabel *timeKillLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"正在直播",MediumFont(font(15)),HEXColor(@"#22476B"));
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:timeKillLabel];
    [timeKillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineView);
        make.left.equalTo(lineView.mas_right).offset(kWidth(5.0));
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
        make.height.mas_equalTo(kHeight(160 + 3));
    }];
    
    
    [self reloadScrollViewWithImageArr:@[@"1",@"2",@"3",@"1",@"2",@"3"]];
}

- (void)reloadScrollViewWithImageArr:(NSArray *)assets{
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger assetCount = assets.count;
    CGFloat width = kWidth(145);
    CGFloat height = kHeight(160);
    CGFloat padding = kWidth(8.0);
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
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTap:)];
        [backView addGestureRecognizer:tap];
        
        //图片
        UIImageView *imaV = [[UIImageView alloc] init];
        imaV.image = V_IMAGE(@"占位图");
        imaV.backgroundColor = white_color;
        [backView addSubview:imaV];
        [imaV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(backView);
            make.height.mas_equalTo(kHeight(100));
        }];
        
        //live
        UIImageView *liveImageV = [[UIImageView alloc] init];
        liveImageV.image = V_IMAGE(@"直播ICON1");
        [backView addSubview:liveImageV];
        [liveImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imaV);
            make.top.equalTo(imaV).offset(kHeight(10.0));
        }];
        
        
        //头像图片
        UIImageView *iconImageV = [[UIImageView alloc] init];
        iconImageV.image = V_IMAGE(@"");
        [iconImageV clipWithCornerRadius:kWidth(20.0) borderColor:nil borderWidth:0];
        iconImageV.backgroundColor = Background_Color;
        [backView addSubview:iconImageV];
        [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView).offset(kWidth(10));
            make.width.height.mas_equalTo(kWidth(40));
            make.top.equalTo(imaV.mas_bottom).offset(kHeight(10.0));
        }];
        
        //标题
        UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"余春",MediumFont(font(13)),HEXColor(@"#333333"));
            [label sizeToFit];
        }];
        [backView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconImageV).offset(kHeight(3.0));
            make.left.equalTo(iconImageV.mas_right).offset(kWidth(11.0));
            make.height.mas_equalTo(kHeight(13));
        }];
  
        
        //职位
        UILabel *jobLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"慧鲸特邀专家",MediumFont(font(13)),HEXColor(@"#333333"));
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

- (void)backTap:(UITapGestureRecognizer *)tap {
    [DCURLRouter pushURLString:@"route://schoolDetailLiveVC" animated:YES];
}


@end
