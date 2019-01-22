//
//  HJSelectJiListCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/25.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSelectJiListCell.h"
#import "HJClassDetailViewModel.h"
#import "HJCourseSelectJiModel.h"

@interface HJSelectJiListCell ()

@property (nonatomic,strong) UILabel *jiNameLabel;
@property (nonatomic,strong) UILabel *liveStatusLabel;
@property (nonatomic,strong) UILabel *onLiveStatusLabel;
//点击试看
@property (nonatomic,strong) UILabel *tryToWatchLabel;
//播放的图片
@property (nonatomic,strong) UIImageView *liveStatusImageV;
@property (nonatomic,strong) UILabel *playCountLabel;

@end

@implementation HJSelectJiListCell

- (void)hj_configSubViews {
    
    //点击试看的操作
    UILabel *tryToWatchLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"试看",MediumFont(font(10)),HEXColor(@"#22476B"));
        label.textAlignment = TextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:tryToWatchLabel];
    [tryToWatchLabel clipWithCornerRadius:kHeight(2.5) borderColor:HEXColor(@"#22476B") borderWidth:kHeight(1.0)];
    [tryToWatchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kHeight(10.0));
        make.left.equalTo(self).offset(kWidth(11.0));
        make.height.mas_equalTo(kHeight(14));
        make.width.mas_equalTo(kHeight(29.0));
    }];
//    tryToWatchLabel.hidden = YES;
    self.tryToWatchLabel = tryToWatchLabel;
    
    
    UILabel *jiNameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(14)),HEXColor(@"#333333"));
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:jiNameLabel];
    [jiNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kHeight(10.0));
        make.left.equalTo(tryToWatchLabel.mas_right).offset(kWidth(7.0));
        make.height.mas_equalTo(kHeight(13));
    }];
    self.jiNameLabel = jiNameLabel;
    
    
    UIImageView *liveStatusImageV = [[UIImageView alloc] init];
    liveStatusImageV.image = V_IMAGE(@"播放");
    [self addSubview:liveStatusImageV];
    [liveStatusImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-kWidth(10));
        make.width.height.mas_equalTo(kWidth(24));
    }];
    self.liveStatusImageV = liveStatusImageV;
    
    //课程的播放的次数
    UILabel *playCountLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(11)),HEXColor(@"#999999"));
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:playCountLabel];
    [playCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(jiNameLabel.mas_bottom).offset(kHeight(5.0));
        make.left.equalTo(jiNameLabel);
        make.height.mas_equalTo(kHeight(11.0));
    }];
    self.playCountLabel = playCountLabel;
    
}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    HJClassDetailViewModel *listViewModel = (HJClassDetailViewModel *)viewModel;
    HJCourseSelectJiModel *model = listViewModel.selectJiArray[indexPath.row];
    if(model){
        self.jiNameLabel.text = model.videoname;
        if ([model.videoid isEqualToString:listViewModel.selectCourseId]) {
            self.liveStatusImageV.image = V_IMAGE(@"正在播放状态");
            self.backgroundColor = HEXColor(@"#F9FBFF");
        } else {
            self.liveStatusImageV.image = V_IMAGE(@"播放");
            self.backgroundColor = white_color;
        }
        
        if([listViewModel.model.buy isEqualToString:@"n"]){
            self.tryToWatchLabel.text = @"试看";
        } else {
            self.tryToWatchLabel.text = @"学习";
        }

        //名称的图片
        NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
        NSString *videoValue = [defa valueForKey:model.videourl];
        //标记是否已经播放
        if (videoValue.integerValue == 1) {
            self.jiNameLabel.textColor = HEXColor(@"#6e6e6e");
        } else {
            self.jiNameLabel.textColor = HEXColor(@"#333333");
        }
        self.playCountLabel.text = [NSString stringWithFormat:@"%@ | %@次播放",listViewModel.model.username,model.hits];
    }
}

@end
