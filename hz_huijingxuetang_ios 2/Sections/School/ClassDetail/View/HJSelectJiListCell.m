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
    UILabel *jiNameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(14)),HEXColor(@"#333333"));
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:jiNameLabel];
    [jiNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kHeight(10.0));
        make.left.equalTo(self).offset(kWidth(11.0));
        make.height.mas_equalTo(kHeight(13));
    }];
    self.jiNameLabel = jiNameLabel;
    
    //点击试看的操作
    UILabel *tryToWatchLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"点击试看",MediumFont(font(10)),HEXColor(@"#22476B"));
        label.textAlignment = TextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:tryToWatchLabel];
    [tryToWatchLabel clipWithCornerRadius:kHeight(2.0) borderColor:HEXColor(@"#22476B") borderWidth:kHeight(1.0)];
    [tryToWatchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(jiNameLabel);
        make.size.mas_equalTo(CGSizeMake(kWidth(47.0), kHeight(15.0)));
        make.left.equalTo(jiNameLabel.mas_right).offset(kWidth(12.0));
    }];
    tryToWatchLabel.hidden = YES;
    self.tryToWatchLabel = tryToWatchLabel;
    
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
        make.left.equalTo(self).offset(kWidth(11.0));
        make.height.mas_equalTo(kHeight(11.0));
    }];
    self.playCountLabel = playCountLabel;
    
}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    HJClassDetailViewModel *listViewModel = (HJClassDetailViewModel *)viewModel;
    HJCourseSelectJiModel *model = listViewModel.selectJiArray[indexPath.row];
    if(model){
        self.jiNameLabel.text = model.videoname;
        if (model.isOnPlay) {
            self.tryToWatchLabel.hidden = YES;
            self.liveStatusImageV.image = V_IMAGE(@"正在播放状态");
        } else {
            if([listViewModel.model.buy isEqualToString:@"n"]){
                self.tryToWatchLabel.hidden = NO;
            } else {
                self.tryToWatchLabel.hidden = YES;
            }
            self.liveStatusImageV.image = V_IMAGE(@"播放");
        }

        //名称的图片
        NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
        NSString *videoValue = [defa valueForKey:model.videourl];
        if (videoValue.integerValue == 1) {
            self.jiNameLabel.textColor = HEXColor(@"#6e6e6e");
        } else {
            self.jiNameLabel.textColor = HEXColor(@"#333333");
        }
        self.playCountLabel.text = [NSString stringWithFormat:@"%@ | %@次播放",listViewModel.model.username,model.hits];
    }
}

@end
