//
//  HJSchoolDetailReviewPastCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/26.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSchoolDetailReviewPastCell.h"
#import "HJSchoolLiveDetailViewModel.h"
#import "HJPastListModel.h"

@interface HJSchoolDetailReviewPastCell()

@property (nonatomic,strong) UILabel *liveNameLabel;
@property (nonatomic,strong) UILabel *backPlaylabel;
@property (nonatomic,strong) UILabel *playingLabel;
@property (nonatomic,strong) UILabel *playStartTimeLabel;
@property (nonatomic,strong) UIImageView *playImaV;

@end

@implementation HJSchoolDetailReviewPastCell

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
    self.liveNameLabel = jiNameLabel;
    
    //直播的状态
    UILabel *liveStatusLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"回放",MediumFont(font(10)),HEXColor(@"#22476B"));
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = white_color;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [liveStatusLabel clipWithCornerRadius:kHeight(2.5) borderColor:HEXColor(@"#22476B") borderWidth:kHeight(1.0)];
    [self addSubview:liveStatusLabel];
    [liveStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(jiNameLabel);
        make.left.equalTo(jiNameLabel.mas_right).offset(kWidth(8.0));
        make.size.mas_equalTo(CGSizeMake(kWidth(25), kHeight(15)));
    }];
    self.backPlaylabel = liveStatusLabel;
    liveStatusLabel.hidden = NO;
    
    UILabel *onLiveStatusLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"正在播放",MediumFont(font(10)),white_color);
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = HEXColor(@"#0ABC64");
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [onLiveStatusLabel clipWithCornerRadius:kHeight(2.5) borderColor:nil borderWidth:0];
    [self addSubview:onLiveStatusLabel];
    [onLiveStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(jiNameLabel);
        make.left.equalTo(jiNameLabel.mas_right).offset(kWidth(8.0));
        make.size.mas_equalTo(CGSizeMake(kWidth(47), kHeight(15)));
    }];
    
    self.playingLabel = onLiveStatusLabel;
    
    UIImageView *liveStatusImageV = [[UIImageView alloc] init];
    liveStatusImageV.image = V_IMAGE(@"播放");
    [self addSubview:liveStatusImageV];
    [liveStatusImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-kWidth(10));
        make.width.height.mas_equalTo(kWidth(24));
    }];
    
    self.playImaV = liveStatusImageV;
    
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
    
    self.playStartTimeLabel = playCountLabel;
}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    HJSchoolLiveDetailViewModel *listViewModel = (HJSchoolLiveDetailViewModel *)viewModel;
    HJPastListModel *model = listViewModel.pastListArray[indexPath.row];
    self.liveNameLabel.text = model.coursename;
    NSDate *date = [NSDate dateWithString:model.starttime formatString:@"yyyy-MM-dd HH:mm:ss"];
    self.playStartTimeLabel.text = [NSString stringWithFormat:@"%ld-%@-%@",date.year,[NSString convertDateSingleData:date.month],[NSString convertDateSingleData:date.day]];
    if ([listViewModel.courseid isEqualToString:model.courseid]) {
        self.playingLabel.hidden = NO;
        self.backPlaylabel.hidden = YES;
        self.playImaV.image = V_IMAGE(@"直播icon-1");
    } else {
//        if (model.isPlay) {
//            self.playingLabel.hidden = NO;
//            self.backPlaylabel.hidden = YES;
//            self.playImaV.image = V_IMAGE(@"直播icon-1");
//        } else {
        self.playingLabel.hidden = YES;
        self.backPlaylabel.hidden = NO;
        self.playImaV.image = V_IMAGE(@"播放");
//        }
    }
}

@end

