//
//  HJHomeExclusiveInfoView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/22.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJHomeExclusiveInfoViewCell.h"
#import "HJHomeViewModel.h"
#import "HJExclusiveInfoModel.h"
#import "HJInfoCheckPwdAlertView.h"
@interface HJHomeExclusiveInfoViewCell ()

@property (nonatomic,strong) HJHomeViewModel *listViewModel;
@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation HJHomeExclusiveInfoViewCell

- (void)hj_configSubViews {
    self.backgroundColor = white_color;
    
    //轮播图
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = Background_Color;
    _scrollView.scrollEnabled = YES;
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10));
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(kHeight(220));
    }];
}

- (void)reloadScrollViewWithImageArr:(NSArray *)assets{
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger assetCount = assets.count;
    CGFloat width = Screen_Width;
    CGFloat height = kHeight(55.0);
    for (NSInteger i = 0; i < assetCount; i++) {
        UIView *backView = [[UIView alloc] init];
        backView.frame = CGRectMake(0, height * i, width, height);
        backView.tag = i;
        backView.backgroundColor = white_color;
        [self.scrollView addSubview:backView];
        
        UITapGestureRecognizer *backViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewTap:)];
        [backView addGestureRecognizer:backViewTap];
        
        HJExclusiveInfoModel *infoModel = assets[i];
        NewsList *model = infoModel.newsList.firstObject;
        
        UIView *duJiaBackView = [[UIView alloc] init];
        duJiaBackView.backgroundColor = Background_Color;
        [backView addSubview:duJiaBackView];
        [duJiaBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView).offset(kWidth(10.0));
            make.top.equalTo(backView);
            make.size.mas_equalTo(CGSizeMake(kWidth(40), kWidth(40)));
        }];
        
        //独家文本
        UILabel *duJiaLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"独家",MediumFont(font(10)),white_color);
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = HEXColor(@"#22476B");
            [label sizeToFit];
        }];
        [duJiaBackView addSubview:duJiaLabel];
        [duJiaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(duJiaBackView);
            make.height.mas_equalTo(kHeight(20.0));
        }];
        
        //时间文本
        //日期
        NSDate *date = [NSDate dateWithString:model.createtime formatString:@"yyyy-MM-dd HH:mm:ss"];
        UILabel *timeLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor([NSString stringWithFormat:@"%@:%@",[NSString convertDateSingleData:date.hour],[NSString convertDateSingleData:date.minute]],MediumFont(font(10)),HEXColor(@"#000000"));
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = HEXColor(@"#ECECEC");
            [label sizeToFit];
        }];
        [duJiaBackView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(duJiaBackView);
            make.height.mas_equalTo(kHeight(20.0));
            make.bottom.equalTo(duJiaBackView);
        }];
        
        [duJiaBackView clipWithCornerRadius:5.0 borderColor:nil borderWidth:0];
        
        //分割线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithRed:29/255.0 green:48/255.0 blue:67/255.0 alpha:1];
        [backView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(duJiaBackView);
            make.width.mas_equalTo(kWidth(0.5));
            make.top.equalTo(duJiaBackView.mas_bottom);
            make.bottom.equalTo(backView);
        }];
        
        //牛人观点
        UIButton *niuPointBtn = [UIButton creatButton:^(UIButton *button) {
            button.ljTitle_font_titleColor_state(@"",MediumFont(font(10)),white_color,0);
            if(i == 0) {
                [button setBackgroundImage:V_IMAGE(@"牛人观点") forState:UIControlStateNormal
                 ];
                [button setTitle:model.newskindname forState:UIControlStateNormal];
                lineView.hidden = NO;
            } else if (i == 1) {
                [button setBackgroundImage:V_IMAGE(@"教学跟踪") forState:UIControlStateNormal
                 ];
                [button setTitle:model.newskindname forState:UIControlStateNormal];
                lineView.hidden = NO;
            } else if (i == 2) {
                [button setBackgroundImage:V_IMAGE(@"量化跟踪") forState:UIControlStateNormal
                 ];
                [button setTitle:model.newskindname forState:UIControlStateNormal];
                lineView.hidden = NO;
            } else if (i == 3) {
                [button setBackgroundImage:V_IMAGE(@"教学跟踪1") forState:UIControlStateNormal
                 ];
                [button setTitle:model.newskindname forState:UIControlStateNormal];
                lineView.hidden = YES;
            }
        }];
        [backView addSubview:niuPointBtn];
        [niuPointBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(duJiaBackView);
            make.right.equalTo(backView).offset(-kWidth(15.0));
            make.size.mas_equalTo(CGSizeMake(kWidth(55), kHeight(15)));
        }];
        
        //标题
        NSString *infoTitle = model.infomationtitle;
        if(model.infomationtitle.length > 10) {
            infoTitle = [NSString stringWithFormat:@"%@...",[model.infomationtitle substringToIndex:10]];
        }
        UILabel *titleLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(infoTitle,BoldFont(font(14)),HEXColor(@"#333333"));
            [label sizeToFit];        }];
        [backView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(duJiaBackView).offset(kHeight(4.0));
            make.bottom.equalTo(duJiaBackView.mas_centerY).offset(-kHeight(4.0));
            make.left.equalTo(duJiaBackView.mas_right).offset(kWidth(16.0));
            make.height.mas_equalTo(kHeight(14));
        }];
        
        //描述
        UILabel *desLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(model.des,MediumFont(font(13)),HEXColor(@"#666666"));
            [label sizeToFit];
        }];
        [backView addSubview:desLabel];
        [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(duJiaBackView.mas_centerY).offset(kHeight(4.0));
            make.left.equalTo(duJiaBackView.mas_right).offset(kWidth(16.0));
            make.right.equalTo(niuPointBtn.mas_left).offset(kWidth(-28.0));
            make.height.mas_equalTo(kHeight(13));
        }];
        
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY([[self.scrollView.subviews lastObject] frame]));
}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath{
    HJHomeViewModel *listViewModel = (HJHomeViewModel *)viewModel;
    self.listViewModel = listViewModel;
    [self reloadScrollViewWithImageArr:listViewModel.exclusiveInfoArray];
}

- (void)backViewTap:(UITapGestureRecognizer *)tap {
    HJExclusiveInfoModel *infoModel = self.listViewModel.exclusiveInfoArray[tap.view.tag];
    NewsList *model = infoModel.newsList.firstObject;
    if(MaJia) {
        if(model.infoId) {
            NSDictionary *para = @{@"infoId" : model.infoId
                                   };
            [DCURLRouter pushURLString:@"route://infoDetailVC" query:para animated:YES];
        }
        return;
    }
    HJInfoCheckPwdAlertView *alertView = [[HJInfoCheckPwdAlertView alloc] initWithTeacherId:model.teacherid BindBlock:^(BOOL success) {
        HJExclusiveInfoModel *infoModel = self.listViewModel.exclusiveInfoArray[tap.view.tag];
        NewsList *model = infoModel.newsList.firstObject;
        if(model.infoId) {
            NSDictionary *para = @{@"infoId" : model.infoId
                                   };
            [DCURLRouter pushURLString:@"route://infoDetailVC" query:para animated:YES];
        }
    }];
    [alertView show];
}


@end
