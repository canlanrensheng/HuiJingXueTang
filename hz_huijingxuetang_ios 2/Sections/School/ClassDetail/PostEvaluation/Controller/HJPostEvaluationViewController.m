//
//  HJPostEvaluationViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/25.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJPostEvaluationViewController.h"
#import "BMTextView.h"
@interface HJPostEvaluationViewController ()

@property (nonatomic,strong) BMTextView *textView;
@property (nonatomic,strong) NSMutableArray *starImgeViewArray;

@end

@implementation HJPostEvaluationViewController

- (void)hj_setNavagation {
    self.view.backgroundColor = Background_Color;
    self.title = @"发表评论";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"发表" font:MediumFont(font(13)) action:^(id sender) {
    
    }];
}

- (BMTextView *)textView{
    if(!_textView){
        _textView = [[BMTextView alloc] init];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.placeholder = @" 请输入您的评价";
        _textView.maxLimitCount = 100;
        _textView.showLimitString = YES;
        _textView.font = MediumFont(font(16));
        [_textView clipWithCornerRadius:kHeight(8.0) borderColor:nil borderWidth:0];
    }
    return _textView;
}

- (void)hj_configSubViews {
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = white_color;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(kHeight(45));
    }];
    
    //课程评分
    UILabel *courceScoreLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"课程评分",MediumFont(font(15)),HEXColor(@"#22476B"));
        label.textAlignment = TextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self.view addSubview:courceScoreLabel];
    [courceScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.left.equalTo(self.view).offset(kWidth(10.0));
        make.height.mas_equalTo(kHeight(12.0));
    }];
    
    //星级
    UIView *starView = [[UIView alloc] init];
    starView.backgroundColor = white_color;
    [self.view addSubview:starView];
    CGFloat totalWidth = kWidth(18) * 5 + kWidth(20.0) * 4;
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(courceScoreLabel.mas_right).offset(kWidth(20));
        make.centerY.equalTo(courceScoreLabel);
        make.height.mas_equalTo(kHeight(18));
        make.width.mas_equalTo(kWidth(totalWidth));
    }];
    
    self.starImgeViewArray = [NSMutableArray array];
    for(int i = 0; i < 5;i++) {
        UIImageView *starImageView = [[UIImageView alloc] init];
        starImageView.userInteractionEnabled = YES;
        starImageView.tag = i;
        starImageView.frame = CGRectMake((kWidth(20 + 18) * i), 0, kWidth(18), kWidth(18));
        starImageView.backgroundColor = white_color;
        starImageView.image = V_IMAGE(@"评价星 暗色");
        [starView addSubview:starImageView];
        
        UITapGestureRecognizer *starImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [starImageView addGestureRecognizer:starImgTap];
        
        [self.starImgeViewArray addObject:starImageView];
    }
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = HEXColor(@"#EAEAEA");
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(topView.mas_bottom);
        make.height.mas_equalTo(kHeight(1.0));
    }];
    
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(kHeight(10));
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(kHeight(150));
    }];
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    UIImageView *imV = (UIImageView *)tap.view;
    for (NSInteger i = 0 ;i <= imV.tag ;i++) {
        UIImageView *iconImageV = self.starImgeViewArray[i];
        iconImageV.image = V_IMAGE(@"评价星亮色");
    }
    for (NSInteger i = imV.tag + 1 ;i < 5;i++){
        UIImageView *iconImageV = self.starImgeViewArray[i];
        iconImageV.image = V_IMAGE(@"评价星 暗色");
    }
}

@end
