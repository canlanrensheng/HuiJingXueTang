//
//  HJFindRecommondVideoCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/31.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJFindRecommondVideoCell.h"

#import <ZFPlayer/UIImageView+ZFCache.h>

#import "HJFindViewModel.h"
#import "HJFindRecommondModel.h"

@interface HJFindRecommondVideoCell ()

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, weak) id<ZFTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic,strong) UIImageView *iconImageV;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIButton *careBtn;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UILabel *dateLabel;

@property (nonatomic,strong) HJFindViewModel *viewModel;
@property (nonatomic,strong) HJFindRecommondModel *model;
@property (nonatomic,strong) UIImageView *topImageView;

@end

@implementation HJFindRecommondVideoCell

- (void)hj_configSubViews {
    
    //头像
    UIImageView *iconImageV = [[UIImageView alloc] init];
    iconImageV.image = V_IMAGE(@"默认头像");
    iconImageV.backgroundColor = Background_Color;
    [self addSubview:iconImageV];
    [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10.0));
        make.top.equalTo(self).offset(kHeight(15.0));
        make.width.height.mas_equalTo(kHeight(40));
    }];
    [iconImageV clipWithCornerRadius:kHeight(20.0) borderColor:nil borderWidth:0];
    
    //昵称
    UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"俞春",BoldFont(font(14)),HEXColor(@"#22476B"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageV).offset(kHeight(5.0));
        make.height.mas_equalTo(kHeight(14));
        make.left.equalTo(iconImageV.mas_right).offset(kWidth(5.0));
    }];
    
    //关注的
    UIButton *loodDetailBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"+ 关注",MediumFont(font(13)),HEXColor(@"#FF4400"),0);
        [button setTitle:@"+ 关注" forState:UIControlStateNormal];
        [button setTitle:@"已关注" forState:UIControlStateSelected];
        [button setTitleColor:RGBA(0, 0, 0, 0.4) forState:UIControlStateSelected];
        [button setTitleColor:HEXColor(@"#FF4400") forState:UIControlStateNormal];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if([APPUserDataIofo AccessToken].length <= 0) {
//                ShowMessage(@"您还未登录");
                [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
                return;
            }
            if(self.model.isinterest == 0) {
                [self.viewModel careOrCancleCareWithTeacherId:self.model.teacherid accessToken:[APPUserDataIofo AccessToken] insterest:@"1" Success:^{
                    button.selected = !button.selected;
                    [self.backRefreshSubject sendNext:@(1)];
                    self.model.isinterest = 1;
                    // 刷新关注的列表
                    if(self.viewModel.findSegmentType == FindSegmentTypeRecommond) {
                        //点击推荐模块关注的时候
                        //刷新关注模块的数据
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreFindCareData" object:nil userInfo:nil];
                        //本地刷新推荐模块的数据
                        NSDictionary *para = @{@"row" : @(self.indexPath.row),
                                               @"select" : @(1)
                                               };
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"FindRecommendVCClickOperation" object:nil userInfo:para];
                    }else {
                        //点击关注模块 刷新推荐模块的数据 不可能的情况因为关注模块不能点击关注，只能取消关注
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreFindCommondData" object:nil userInfo:nil];
                    }
                }];
            } else {
                [self.viewModel careOrCancleCareWithTeacherId:self.model.teacherid accessToken:[APPUserDataIofo AccessToken] insterest:@"0" Success:^{
                    button.selected = !button.selected;
                    self.model.isinterest = 0;
                    // 刷新关注的列表
                    if(self.viewModel.findSegmentType == FindSegmentTypeRecommond) {
                        //点击推荐模块的取消关注的时候
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreFindCareData" object:nil userInfo:nil];
                        //本地刷新推荐列表的数据
                        NSDictionary *para = @{@"row" : @(self.indexPath.row),
                                               @"select" : @(0)
                                               };
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"FindRecommendVCClickOperation" object:nil userInfo:para];
                    }else {
                        //点击关注模块取消选中的时候
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreFindCommondData" object:nil userInfo:nil];
                        //本地刷新关注模块列表的数据
                        NSDictionary *para = @{@"row" : @(self.indexPath.row),
                                               @"select" : @(0)
                                               };
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"FindCareVCClickOperation" object:nil userInfo:para];
                    }
                }];
            }
        }];
    }];
    [self addSubview:loodDetailBtn];
    [loodDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-kWidth(10));
        make.size.mas_equalTo(CGSizeMake(kWidth(45), kHeight(13)));
        make.centerY.equalTo(nameLabel);
    }];
    
    //描述
    UILabel *desLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(13)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(10.0));
        make.left.equalTo(nameLabel);
        make.right.equalTo(self).offset(-kWidth(10));
    }];
    
    _coverImageView = [[UIImageView alloc] init];
    _coverImageView.userInteractionEnabled = YES;
    _coverImageView.tag = 100;
    _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    _coverImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desLabel.mas_bottom).offset(kHeight(15));
        make.left.equalTo(self).offset(kWidth(55));
        make.right.equalTo(self).offset(-kWidth(10));
        make.height.mas_equalTo((Screen_Width - kWidth(65)) / 16 * 9);
    }];
    
    //顶部蒙版的试图
    _topImageView = [[UIImageView alloc] init];
    _topImageView.userInteractionEnabled = YES;
    _topImageView.backgroundColor = RGBA(0, 0, 0, 0.4);
    _topImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_coverImageView addSubview:_topImageView];
    [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desLabel.mas_bottom).offset(kHeight(15));
        make.left.equalTo(self).offset(kWidth(55));
        make.right.equalTo(self).offset(-kWidth(10));
        make.height.mas_equalTo((Screen_Width - kWidth(65)) / 16 * 9);
    }];
    
    //播放按钮
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playBtn setImage:[UIImage imageNamed:@"播放按钮"] forState:UIControlStateNormal];
    [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.coverImageView addSubview:self.playBtn];

    [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.coverImageView);
        make.size.mas_equalTo(CGSizeMake(kWidth(64), kWidth(64)));
    }];
    
    //日期
    UILabel *dateLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"1小时前",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_coverImageView.mas_bottom).offset(kHeight(15.0));
        make.left.equalTo(nameLabel);
        make.height.mas_equalTo(kHeight(11.0));
    }];
    
    self.iconImageV = iconImageV;
    self.nameLabel = nameLabel;
    self.careBtn = loodDetailBtn;
    self.contentLabel = desLabel;
    self.dateLabel = dateLabel;
}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    HJFindViewModel *listViewModel = (HJFindViewModel *)viewModel;
    self.viewModel = listViewModel;
    self.indexPath = indexPath;
    HJFindRecommondModel *model = nil;
    if(listViewModel.findSegmentType == 0) {
        model = listViewModel.findArray[indexPath.row];
    } else {
        model = listViewModel.careArray[indexPath.row];
    }
    self.viewModel = (HJFindViewModel *)viewModel;
    self.model = model;
    [self.iconImageV sd_setImageWithURL:URL(model.iconurl) placeholderImage:V_IMAGE(@"默认头像") options:SDWebImageRefreshCached];
    self.nameLabel.text = model.realname;
    self.careBtn.selected = model.isinterest == 1 ? YES : NO;
    self.contentLabel.text = model.dynamiccontent;
    self.dateLabel.text = [DateFormatter getDate:model.createtime];
    
    _coverImageView.image = model.coverVideoImg;
}

- (void)setDelegate:(id<ZFTableViewCellDelegate>)delegate withIndexPath:(NSIndexPath *)indexPath {
    self.delegate = delegate;
    self.indexPath = indexPath;
}

- (void)playBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_playTheVideoAtIndexPath:)]) {
        [self.delegate zf_playTheVideoAtIndexPath:self.indexPath];
    }
}

- (RACSubject *)backRefreshSubject {
    if(!_backRefreshSubject) {
        _backRefreshSubject = [[RACSubject alloc] init];
    }
    return _backRefreshSubject;
}

@end
