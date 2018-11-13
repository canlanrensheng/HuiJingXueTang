//
//  HJFindRecommondTextPicLinkCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/1.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJFindRecommondTextPicLinkCell.h"
#import "LJAvatarBrowser.h"
#import "HJFindViewModel.h"
#import "HJFindRecommondModel.h"
#import "LJAvatarBrowser.h"

@interface HJFindRecommondTextPicLinkCell ()

@property (nonatomic,strong) UIImageView *iconImageV;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIButton *careBtn;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIImageView *linkImageView;
@property (nonatomic,strong) UILabel *warnLabel;

@property (nonatomic,strong) HJFindViewModel *viewModel;
@property (nonatomic,strong) HJFindRecommondModel *model;

@end

@implementation HJFindRecommondTextPicLinkCell

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
                ShowMessage(@"您还未登录");
                [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
                return;
            }
            if(self.model.isinterest == 0) {
                [self.viewModel careOrCancleCareWithTeacherId:self.model.teacherid accessToken:[APPUserDataIofo AccessToken] insterest:@"1" Success:^{
                    button.selected = !button.selected;
                }];
            } else {
                [self.viewModel careOrCancleCareWithTeacherId:self.model.teacherid accessToken:[APPUserDataIofo AccessToken] insterest:@"0" Success:^{
                    button.selected = !button.selected;
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
        label.ljTitle_font_textColor(@"今晚八点三十分我将准时开播为大家带来最新一期的股市快评希望各位学员准时参加！",MediumFont(font(13)),HEXColor(@"#333333"));
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
    
    //刷新数据
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = white_color;
    _scrollView.scrollEnabled = YES;
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(55));
        make.right.equalTo(self).offset(-kWidth(10.0));
        make.top.equalTo(desLabel.mas_bottom).offset(kHeight(10.0));
        make.height.mas_equalTo(kHeight(100));
    }];
    
    //链接
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = HEXColor(@"#F2F5FA");
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(55));
        make.top.equalTo(_scrollView.mas_bottom).offset(kHeight(15));
        make.height.mas_equalTo(kHeight(60));
        make.right.equalTo(self).offset(-kWidth(10));
    }];
    
    //图片链接
    UIImageView *linkImageView = [[UIImageView alloc] init];
    [backView addSubview:linkImageView];
    [linkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView);
        make.size.mas_equalTo(CGSizeMake(kWidth(40), kHeight(40)));
        make.left.equalTo(backView).offset(kWidth(10));
    }];
    
    //文本
    UILabel *warnLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"点击查阅文章",MediumFont(font(13)),HEXColor(@"#141E2F"));
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [backView addSubview:warnLabel];
    [warnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(linkImageView);
        make.left.equalTo(linkImageView.mas_right).offset(kWidth(10.0));
    }];
    
    UIView *coverView = [[UIView alloc] init];
    coverView.backgroundColor = RGBA(0, 0, 0, 0.4);
    [backView addSubview:coverView];
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(linkImageView);
    }];
    
    //蒙版
    UIImageView *coverImageView = [[UIImageView alloc] init];
    coverImageView.image = V_IMAGE(@"链接标志");
    [backView addSubview:coverImageView];
    [coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(linkImageView);
        make.size.mas_equalTo(CGSizeMake(kWidth(24), kHeight(24)));
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
        make.top.equalTo(backView.mas_bottom).offset(kHeight(15.0));
        make.left.equalTo(nameLabel);
        make.height.mas_equalTo(kHeight(11.0));
    }];
    
    self.iconImageV = iconImageV;
    self.nameLabel = nameLabel;
    self.careBtn = loodDetailBtn;
    self.contentLabel = desLabel;
    self.dateLabel = dateLabel;
}

- (void)reloadScrollViewWithImageArr:(NSArray *)assets{
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger assetCount = assets.count;
    CGFloat padding = kWidth(10);
    CGFloat width = (Screen_Width - kWidth(55) - kWidth(10) - padding * 2 ) / 3;
    CGFloat height = width;
    for (NSInteger i = 0; i < assetCount; i++) {
        int lie = i % 3;
        int hang = (int)(i / 3);
        UIImageView *imaView = [[UIImageView alloc] init];
        imaView.frame = CGRectMake((width + padding) * lie, (height + padding) * hang, width, height);
        imaView.backgroundColor = Background_Color;
        imaView.userInteractionEnabled = YES;
        [self.scrollView addSubview:imaView];
        [imaView sd_setImageWithURL:URL(assets[i]) placeholderImage:V_IMAGE(@"占位图")];
        UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [imaView addGestureRecognizer:ta];
    }
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width - kWidth(55) - kWidth(10) , CGRectGetMaxY([[self.scrollView.subviews lastObject] frame]));
    [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(55));
        make.right.equalTo(self).offset(-kWidth(10.0));
        make.top.equalTo(self.contentLabel.mas_bottom).offset(kHeight(10.0));
        make.height.mas_equalTo(CGRectGetMaxY([[self.scrollView.subviews lastObject] frame]));
    }];
}

- (void)tapClick:(UITapGestureRecognizer *)tap{
    UIImageView *tapView = (UIImageView *)tap.view;
    [LJAvatarBrowser showImageView:tapView];
}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    HJFindViewModel *listViewModel = (HJFindViewModel *)viewModel;
    HJFindRecommondModel *model = nil;
    if(listViewModel.findSegmentType == 0) {
        model = listViewModel.findArray[indexPath.row];
    } else {
        model = listViewModel.careArray[indexPath.row];
    }
    self.viewModel = (HJFindViewModel *)viewModel;
    self.model = model;
    [self.iconImageV sd_setImageWithURL:URL(model.iconurl) placeholderImage:V_IMAGE(@"默认头像")];
    self.nameLabel.text = model.realname;
    self.careBtn.selected = model.isinterest == 1 ? YES : NO;
    self.contentLabel.text = model.dynamiccontent;
    self.dateLabel.text = [DateFormatter getDate:model.createtime];
    
    [self reloadScrollViewWithImageArr:model.picArray];
}

@end
